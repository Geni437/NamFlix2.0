<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Stripe\Exception\SignatureVerificationException;
use Stripe\StripeClient;
use Stripe\Webhook;
use UnexpectedValueException;

class BillingController extends Controller
{
    private function stripe(): StripeClient
    {
        return new StripeClient(config('services.stripe.secret'));
    }

    private function findUserByCustomerId(string $customerId): ?User
    {
        return User::where('stripe_customer_id', $customerId)->first();
    }

    // POST /api/v1/billing/create-checkout-session
    public function createCheckoutSession(Request $request): JsonResponse
    {
        $request->validate(['plan' => 'required|in:monthly,annual']);

        $user = $request->user();
        $stripe = $this->stripe();

        if (!$user->stripe_customer_id) {
            $customer = $stripe->customers->create([
                'email' => $user->email,
                'metadata' => ['user_id' => $user->id],
            ]);
            $user->update(['stripe_customer_id' => $customer->id]);
        }

        $priceId = $request->plan === 'monthly'
            ? config('services.stripe.monthly_price_id')
            : config('services.stripe.annual_price_id');

        $frontendUrl = config('services.frontend_url');

        $session = $stripe->checkout->sessions->create([
            'mode' => 'subscription',
            'customer' => $user->stripe_customer_id,
            'line_items' => [[
                'price' => $priceId,
                'quantity' => 1,
            ]],
            'success_url' => "{$frontendUrl}/pro/success?session_id={CHECKOUT_SESSION_ID}",
            'cancel_url' => "{$frontendUrl}/pro",
            'allow_promotion_codes' => true,
        ]);

        return response()->json([
            'success' => true,
            'data' => ['checkout_url' => $session->url],
        ]);
    }

    // POST /api/v1/billing/portal
    public function portal(Request $request): JsonResponse
    {
        $user = $request->user();

        if (!$user->stripe_customer_id) {
            return response()->json([
                'success' => false,
                'message' => 'No Stripe subscription found',
                'code' => 'NO_SUBSCRIPTION',
            ], 404);
        }

        $session = $this->stripe()->billingPortal->sessions->create([
            'customer' => $user->stripe_customer_id,
            'return_url' => config('services.frontend_url') . '/pro',
        ]);

        return response()->json([
            'success' => true,
            'data' => ['portal_url' => $session->url],
        ]);
    }

    // GET /api/v1/billing/status
    public function status(Request $request): JsonResponse
    {
        $user = $request->user();
        $isPro = $user->isPro();

        return response()->json([
            'success' => true,
            'data' => [
                'is_pro' => $isPro,
                'pro_expires_at' => $user->pro_expires_at?->toIso8601String(),
                'plan' => $user->stripe_subscription_id ? 'stripe' : ($isPro ? 'iap' : null),
                'next_billing_date' => $user->pro_expires_at?->toIso8601String(),
                'stripe_customer_id' => $user->stripe_customer_id ? true : false, // presence only
            ],
        ]);
    }

    // POST /api/v1/billing/webhook  (NO auth middleware — Stripe calls this)
    public function webhook(Request $request): JsonResponse
    {
        $payload = $request->getContent();
        $sigHeader = $request->header('Stripe-Signature');
        $secret = config('services.stripe.webhook_secret');

        try {
            $event = Webhook::constructEvent($payload, $sigHeader, $secret);
        } catch (UnexpectedValueException) {
            return response()->json(['error' => 'Invalid payload'], 400);
        } catch (SignatureVerificationException) {
            return response()->json(['error' => 'Invalid signature'], 400);
        }

        match ($event->type) {
            'checkout.session.completed'      => $this->handleCheckoutCompleted($event->data->object),
            'customer.subscription.updated'   => $this->handleSubscriptionUpdated($event->data->object),
            'customer.subscription.deleted'   => $this->handleSubscriptionDeleted($event->data->object),
            'invoice.payment_failed'          => $this->handlePaymentFailed($event->data->object),
            default                           => null,
        };

        return response()->json(['received' => true]);
    }

    // POST /api/v1/billing/verify-iap  (mobile in-app purchase verification)
    public function verifyIap(Request $request): JsonResponse
    {
        $request->validate([
            'purchase_token' => 'required|string',
            'product_id'     => 'required|string|in:namflix_pro_monthly,namflix_pro_annual',
            'platform'       => 'required|string|in:android,ios',
        ]);

        $user = $request->user();

        return $request->platform === 'android'
            ? $this->verifyAndroidPurchase($user, $request->purchase_token, $request->product_id)
            : $this->verifyIosPurchase($user, $request->purchase_token, $request->product_id);
    }

    // ─── Stripe Webhook Handlers ────────────────────────────────────────────────

    private function handleCheckoutCompleted(object $session): void
    {
        $subscriptionId = $session->subscription ?? null;
        if (!$subscriptionId) return;

        $user = $this->findUserByCustomerId($session->customer);
        if (!$user) return;

        $subscription = $this->stripe()->subscriptions->retrieve($subscriptionId);

        $user->update([
            'is_pro'                  => true,
            'stripe_subscription_id'  => $subscriptionId,
            'pro_expires_at'          => Carbon::createFromTimestamp($subscription->current_period_end),
        ]);
    }

    private function handleSubscriptionUpdated(object $subscription): void
    {
        $user = $this->findUserByCustomerId($subscription->customer);
        if (!$user) return;

        $isActive = in_array($subscription->status, ['active', 'trialing']);

        $user->update([
            'is_pro'                 => $isActive,
            'stripe_subscription_id' => $subscription->id,
            'pro_expires_at'         => $isActive
                ? Carbon::createFromTimestamp($subscription->current_period_end)
                : null,
        ]);
    }

    private function handleSubscriptionDeleted(object $subscription): void
    {
        $user = $this->findUserByCustomerId($subscription->customer);
        if (!$user) return;

        $user->update([
            'is_pro'                 => false,
            'pro_expires_at'         => null,
            'stripe_subscription_id' => null,
        ]);
    }

    private function handlePaymentFailed(object $invoice): void
    {
        $user = $this->findUserByCustomerId($invoice->customer);
        if (!$user || !$user->is_pro) return;

        // 3-day grace period — only shorten the expiry, never extend it
        $gracePeriodEnd = now()->addDays(3);

        if ($user->pro_expires_at === null || $user->pro_expires_at->lt($gracePeriodEnd)) {
            $user->update(['pro_expires_at' => $gracePeriodEnd]);
        }
    }

    // ─── IAP Verification ───────────────────────────────────────────────────────

    private function verifyAndroidPurchase(User $user, string $purchaseToken, string $productId): JsonResponse
    {
        $accessToken = $this->getGoogleAccessToken();
        if (!$accessToken) {
            return response()->json(['success' => false, 'message' => 'Store verification unavailable'], 503);
        }

        $package = config('services.google_play.package_name');
        $url = "https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{$package}/purchases/subscriptions/{$productId}/tokens/{$purchaseToken}";

        $res = Http::withToken($accessToken)->get($url);

        if (!$res->successful()) {
            return response()->json(['success' => false, 'message' => 'Purchase verification failed'], 400);
        }

        $data = $res->json();

        if (($data['acknowledgementState'] ?? 0) !== 1) {
            return response()->json(['success' => false, 'message' => 'Purchase not acknowledged'], 400);
        }

        // paymentState: 1 = received, 2 = free trial
        if (!in_array($data['paymentState'] ?? 0, [1, 2])) {
            return response()->json(['success' => false, 'message' => 'Payment not completed'], 400);
        }

        $expiryMs = (int) ($data['expiryTimeMillis'] ?? 0);
        $expiresAt = $expiryMs > 0 ? Carbon::createFromTimestampMs($expiryMs) : now()->addMonth();

        $user->update(['is_pro' => true, 'pro_expires_at' => $expiresAt]);

        return response()->json([
            'success' => true,
            'data' => ['is_pro' => true, 'pro_expires_at' => $expiresAt->toIso8601String()],
        ]);
    }

    private function verifyIosPurchase(User $user, string $receiptData, string $productId): JsonResponse
    {
        $sharedSecret = config('services.apple.shared_secret');

        // Try production first; Apple returns status 21007 when receipt is from sandbox
        $urls = [
            'https://buy.itunes.apple.com/verifyReceipt',
            'https://sandbox.itunes.apple.com/verifyReceipt',
        ];

        foreach ($urls as $url) {
            $res = Http::post($url, [
                'receipt-data'              => $receiptData,
                'password'                  => $sharedSecret,
                'exclude-old-transactions'  => true,
            ]);

            if (!$res->successful()) continue;

            $data = $res->json();
            $status = $data['status'] ?? -1;

            if ($status === 21007) continue; // sandbox receipt — retry on sandbox URL

            if ($status !== 0) {
                return response()->json(['success' => false, 'message' => 'Invalid receipt'], 400);
            }

            $matching = collect($data['latest_receipt_info'] ?? [])
                ->where('product_id', $productId)
                ->sortByDesc('expires_date_ms')
                ->first();

            if (!$matching) {
                return response()->json(['success' => false, 'message' => 'No matching subscription'], 400);
            }

            $expiryMs = (int) ($matching['expires_date_ms'] ?? 0);
            $expiresAt = $expiryMs > 0 ? Carbon::createFromTimestampMs($expiryMs) : now()->addMonth();

            if ($expiresAt->isPast()) {
                return response()->json(['success' => false, 'message' => 'Subscription has expired'], 400);
            }

            $user->update(['is_pro' => true, 'pro_expires_at' => $expiresAt]);

            return response()->json([
                'success' => true,
                'data' => ['is_pro' => true, 'pro_expires_at' => $expiresAt->toIso8601String()],
            ]);
        }

        return response()->json(['success' => false, 'message' => 'Receipt verification failed'], 400);
    }

    private function getGoogleAccessToken(): ?string
    {
        $json = config('services.google_play.service_account_json');
        if (!$json) return null;

        try {
            $creds = json_decode($json, true, flags: JSON_THROW_ON_ERROR);
            $now = time();

            $header = rtrim(strtr(base64_encode(json_encode(['alg' => 'RS256', 'typ' => 'JWT'])), '+/', '-_'), '=');
            $claim  = rtrim(strtr(base64_encode(json_encode([
                'iss'   => $creds['client_email'],
                'scope' => 'https://www.googleapis.com/auth/androidpublisher',
                'aud'   => 'https://oauth2.googleapis.com/token',
                'iat'   => $now,
                'exp'   => $now + 3600,
            ])), '+/', '-_'), '=');

            $signingInput = "{$header}.{$claim}";
            $key = openssl_pkey_get_private($creds['private_key']);
            openssl_sign($signingInput, $sig, $key, OPENSSL_ALGO_SHA256);
            $jwt = "{$signingInput}." . rtrim(strtr(base64_encode($sig), '+/', '-_'), '=');

            $res = Http::asForm()->post('https://oauth2.googleapis.com/token', [
                'grant_type' => 'urn:ietf:params:oauth:grant-type:jwt-bearer',
                'assertion'  => $jwt,
            ]);

            return $res->json('access_token');
        } catch (\Throwable) {
            return null;
        }
    }
}

<?php

namespace App\Http\Middleware;

use App\Models\User;
use Closure;
use Firebase\JWT\JWT;
use Firebase\JWT\Key;
use Firebase\JWT\ExpiredException;
use Firebase\JWT\SignatureInvalidException;
use Firebase\JWT\BeforeValidException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class VerifySupabaseToken
{
    public function handle(Request $request, Closure $next)
    {
        $authHeader = $request->header('Authorization');

        if (!$authHeader || !str_starts_with($authHeader, 'Bearer ')) {
            return response()->json([
                'success' => false,
                'message' => 'Missing or invalid authorization header',
                'code' => 'UNAUTHORIZED',
            ], 401);
        }

        $token = substr($authHeader, 7);

        try {
            $secret = config('services.supabase.jwt_secret');

            if (empty($secret)) {
                throw new \RuntimeException('Supabase JWT secret not configured');
            }

            $decoded = JWT::decode($token, new Key($secret, 'HS256'));

            $userId = $decoded->sub ?? null;
            $email = $decoded->email ?? null;

            if (!$userId) {
                throw new \RuntimeException('Invalid token: missing user ID');
            }

            $user = User::find($userId);

            if (!$user) {
                $user = User::create([
                    'id' => $userId,
                    'email' => $email ?? '',
                ]);
            }

            if ($user->is_banned) {
                return response()->json([
                    'success' => false,
                    'message' => 'Your account has been suspended',
                    'code' => 'ACCOUNT_BANNED',
                ], 403);
            }

            $user->update(['last_seen_at' => now()]);

            Auth::setUser($user);

            return $next($request);

        } catch (ExpiredException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Token has expired',
                'code' => 'TOKEN_EXPIRED',
            ], 401);
        } catch (SignatureInvalidException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Invalid token signature',
                'code' => 'TOKEN_INVALID',
            ], 401);
        } catch (BeforeValidException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Token not yet valid',
                'code' => 'TOKEN_NOT_VALID_YET',
            ], 401);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Authentication failed',
                'code' => 'AUTH_FAILED',
            ], 401);
        }
    }
}

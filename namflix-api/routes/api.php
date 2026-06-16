<?php

use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\ChannelController;
use App\Http\Controllers\Api\CountryController;
use App\Http\Controllers\Api\EpgController;
use App\Http\Controllers\Api\FavoriteController;
use App\Http\Controllers\Api\HistoryController;
use App\Http\Controllers\Api\LanguageController;
use App\Http\Controllers\Api\RegionController;
use App\Http\Controllers\Api\SearchController;
use App\Http\Controllers\Api\StreamReportController;
use App\Http\Controllers\Api\TrendingController;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Api\BillingController;
use App\Services\EpgSyncService;
use App\Services\IptvSyncService;
use App\Services\StreamHealthService;
use Illuminate\Support\Facades\Route;

Route::prefix('v1')->group(function () {
    // Public platform settings (prices shown on Pro page etc.)
    Route::get('/settings', function () {
        return response()->json([
            'success' => true,
            'data' => [
                'platform_name'      => \App\Models\Setting::get('platform_name', 'NamFlix'),
                'pro_monthly_price'  => (float) \App\Models\Setting::get('pro_monthly_price', '2.99'),
                'pro_annual_price'   => (float) \App\Models\Setting::get('pro_annual_price', '19.99'),
                'max_free_favorites' => (int) \App\Models\Setting::get('max_free_favorites', '20'),
            ],
        ]);
    });

    // Public routes
    Route::get('/channels', [ChannelController::class, 'index']);
    Route::get('/channels/{id}', [ChannelController::class, 'show']);
    Route::get('/channels/{id}/streams', [ChannelController::class, 'streams']);
    Route::get('/categories', [CategoryController::class, 'index']);
    Route::get('/countries', [CountryController::class, 'index']);
    Route::get('/languages', [LanguageController::class, 'index']);
    Route::get('/regions', [RegionController::class, 'index']);
    Route::get('/search', [SearchController::class, 'index']);
    Route::get('/trending', [TrendingController::class, 'index']);
    Route::get('/epg/{channel_id}', [EpgController::class, 'show']);
    Route::post('/stream-reports', [StreamReportController::class, 'store']);

    // Stripe webhook — NO auth (Stripe calls this directly, verified by signature)
    Route::post('/billing/webhook', [BillingController::class, 'webhook']);

    // Internal cron endpoints — callable by Supabase Edge Functions & server cron
    // Protected by X-Cron-Secret header, NOT by Supabase JWT
    Route::middleware('cron.secret')->prefix('internal')->group(function () {
        Route::post('/sync-iptv', function () {
            $result = app(IptvSyncService::class)->sync();
            return response()->json(['success' => true, 'result' => $result]);
        });

        Route::post('/check-streams', function () {
            $result = app(StreamHealthService::class)->checkAll();
            return response()->json(['success' => true, 'result' => $result]);
        });

        Route::post('/sync-epg', function () {
            $result = app(EpgSyncService::class)->sync();
            return response()->json(['success' => true, 'result' => $result]);
        });
    });

    // Protected routes
    Route::middleware('supabase.auth')->group(function () {
        // Billing
        Route::post('/billing/create-checkout-session', [BillingController::class, 'createCheckoutSession']);
        Route::post('/billing/portal', [BillingController::class, 'portal']);
        Route::get('/billing/status', [BillingController::class, 'status']);
        Route::post('/billing/verify-iap', [BillingController::class, 'verifyIap']);

        Route::get('/me', [UserController::class, 'show']);
        Route::put('/me', [UserController::class, 'update']);
        Route::get('/me/favorites', [FavoriteController::class, 'index']);
        Route::post('/me/favorites/{channel_id}', [FavoriteController::class, 'store']);
        Route::delete('/me/favorites/{channel_id}', [FavoriteController::class, 'destroy']);
        Route::get('/me/history', [HistoryController::class, 'index']);
        Route::post('/me/history', [HistoryController::class, 'store']);
        Route::delete('/me/history', [HistoryController::class, 'destroy']);
    });
});

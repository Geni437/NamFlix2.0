<?php

use App\Http\Controllers\Admin\Auth\LoginController;
use App\Http\Controllers\Admin\ChannelController;
use App\Http\Controllers\Admin\OverviewController;
use App\Http\Controllers\Admin\ReportController;
use App\Http\Controllers\Admin\SettingController;
use App\Http\Controllers\Admin\StreamController;
use App\Http\Controllers\Admin\SyncController;
use App\Http\Controllers\Admin\UserController;
use Illuminate\Support\Facades\Route;

Route::prefix('admin')->name('admin.')->group(function () {

    // Auth (no middleware)
    Route::get('/login', [LoginController::class, 'showLogin'])->name('login');
    Route::post('/login', [LoginController::class, 'login'])->name('login.post');
    Route::post('/logout', [LoginController::class, 'logout'])->name('logout');

    // Protected admin routes
    Route::middleware('admin.auth')->group(function () {
        Route::get('/', [OverviewController::class, 'index'])->name('overview');

        // Channels
        Route::get('/channels', [ChannelController::class, 'index'])->name('channels');
        Route::post('/channels/bulk-hide', [ChannelController::class, 'bulkHide'])->name('channels.bulk-hide');
        Route::post('/channels/{id}/toggle-hidden', [ChannelController::class, 'toggleHidden'])->name('channels.toggle-hidden');

        // Streams
        Route::get('/streams', [StreamController::class, 'index'])->name('streams');
        Route::post('/streams/{stream}/recheck', [StreamController::class, 'recheck'])->name('streams.recheck');

        // Sync
        Route::get('/sync', [SyncController::class, 'index'])->name('sync');
        Route::post('/sync/iptv', [SyncController::class, 'runIptv'])->name('sync.iptv');
        Route::post('/sync/health', [SyncController::class, 'runHealth'])->name('sync.health');
        Route::post('/sync/epg', [SyncController::class, 'runEpg'])->name('sync.epg');

        // Users
        Route::get('/users', [UserController::class, 'index'])->name('users');
        Route::get('/users/{user}/details', [UserController::class, 'details'])->name('users.details');
        Route::post('/users/{user}/toggle-ban', [UserController::class, 'toggleBan'])->name('users.toggle-ban');
        Route::post('/users/{user}/toggle-admin', [UserController::class, 'toggleAdmin'])->name('users.toggle-admin');

        // Reports
        Route::get('/reports', [ReportController::class, 'index'])->name('reports');
        Route::post('/reports/{streamId}/dismiss', [ReportController::class, 'dismiss'])->name('reports.dismiss');
        Route::post('/reports/{streamId}/recheck', [ReportController::class, 'recheckAndDismiss'])->name('reports.recheck');

        // Settings
        Route::get('/settings', [SettingController::class, 'index'])->name('settings');
        Route::post('/settings', [SettingController::class, 'update'])->name('settings.update');
    });
});

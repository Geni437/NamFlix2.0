<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\SyncLog;
use Illuminate\Support\Facades\Artisan;

class SyncController extends Controller
{
    public function index()
    {
        $lastByType = [
            'iptv_sync' => SyncLog::where('type', 'iptv_sync')->latest('started_at')->first(),
            'health_check' => SyncLog::where('type', 'health_check')->latest('started_at')->first(),
            'epg_sync' => SyncLog::where('type', 'epg_sync')->latest('started_at')->first(),
        ];

        $syncHistory = SyncLog::orderByDesc('started_at')->limit(20)->get();

        return view('admin.sync.index', compact('lastByType', 'syncHistory'));
    }

    public function runIptv()
    {
        set_time_limit(300);
        Artisan::call('namflix:sync-iptv');
        return redirect()->route('admin.sync')->with('success', 'iptv-org sync completed.');
    }

    public function runHealth()
    {
        set_time_limit(600);
        Artisan::call('namflix:check-streams');
        return redirect()->route('admin.sync')->with('success', 'Stream health check completed.');
    }

    public function runEpg()
    {
        set_time_limit(300);
        Artisan::call('namflix:sync-epg');
        return redirect()->route('admin.sync')->with('success', 'EPG sync completed.');
    }
}

<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Models\Channel;
use App\Models\PlatformStat;
use App\Models\Stream;
use App\Models\StreamReport;
use App\Models\SyncLog;
use App\Models\User;
use Illuminate\Support\Facades\DB;

class OverviewController extends Controller
{
    public function index()
    {
        $stats = [
            'total_channels' => Channel::where('is_hidden', false)->count(),
            'live_streams' => Stream::where('is_live', true)->count(),
            'dead_streams' => Stream::where('is_live', false)->where('is_geo_blocked', false)->count(),
            'geo_blocked' => Stream::where('is_geo_blocked', true)->count(),
            'total_users' => User::count(),
            'active_today' => User::whereDate('last_seen_at', today())->count(),
            'pro_users' => User::where('is_pro', true)->count(),
            'reports_pending' => StreamReport::count(),
        ];

        // Top 10 countries by channel count
        $countryChartData = DB::table('channels')
            ->where('is_hidden', false)
            ->whereNotNull('country_code')
            ->select('country_code', DB::raw('COUNT(*) as cnt'))
            ->groupBy('country_code')
            ->orderByDesc('cnt')
            ->limit(10)
            ->get();

        // Category distribution (flatten JSON arrays in PHP)
        $catCounts = [];
        DB::table('channels')
            ->where('is_hidden', false)
            ->whereNotNull('categories')
            ->pluck('categories')
            ->each(function ($json) use (&$catCounts) {
                foreach (json_decode($json, true) ?? [] as $catId) {
                    $catCounts[$catId] = ($catCounts[$catId] ?? 0) + 1;
                }
            });
        arsort($catCounts);
        $catCounts = array_slice($catCounts, 0, 10, true);
        $catNames = Category::whereIn('id', array_keys($catCounts))->pluck('name', 'id');
        $categoryLabels = array_values(array_map(fn ($id) => $catNames->get($id, $id), array_keys($catCounts)));
        $categoryCounts = array_values($catCounts);

        // Platform stats for charts (last 14 days)
        $platformStats = PlatformStat::where('stat_date', '>=', now()->subDays(14))
            ->orderBy('stat_date')
            ->get(['stat_date', 'live_streams', 'total_channels', 'total_watch_events']);

        $statsLabels = $platformStats->map(fn ($s) => $s->stat_date->format('M d'))->toArray();
        $livePercent = $platformStats->map(
            fn ($s) => $s->total_channels > 0 ? round(($s->live_streams / $s->total_channels) * 100) : 0
        )->toArray();
        $watchEvents = $platformStats->pluck('total_watch_events')->toArray();

        // Sync status
        $lastIptvSync = SyncLog::where('type', 'iptv_sync')->latest('started_at')->first();
        $lastHealthCheck = SyncLog::where('type', 'health_check')->latest('started_at')->first();
        $lastEpgSync = SyncLog::where('type', 'epg_sync')->latest('started_at')->first();

        return view('admin.overview', compact(
            'stats',
            'countryChartData',
            'categoryLabels',
            'categoryCounts',
            'statsLabels',
            'livePercent',
            'watchEvents',
            'lastIptvSync',
            'lastHealthCheck',
            'lastEpgSync'
        ));
    }
}

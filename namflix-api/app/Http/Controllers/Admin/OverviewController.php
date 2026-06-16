<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Models\Channel;
use App\Models\Country;
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
        $totalChannels   = Channel::count();
        $visibleChannels = Channel::where('is_hidden', false)->count();

        $stats = [
            'total_channels'      => $totalChannels,
            'visible_channels'    => $visibleChannels,
            'hidden_channels'     => $totalChannels - $visibleChannels,
            'live_streams'        => Stream::where('is_live', true)->count(),
            'total_streams'       => Stream::count(),
            'geo_blocked_streams' => Stream::where('is_geo_blocked', true)->count(),
            'total_users'         => User::count(),
            'pro_users'           => User::where('is_pro', true)->count(),
            'banned_users'        => User::where('is_banned', true)->count(),
            'open_reports'        => StreamReport::count(),
            'countries'           => DB::table('channels')->whereNotNull('country_code')->distinct()->count('country_code'),
        ];

        // Sync logs keyed by artisan command name (matches view's foreach)
        $syncTypeMap = [
            'namflix:sync-iptv'     => 'iptv_sync',
            'namflix:check-streams' => 'health_check',
            'namflix:sync-epg'      => 'epg_sync',
        ];
        $syncLogs = [];
        foreach ($syncTypeMap as $cmd => $type) {
            $syncLogs[$cmd] = SyncLog::where('type', $type)->latest('started_at')->first();
        }

        // Chart data: last 14 days
        $dates    = [];
        $views    = [];
        $newUsers = [];
        for ($i = 13; $i >= 0; $i--) {
            $date     = now()->subDays($i);
            $dates[]  = $date->format('M d');
            $stat     = PlatformStat::whereDate('stat_date', $date->toDateString())->first();
            $views[]  = $stat?->total_watch_events ?? 0;
            $newUsers[] = User::whereDate('created_at', $date->toDateString())->count();
        }

        // Top 10 countries
        $countryRows  = DB::table('channels')
            ->where('is_hidden', false)
            ->whereNotNull('country_code')
            ->select('country_code', DB::raw('COUNT(*) as count'))
            ->groupBy('country_code')
            ->orderByDesc('count')
            ->limit(10)
            ->get();
        $countryNames = Country::whereIn('code', $countryRows->pluck('country_code'))->pluck('name', 'code');
        $countries    = $countryRows->map(fn ($r) => [
            'name'  => $countryNames->get($r->country_code, $r->country_code),
            'count' => $r->count,
        ])->values()->toArray();

        // Top 10 categories
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
        $catCounts  = array_slice($catCounts, 0, 10, true);
        $catNames   = Category::whereIn('id', array_keys($catCounts))->pluck('name', 'id');
        $categories = array_values(array_map(fn ($id) => [
            'name'  => $catNames->get($id, (string) $id),
            'count' => $catCounts[$id],
        ], array_keys($catCounts)));

        $chartData = [
            'dates'      => $dates,
            'views'      => $views,
            'new_users'  => $newUsers,
            'countries'  => $countries,
            'categories' => $categories,
        ];

        return view('admin.overview', compact('stats', 'syncLogs', 'chartData'));
    }
}

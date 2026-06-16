<?php

namespace App\Console\Commands;

use App\Models\Channel;
use App\Models\PlatformStat;
use App\Models\Stream;
use App\Models\User;
use App\Models\WatchHistory;
use Illuminate\Console\Command;

class SnapshotStats extends Command
{
    protected $signature = 'namflix:snapshot-stats';
    protected $description = 'Take a daily platform statistics snapshot';

    public function handle(): int
    {
        $yesterday = now()->subDay()->toDateString();
        $yesterdayStart = now()->subDay()->startOfDay();
        $yesterdayEnd = now()->subDay()->endOfDay();

        PlatformStat::updateOrCreate(
            ['stat_date' => $yesterday],
            [
                'total_users' => User::count(),
                'active_users' => User::where('last_seen_at', '>=', $yesterdayStart)->count(),
                'total_watch_events' => WatchHistory::whereBetween('watched_at', [$yesterdayStart, $yesterdayEnd])->count(),
                'total_channels' => Channel::where('is_hidden', false)->count(),
                'live_streams' => Stream::where('is_live', true)->count(),
                'pro_users' => User::where('is_pro', true)->count(),
                'created_at' => now(),
            ]
        );

        $this->info("[NamFlix] Stats snapshot taken for {$yesterday}.");
        return Command::SUCCESS;
    }
}

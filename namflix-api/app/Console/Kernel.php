<?php

namespace App\Console;

use Illuminate\Console\Scheduling\Schedule;
use Illuminate\Foundation\Console\Kernel as ConsoleKernel;

class Kernel extends ConsoleKernel
{
    protected function schedule(Schedule $schedule): void
    {
        // Sync all channel/stream data from iptv-org — daily at 2 AM UTC
        $schedule->command('namflix:sync-iptv')
            ->dailyAt('02:00')
            ->withoutOverlapping()
            ->runInBackground();

        // Check stream health — every 6 hours
        $schedule->command('namflix:check-streams')
            ->everySixHours()
            ->withoutOverlapping()
            ->runInBackground();

        // Sync EPG program guides — every 6 hours
        $schedule->command('namflix:sync-epg')
            ->everySixHours()
            ->withoutOverlapping()
            ->runInBackground();

        // Snapshot platform stats — daily at midnight UTC
        $schedule->command('namflix:snapshot-stats')
            ->dailyAt('00:00')
            ->withoutOverlapping();

        // Revoke Pro access for expired subscriptions (safety net for missed webhooks)
        $schedule->command('namflix:expire-pro')
            ->dailyAt('01:00')
            ->withoutOverlapping();
    }

    protected function commands(): void
    {
        $this->load(__DIR__ . '/Commands');
        require base_path('routes/console.php');
    }
}

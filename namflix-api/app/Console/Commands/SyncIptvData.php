<?php

namespace App\Console\Commands;

use App\Services\IptvSyncService;
use Illuminate\Console\Command;

class SyncIptvData extends Command
{
    protected $signature = 'namflix:sync-iptv';
    protected $description = 'Sync IPTV channel and stream data from iptv-org';

    public function handle(IptvSyncService $service): int
    {
        $this->info('[NamFlix] Starting IPTV data sync...');

        try {
            $service->sync();
            $this->info('[NamFlix] IPTV sync completed successfully.');
            return Command::SUCCESS;
        } catch (\Exception $e) {
            $this->error('[NamFlix] IPTV sync failed: ' . $e->getMessage());
            return Command::FAILURE;
        }
    }
}

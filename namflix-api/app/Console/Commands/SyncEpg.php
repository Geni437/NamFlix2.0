<?php

namespace App\Console\Commands;

use App\Services\EpgSyncService;
use Illuminate\Console\Command;

class SyncEpg extends Command
{
    protected $signature = 'namflix:sync-epg';
    protected $description = 'Sync EPG program guide data from iptv-org';

    public function handle(EpgSyncService $service): int
    {
        $this->info('[NamFlix] Starting EPG sync...');

        try {
            $service->sync();
            $this->info('[NamFlix] EPG sync completed.');
            return Command::SUCCESS;
        } catch (\Exception $e) {
            $this->error('[NamFlix] EPG sync failed: ' . $e->getMessage());
            return Command::FAILURE;
        }
    }
}

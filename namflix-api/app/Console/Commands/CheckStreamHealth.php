<?php

namespace App\Console\Commands;

use App\Services\StreamHealthService;
use Illuminate\Console\Command;

class CheckStreamHealth extends Command
{
    protected $signature = 'namflix:check-streams';
    protected $description = 'Check health status of all IPTV streams';

    public function handle(StreamHealthService $service): int
    {
        $this->info('[NamFlix] Starting stream health check...');

        try {
            $service->checkAll();
            $this->info('[NamFlix] Stream health check completed.');
            return Command::SUCCESS;
        } catch (\Exception $e) {
            $this->error('[NamFlix] Stream health check failed: ' . $e->getMessage());
            return Command::FAILURE;
        }
    }
}

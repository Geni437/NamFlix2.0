<?php

namespace App\Console\Commands;

use App\Models\User;
use Illuminate\Console\Command;

class ExpireProSubscriptions extends Command
{
    protected $signature = 'namflix:expire-pro';
    protected $description = 'Revoke Pro access for users whose subscription has expired';

    public function handle(): int
    {
        // Safety net for Stripe users where webhooks may have been missed,
        // and for IAP users (no server-push webhook from mobile stores).
        $expired = User::where('is_pro', true)
            ->whereNotNull('pro_expires_at')
            ->where('pro_expires_at', '<', now())
            ->update(['is_pro' => false]);

        $this->info("Expired Pro access for {$expired} user(s).");

        return self::SUCCESS;
    }
}

<?php

namespace App\Console\Commands;

use App\Models\User;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class CreateAdmin extends Command
{
    protected $signature = 'namflix:create-admin';
    protected $description = 'Create or promote a user to admin with dashboard password';

    public function handle(): int
    {
        $this->info('NamFlix Admin Creator');
        $this->line('─────────────────────────────────────');

        $email = $this->ask('Admin email address');

        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            $this->error('Invalid email address.');
            return Command::FAILURE;
        }

        $password = $this->secret('Password (min 8 characters)');

        if (strlen($password) < 8) {
            $this->error('Password must be at least 8 characters.');
            return Command::FAILURE;
        }

        $confirm = $this->secret('Confirm password');

        if ($password !== $confirm) {
            $this->error('Passwords do not match.');
            return Command::FAILURE;
        }

        $existing = User::where('email', $email)->first();

        if ($existing) {
            $existing->update([
                'role' => 'admin',
                'password' => Hash::make($password),
            ]);
            $this->info("User [{$email}] promoted to admin with new password.");
        } else {
            User::create([
                'id' => (string) Str::uuid(),
                'email' => $email,
                'role' => 'admin',
                'password' => Hash::make($password),
            ]);
            $this->info("Admin user created: {$email}");
        }

        $this->line('');
        $this->info('Login at: /admin/login');
        return Command::SUCCESS;
    }
}

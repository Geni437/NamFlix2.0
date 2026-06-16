<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('platform_stats', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->date('stat_date')->unique();
            $table->integer('total_users')->default(0);
            $table->integer('active_users')->default(0);
            $table->integer('total_watch_events')->default(0);
            $table->integer('total_channels')->default(0);
            $table->integer('live_streams')->default(0);
            $table->integer('pro_users')->default(0);
            $table->timestamp('created_at')->useCurrent();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('platform_stats');
    }
};

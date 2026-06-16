<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('streams', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->string('channel_id', 100);
            $table->string('feed', 255)->nullable();
            $table->string('title', 500)->nullable();
            $table->text('url');
            $table->text('referrer')->nullable();
            $table->text('user_agent')->nullable();
            $table->string('quality', 20)->nullable();
            $table->string('label', 100)->nullable();
            $table->boolean('is_live')->default(true);
            $table->boolean('is_geo_blocked')->default(false);
            $table->string('failure_reason', 255)->nullable();
            $table->timestamp('last_checked_at')->nullable();
            $table->timestamps();

            $table->foreign('channel_id')->references('id')->on('channels')->cascadeOnDelete();
            $table->index('channel_id');
            $table->index('is_live');
            $table->index('last_checked_at');
            $table->index(['channel_id', 'is_live']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('streams');
    }
};

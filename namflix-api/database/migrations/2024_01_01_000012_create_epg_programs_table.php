<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('epg_programs', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->string('channel_id', 100);
            $table->string('title', 500);
            $table->text('description')->nullable();
            $table->timestamp('start_time');
            $table->timestamp('end_time');
            $table->string('category', 100)->nullable();
            $table->text('poster_url')->nullable();

            $table->foreign('channel_id')->references('id')->on('channels')->cascadeOnDelete();
            $table->index(['channel_id', 'start_time']);
            $table->index(['channel_id', 'start_time', 'end_time']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('epg_programs');
    }
};

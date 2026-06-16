<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('logos', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->string('channel_id', 100);
            $table->string('feed', 255)->nullable();
            $table->text('url');
            $table->string('format', 20)->nullable();
            $table->integer('width')->nullable();
            $table->integer('height')->nullable();
            $table->json('tags')->nullable();

            $table->foreign('channel_id')->references('id')->on('channels')->cascadeOnDelete();
            $table->index('channel_id');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('logos');
    }
};

<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('channels', function (Blueprint $table) {
            $table->string('id', 100)->primary();
            $table->string('name', 255);
            $table->json('alt_names')->nullable();
            $table->string('network', 255)->nullable();
            $table->char('country_code', 2)->nullable();
            $table->json('categories')->nullable();
            $table->boolean('is_nsfw')->default(false);
            $table->boolean('is_hidden')->default(false);
            $table->date('launched')->nullable();
            $table->string('website', 500)->nullable();
            $table->timestamp('synced_at')->nullable();
            $table->timestamps();

            $table->index('country_code');
            $table->index('is_hidden');
            $table->index('is_nsfw');
            $table->index(['country_code', 'is_hidden', 'is_nsfw']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('channels');
    }
};

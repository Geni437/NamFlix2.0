<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('stream_reports', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->uuid('stream_id');
            $table->uuid('user_id')->nullable();
            $table->enum('reason', ['offline', 'geo_blocked', 'poor_quality', 'wrong_content']);
            $table->timestamp('created_at')->useCurrent();

            $table->foreign('stream_id')->references('id')->on('streams')->cascadeOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('stream_reports');
    }
};

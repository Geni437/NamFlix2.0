<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('regions', function (Blueprint $table) {
            $table->string('code', 50)->primary();
            $table->string('name', 255);
            $table->json('countries')->nullable();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('regions');
    }
};

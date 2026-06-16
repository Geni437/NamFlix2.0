<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('users', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->string('email', 255)->unique();
            $table->string('username', 100)->nullable();
            $table->text('avatar_url')->nullable();
            $table->enum('role', ['user', 'admin'])->default('user');
            $table->boolean('is_banned')->default(false);
            $table->char('preferred_country', 2)->nullable();
            $table->string('preferred_language', 10)->nullable();
            $table->json('preferred_categories')->nullable();
            $table->string('ui_language', 10)->default('en');
            $table->boolean('is_pro')->default(false);
            $table->timestamp('pro_expires_at')->nullable();
            $table->timestamp('last_seen_at')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('users');
    }
};

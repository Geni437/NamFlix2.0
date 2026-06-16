<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Database\Eloquent\Relations\HasMany;

class User extends Authenticatable
{
    public $incrementing = false;
    protected $keyType = 'string';

    protected $fillable = [
        'id', 'email', 'password', 'username', 'avatar_url', 'role', 'is_banned',
        'preferred_country', 'preferred_language', 'preferred_categories',
        'ui_language', 'is_pro', 'pro_expires_at', 'last_seen_at',
        'stripe_customer_id', 'stripe_subscription_id',
    ];

    protected $hidden = ['password', 'remember_token'];

    protected $casts = [
        'preferred_categories' => 'array',
        'is_banned' => 'boolean',
        'is_pro' => 'boolean',
        'pro_expires_at' => 'datetime',
        'last_seen_at' => 'datetime',
    ];

    public function favorites(): HasMany
    {
        return $this->hasMany(UserFavorite::class);
    }

    public function watchHistory(): HasMany
    {
        return $this->hasMany(WatchHistory::class);
    }

    public function isAdmin(): bool
    {
        return $this->role === 'admin';
    }

    public function isPro(): bool
    {
        return $this->is_pro && ($this->pro_expires_at === null || $this->pro_expires_at->isFuture());
    }
}

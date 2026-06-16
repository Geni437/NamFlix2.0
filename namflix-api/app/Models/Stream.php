<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Stream extends Model
{
    use HasUuids;

    protected $fillable = [
        'channel_id', 'feed', 'title', 'url', 'referrer', 'user_agent',
        'quality', 'label', 'is_live', 'is_geo_blocked', 'failure_reason', 'last_checked_at',
    ];

    protected $casts = [
        'is_live' => 'boolean',
        'is_geo_blocked' => 'boolean',
        'last_checked_at' => 'datetime',
    ];

    public function channel(): BelongsTo
    {
        return $this->belongsTo(Channel::class);
    }

    public function reports(): HasMany
    {
        return $this->hasMany(StreamReport::class);
    }
}

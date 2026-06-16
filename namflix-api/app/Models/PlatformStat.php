<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;

class PlatformStat extends Model
{
    use HasUuids;

    public $timestamps = false;

    protected $fillable = [
        'stat_date', 'total_users', 'active_users', 'total_watch_events',
        'total_channels', 'live_streams', 'pro_users', 'created_at',
    ];

    protected $casts = [
        'stat_date' => 'date',
    ];
}

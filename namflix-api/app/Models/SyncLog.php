<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;

class SyncLog extends Model
{
    use HasUuids;

    protected $fillable = [
        'type', 'status', 'started_at', 'completed_at',
        'channels_added', 'channels_updated', 'streams_synced', 'errors',
    ];

    protected $casts = [
        'started_at' => 'datetime',
        'completed_at' => 'datetime',
        'errors' => 'array',
        'channels_added' => 'integer',
        'channels_updated' => 'integer',
        'streams_synced' => 'integer',
    ];
}

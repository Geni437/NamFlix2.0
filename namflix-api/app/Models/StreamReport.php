<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class StreamReport extends Model
{
    use HasUuids;

    public $timestamps = false;

    protected $fillable = ['stream_id', 'user_id', 'reason', 'created_at'];

    public function stream(): BelongsTo
    {
        return $this->belongsTo(Stream::class);
    }
}

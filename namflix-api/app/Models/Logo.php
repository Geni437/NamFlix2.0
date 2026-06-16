<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Logo extends Model
{
    use HasUuids;

    public $timestamps = false;

    protected $fillable = [
        'channel_id', 'feed', 'url', 'format', 'width', 'height', 'tags',
    ];

    protected $casts = [
        'tags' => 'array',
        'width' => 'integer',
        'height' => 'integer',
    ];

    public function channel(): BelongsTo
    {
        return $this->belongsTo(Channel::class);
    }
}

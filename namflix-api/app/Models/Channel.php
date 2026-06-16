<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;

class Channel extends Model
{
    public $incrementing = false;
    protected $keyType = 'string';

    protected $fillable = [
        'id', 'name', 'alt_names', 'network', 'country_code', 'categories',
        'is_nsfw', 'is_hidden', 'launched', 'website', 'synced_at',
    ];

    protected $casts = [
        'alt_names' => 'array',
        'categories' => 'array',
        'is_nsfw' => 'boolean',
        'is_hidden' => 'boolean',
        'launched' => 'date',
        'synced_at' => 'datetime',
    ];

    public function streams(): HasMany
    {
        return $this->hasMany(Stream::class);
    }

    public function logos(): HasMany
    {
        return $this->hasMany(Logo::class);
    }

    public function logo(): HasOne
    {
        return $this->hasOne(Logo::class)
            ->orderByRaw("FIELD(format, 'svg', 'png', 'jpg', 'jpeg') ASC");
    }

    public function epgPrograms(): HasMany
    {
        return $this->hasMany(EpgProgram::class);
    }

    public function favorites(): HasMany
    {
        return $this->hasMany(UserFavorite::class);
    }

    public function watchHistory(): HasMany
    {
        return $this->hasMany(WatchHistory::class);
    }
}

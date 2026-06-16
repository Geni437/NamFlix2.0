<?php

namespace App\Services;

use App\Models\EpgProgram;
use Carbon\Carbon;

class EpgService
{
    public function getCurrentProgram(string $channelId): array
    {
        $now = now()->utc();

        $current = EpgProgram::where('channel_id', $channelId)
            ->where('start_time', '<=', $now)
            ->where('end_time', '>=', $now)
            ->first();

        $progressPercent = 0;
        if ($current) {
            $total           = $current->end_time->diffInSeconds($current->start_time);
            $elapsed         = $now->diffInSeconds($current->start_time);
            $progressPercent = $total > 0
                ? min(100, (int) round(($elapsed / $total) * 100))
                : 0;
        }

        $next = EpgProgram::where('channel_id', $channelId)
            ->where('start_time', '>', $now)
            ->orderBy('start_time')
            ->first();

        return [
            'current_program' => $current,
            'next_program'    => $next,
            'progress_percent' => $progressPercent,
        ];
    }
}

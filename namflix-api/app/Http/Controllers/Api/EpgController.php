<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\EpgProgram;
use App\Services\EpgService;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class EpgController extends Controller
{
    public function __construct(private readonly EpgService $epgService) {}

    public function show(Request $request, string $channelId): JsonResponse
    {
        $date     = $request->get('date', now()->format('Y-m-d'));
        $tzString = $request->get('timezone', 'UTC');

        try {
            $tz = new \DateTimeZone($tzString);
        } catch (\Exception $e) {
            $tz       = new \DateTimeZone('UTC');
            $tzString = 'UTC';
        }

        $dayStart = Carbon::parse($date, $tz)->startOfDay()->utc();
        $dayEnd   = Carbon::parse($date, $tz)->endOfDay()->utc();
        $now      = now()->utc();

        $programs = EpgProgram::where('channel_id', $channelId)
            ->where('start_time', '>=', $dayStart)
            ->where('start_time', '<=', $dayEnd)
            ->orderBy('start_time')
            ->get()
            ->map(function (EpgProgram $program) use ($now, $tz) {
                $isCurrent      = $program->start_time <= $now && $program->end_time > $now;
                $progressPercent = 0;

                if ($isCurrent) {
                    $total           = $program->end_time->diffInSeconds($program->start_time);
                    $elapsed         = $now->diffInSeconds($program->start_time);
                    $progressPercent = $total > 0
                        ? min(100, (int) round(($elapsed / $total) * 100))
                        : 0;
                }

                return [
                    'id'               => $program->id,
                    'channel_id'       => $program->channel_id,
                    'title'            => $program->title,
                    'description'      => $program->description,
                    'start_time'       => $program->start_time->setTimezone($tz)->toIso8601String(),
                    'end_time'         => $program->end_time->setTimezone($tz)->toIso8601String(),
                    'category'         => $program->category,
                    'poster_url'       => $program->poster_url,
                    'is_current'       => $isCurrent,
                    'progress_percent' => $progressPercent,
                ];
            });

        // Identify top-level current and next programs
        $currentProgram = $programs->firstWhere('is_current', true);
        $nextProgram    = null;
        if ($currentProgram) {
            $nextProgram = $programs
                ->filter(fn($p) => $p['start_time'] > $currentProgram['end_time'])
                ->first();
        } elseif ($programs->isNotEmpty()) {
            $nextProgram = $programs
                ->filter(fn($p) => Carbon::parse($p['start_time'])->utc()->gt($now))
                ->first();
        }

        return response()->json([
            'success'         => true,
            'data'            => [
                'programs'         => $programs->values(),
                'current_program'  => $currentProgram,
                'next_program'     => $nextProgram,
            ],
        ]);
    }
}

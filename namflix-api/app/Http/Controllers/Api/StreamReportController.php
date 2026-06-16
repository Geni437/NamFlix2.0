<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Stream;
use App\Models\StreamReport;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\RateLimiter;

class StreamReportController extends Controller
{
    public function store(Request $request): JsonResponse
    {
        $key = 'stream-report:' . $request->ip();

        if (RateLimiter::tooManyAttempts($key, 5)) {
            return response()->json([
                'success' => false,
                'message' => 'Too many reports. Please wait before reporting again.',
                'code' => 'RATE_LIMITED',
            ], 429);
        }

        RateLimiter::hit($key, 3600);

        $validated = $request->validate([
            'stream_id' => 'required|uuid|exists:streams,id',
            'reason' => 'required|in:offline,geo_blocked,poor_quality,wrong_content',
        ]);

        $report = StreamReport::create([
            'stream_id' => $validated['stream_id'],
            'user_id' => auth()->id(),
            'reason' => $validated['reason'],
            'created_at' => now(),
        ]);

        if ($validated['reason'] === 'offline') {
            $recentCount = StreamReport::where('stream_id', $validated['stream_id'])
                ->where('reason', 'offline')
                ->where('created_at', '>=', now()->subHours(3))
                ->count();

            if ($recentCount >= 3) {
                Stream::where('id', $validated['stream_id'])->update([
                    'is_live' => false,
                    'failure_reason' => 'user_reports',
                ]);
            }
        }

        return response()->json([
            'success' => true,
            'data' => $report,
        ], 201);
    }
}

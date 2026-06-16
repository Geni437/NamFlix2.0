<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Channel;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;

class TrendingController extends Controller
{
    public function index(): JsonResponse
    {
        $since = now()->subDay();

        $trendingIds = DB::table('watch_history')
            ->where('watched_at', '>=', $since)
            ->select('channel_id', DB::raw('COUNT(*) as watch_count'))
            ->groupBy('channel_id')
            ->orderByDesc('watch_count')
            ->limit(50)
            ->pluck('channel_id')
            ->toArray();

        if (empty($trendingIds)) {
            $channels = Channel::where('is_hidden', false)
                ->where('is_nsfw', false)
                ->with('logo')
                ->inRandomOrder()
                ->limit(50)
                ->get();
        } else {
            $placeholders = implode(',', array_fill(0, count($trendingIds), '?'));
            $channels = Channel::where('is_hidden', false)
                ->where('is_nsfw', false)
                ->whereIn('id', $trendingIds)
                ->with('logo')
                ->orderByRaw("FIELD(id, {$placeholders})", $trendingIds)
                ->get();
        }

        return response()->json([
            'success' => true,
            'data' => $channels,
        ]);
    }
}

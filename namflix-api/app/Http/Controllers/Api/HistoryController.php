<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\WatchHistory;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class HistoryController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $limit = min((int) $request->get('limit', 20), 100);
        $page = max((int) $request->get('page', 1), 1);
        $offset = ($page - 1) * $limit;

        $total = WatchHistory::where('user_id', $request->user()->id)->count();

        $history = WatchHistory::where('user_id', $request->user()->id)
            ->with('channel.logo')
            ->orderByDesc('watched_at')
            ->skip($offset)
            ->take($limit)
            ->get()
            ->groupBy(fn ($h) => $h->watched_at->format('Y-m-d'))
            ->map(fn ($items, $date) => [
                'date' => $date,
                'items' => $items->values(),
            ])
            ->values();

        return response()->json([
            'success' => true,
            'data' => $history,
            'meta' => [
                'total' => $total,
                'page' => $page,
                'limit' => $limit,
                'pages' => (int) ceil($total / $limit),
            ],
        ]);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'channel_id' => 'required|string|exists:channels,id',
            'stream_url' => 'nullable|url',
            'duration_seconds' => 'nullable|integer|min:0',
        ]);

        $history = WatchHistory::create([
            'user_id' => $request->user()->id,
            'channel_id' => $validated['channel_id'],
            'stream_url' => $validated['stream_url'] ?? null,
            'duration_seconds' => $validated['duration_seconds'] ?? 0,
            'watched_at' => now(),
        ]);

        return response()->json([
            'success' => true,
            'data' => $history,
        ], 201);
    }

    public function destroy(Request $request): JsonResponse
    {
        WatchHistory::where('user_id', $request->user()->id)->delete();

        return response()->json([
            'success' => true,
            'data' => null,
        ]);
    }
}

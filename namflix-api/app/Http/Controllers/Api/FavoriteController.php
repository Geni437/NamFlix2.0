<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Channel;
use App\Models\UserFavorite;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class FavoriteController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $favorites = UserFavorite::where('user_id', $request->user()->id)
            ->with('channel.logo')
            ->orderByDesc('created_at')
            ->get()
            ->map(fn ($f) => $f->channel)
            ->filter()
            ->values();

        return response()->json([
            'success' => true,
            'data' => $favorites,
        ]);
    }

    public function store(Request $request, string $channelId): JsonResponse
    {
        $user = $request->user();

        if (!Channel::where('id', $channelId)->where('is_hidden', false)->exists()) {
            return response()->json([
                'success' => false,
                'message' => 'Channel not found',
                'code' => 'NOT_FOUND',
            ], 404);
        }

        if (!$user->isPro()) {
            $count = UserFavorite::where('user_id', $user->id)->count();
            if ($count >= 20) {
                return response()->json([
                    'success' => false,
                    'message' => 'Free users can save up to 20 favorites. Upgrade to NamFlix Pro for unlimited favorites.',
                    'code' => 'FAVORITES_LIMIT_REACHED',
                ], 403);
            }
        }

        $favorite = UserFavorite::firstOrCreate(
            ['user_id' => $user->id, 'channel_id' => $channelId],
            ['created_at' => now()]
        );

        return response()->json([
            'success' => true,
            'data' => $favorite,
        ], 201);
    }

    public function destroy(Request $request, string $channelId): JsonResponse
    {
        UserFavorite::where('user_id', $request->user()->id)
            ->where('channel_id', $channelId)
            ->delete();

        return response()->json([
            'success' => true,
            'data' => null,
        ]);
    }
}

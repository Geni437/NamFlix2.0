<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Channel;
use App\Models\EpgProgram;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ChannelController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = Channel::query()
            ->where('is_hidden', false)
            ->where('is_nsfw', false);

        if ($search = $request->get('search')) {
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                  ->orWhereRaw("JSON_SEARCH(alt_names, 'one', ?) IS NOT NULL", ["%{$search}%"]);
            });
        }

        if ($country = $request->get('country')) {
            $query->where('country_code', strtoupper($country));
        }

        if ($category = $request->get('category')) {
            $query->whereJsonContains('categories', $category);
        }

        if ($request->boolean('live_only')) {
            $query->whereHas('streams', fn ($q) => $q->where('is_live', true));
        }

        $sort = $request->get('sort', 'name');

        if ($country = $request->get('country')) {
            $query->orderByRaw('CASE WHEN country_code = ? THEN 0 ELSE 1 END', [strtoupper($country)]);
        }

        match ($sort) {
            'popular' => $query->withCount('watchHistory')->orderByDesc('watch_history_count')->orderBy('name'),
            'country' => $query->orderBy('country_code')->orderBy('name'),
            default => $query->orderBy('name'),
        };

        $limit = min((int) $request->get('limit', 48), 100);
        $page = max((int) $request->get('page', 1), 1);
        $offset = ($page - 1) * $limit;

        $total = $query->count();
        $channels = $query->with('logo')->skip($offset)->take($limit)->get();

        return response()->json([
            'success' => true,
            'data' => $channels,
            'meta' => [
                'total' => $total,
                'page' => $page,
                'limit' => $limit,
                'pages' => (int) ceil($total / $limit),
            ],
        ]);
    }

    public function show(string $id): JsonResponse
    {
        $channel = Channel::where('id', $id)
            ->where('is_hidden', false)
            ->first();

        if (!$channel) {
            return response()->json([
                'success' => false,
                'message' => 'Channel not found',
                'code' => 'NOT_FOUND',
            ], 404);
        }

        $streams = $channel->streams()
            ->orderByDesc('is_live')
            ->orderByRaw("CASE WHEN quality = '1080p' THEN 1 WHEN quality = '720p' THEN 2 WHEN quality = '480p' THEN 3 ELSE 4 END")
            ->get();

        $logo = $channel->logos()
            ->orderByRaw("FIELD(format, 'svg', 'png', 'jpg', 'jpeg') ASC")
            ->first();

        $now = now()->utc();

        $currentProgram = EpgProgram::where('channel_id', $id)
            ->where('start_time', '<=', $now)
            ->where('end_time', '>', $now)
            ->first();

        $nextProgram = null;
        if ($currentProgram) {
            $nextProgram = EpgProgram::where('channel_id', $id)
                ->where('start_time', '>=', $currentProgram->end_time)
                ->orderBy('start_time')
                ->first();
        }

        return response()->json([
            'success' => true,
            'data' => array_merge($channel->toArray(), [
                'streams' => $streams,
                'logo' => $logo,
                'current_program' => $currentProgram,
                'next_program' => $nextProgram,
            ]),
        ]);
    }

    public function streams(Request $request, string $id): JsonResponse
    {
        $channel = Channel::where('id', $id)->where('is_hidden', false)->first();

        if (!$channel) {
            return response()->json([
                'success' => false,
                'message' => 'Channel not found',
                'code' => 'NOT_FOUND',
            ], 404);
        }

        $query = $channel->streams();

        if ($request->boolean('live_only', true)) {
            $query->where('is_live', true);
        }

        if ($quality = $request->get('quality')) {
            $query->where('quality', $quality);
        }

        $streams = $query
            ->orderByDesc('is_live')
            ->orderByRaw("CASE WHEN quality = '1080p' THEN 1 WHEN quality = '720p' THEN 2 WHEN quality = '480p' THEN 3 ELSE 4 END")
            ->get();

        return response()->json([
            'success' => true,
            'data' => $streams,
        ]);
    }
}

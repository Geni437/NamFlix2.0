<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Country;
use App\Models\Stream;
use App\Services\StreamHealthService;
use Illuminate\Http\Request;

class StreamController extends Controller
{
    public function index(Request $request)
    {
        $staleThreshold = now()->subHours(24);

        $staleCount = Stream::where(function ($q) use ($staleThreshold) {
            $q->whereNull('last_checked_at')
              ->orWhere('last_checked_at', '<', $staleThreshold);
        })->count();

        $query = Stream::with('channel');

        if ($search = $request->get('search')) {
            $query->whereHas('channel', fn ($q) => $q->where('name', 'like', "%{$search}%"));
        }

        $status = $request->get('status', 'all');
        if ($status === 'live') {
            $query->where('is_live', true);
        } elseif ($status === 'dead') {
            $query->where('is_live', false)->where('is_geo_blocked', false);
        } elseif ($status === 'geo') {
            $query->where('is_geo_blocked', true);
        }

        if ($request->boolean('stale')) {
            $query->where(function ($q) use ($staleThreshold) {
                $q->whereNull('last_checked_at')
                  ->orWhere('last_checked_at', '<', $staleThreshold);
            });
        }

        if ($country = $request->get('country')) {
            $query->whereHas('channel', fn ($q) => $q->where('country_code', strtoupper($country)));
        }

        if ($quality = $request->get('quality')) {
            $query->where('quality', $quality);
        }

        $streams = $query
            ->withCount('reports')
            ->orderByRaw('CASE WHEN last_checked_at IS NULL THEN 0 ELSE 1 END ASC, last_checked_at ASC')
            ->paginate(100)
            ->withQueryString();

        $countries = Country::orderBy('name')->get(['code', 'name']);

        return view('admin.streams.index', compact('streams', 'staleCount', 'countries'));
    }

    public function recheck(Stream $stream)
    {
        $service = app(StreamHealthService::class);
        $result = $service->checkStream($stream);
        $stream->update(array_merge($result, ['last_checked_at' => now()]));
        $stream->refresh();

        return response()->json([
            'success' => true,
            'data' => [
                'is_live' => $stream->is_live,
                'is_geo_blocked' => $stream->is_geo_blocked,
                'failure_reason' => $stream->failure_reason,
                'last_checked_at' => $stream->last_checked_at?->diffForHumans(),
            ],
        ]);
    }
}

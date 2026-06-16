<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Channel;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class SearchController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $q = trim($request->get('q', ''));

        if (mb_strlen($q) < 2) {
            return response()->json([
                'success' => false,
                'message' => 'Search query must be at least 2 characters',
                'code' => 'QUERY_TOO_SHORT',
            ], 422);
        }

        $limit = min((int) $request->get('limit', 20), 100);

        $query = Channel::query()
            ->where('is_hidden', false)
            ->where('is_nsfw', false)
            ->where(function ($q2) use ($q) {
                $q2->where('name', 'like', "%{$q}%")
                   ->orWhereRaw("JSON_SEARCH(alt_names, 'one', ?) IS NOT NULL", ["%{$q}%"]);
            });

        if ($country = $request->get('country')) {
            $query->where('country_code', strtoupper($country));
        }

        if ($category = $request->get('category')) {
            $query->whereJsonContains('categories', $category);
        }

        $total = $query->count();
        $channels = $query->with('logo')->orderBy('name')->limit($limit)->get();

        return response()->json([
            'success' => true,
            'data' => [
                'channels' => $channels,
                'total' => $total,
            ],
        ]);
    }
}

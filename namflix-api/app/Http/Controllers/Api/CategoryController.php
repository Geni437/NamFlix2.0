<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Category;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;

class CategoryController extends Controller
{
    public function index(): JsonResponse
    {
        $categories = Category::all();

        $channelCounts = DB::table('channels')
            ->where('is_hidden', false)
            ->where('is_nsfw', false)
            ->whereNotNull('categories')
            ->get(['categories'])
            ->flatMap(function ($row) {
                return json_decode($row->categories, true) ?? [];
            })
            ->countBy()
            ->toArray();

        $result = $categories->map(function ($cat) use ($channelCounts) {
            $cat->channel_count = $channelCounts[$cat->id] ?? 0;
            return $cat;
        })->sortByDesc('channel_count')->values();

        return response()->json([
            'success' => true,
            'data' => $result,
        ]);
    }
}

<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Country;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;

class CountryController extends Controller
{
    public function index(): JsonResponse
    {
        $channelCounts = DB::table('channels')
            ->where('is_hidden', false)
            ->where('is_nsfw', false)
            ->whereNotNull('country_code')
            ->select('country_code', DB::raw('COUNT(*) as channel_count'))
            ->groupBy('country_code')
            ->pluck('channel_count', 'country_code');

        $countries = Country::all()->map(function ($country) use ($channelCounts) {
            $country->channel_count = $channelCounts[$country->code] ?? 0;
            return $country;
        })->sortByDesc('channel_count')->values();

        return response()->json([
            'success' => true,
            'data' => $countries,
        ]);
    }
}

<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Region;
use Illuminate\Http\JsonResponse;

class RegionController extends Controller
{
    public function index(): JsonResponse
    {
        $regions = Region::orderBy('name')->get();

        return response()->json([
            'success' => true,
            'data' => $regions,
        ]);
    }
}

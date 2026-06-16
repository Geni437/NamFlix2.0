<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Language;
use Illuminate\Http\JsonResponse;

class LanguageController extends Controller
{
    public function index(): JsonResponse
    {
        $languages = Language::orderBy('name')->get();

        return response()->json([
            'success' => true,
            'data' => $languages,
        ]);
    }
}

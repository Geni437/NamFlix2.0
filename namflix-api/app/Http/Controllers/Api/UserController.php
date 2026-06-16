<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class UserController extends Controller
{
    public function show(Request $request): JsonResponse
    {
        return response()->json([
            'success' => true,
            'data' => $request->user(),
        ]);
    }

    public function update(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'username' => 'nullable|string|max:100',
            'preferred_country' => 'nullable|string|size:2',
            'preferred_language' => 'nullable|string|max:10',
            'preferred_categories' => 'nullable|array',
            'preferred_categories.*' => 'string',
            'ui_language' => 'nullable|string|max:10',
        ]);

        $user = $request->user();
        $user->update(array_filter($validated, fn ($v) => $v !== null));

        return response()->json([
            'success' => true,
            'data' => $user->fresh(),
        ]);
    }
}

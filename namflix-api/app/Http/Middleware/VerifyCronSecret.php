<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class VerifyCronSecret
{
    public function handle(Request $request, Closure $next)
    {
        $secret = config('services.cron_secret');

        if (empty($secret)) {
            return response()->json([
                'success' => false,
                'message' => 'Cron secret not configured',
                'code' => 'SERVER_ERROR',
            ], 500);
        }

        $provided = $request->header('X-Cron-Secret');

        if (!$provided || !hash_equals($secret, $provided)) {
            return response()->json([
                'success' => false,
                'message' => 'Forbidden',
                'code' => 'FORBIDDEN',
            ], 403);
        }

        return $next($request);
    }
}

<?php

use Illuminate\Support\Facades\Route;

Route::get('/', fn () => response()->json(['service' => 'NamFlix API', 'status' => 'ok']));

require __DIR__ . '/admin.php';

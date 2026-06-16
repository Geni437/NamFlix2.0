<?php

return [
    'postmark' => [
        'token' => env('POSTMARK_TOKEN'),
    ],
    'ses' => [
        'key' => env('AWS_ACCESS_KEY_ID'),
        'secret' => env('AWS_SECRET_ACCESS_KEY'),
        'region' => env('AWS_DEFAULT_REGION', 'us-east-1'),
    ],
    'resend' => [
        'key' => env('RESEND_KEY'),
    ],
    'slack' => [
        'notifications' => [
            'bot_user_oauth_token' => env('SLACK_BOT_USER_OAUTH_TOKEN'),
            'channel' => env('SLACK_BOT_USER_DEFAULT_CHANNEL'),
        ],
    ],
    'supabase' => [
        'url' => env('SUPABASE_URL'),
        'anon_key' => env('SUPABASE_ANON_KEY'),
        'jwt_secret' => env('SUPABASE_JWT_SECRET'),
    ],

    'cron_secret' => env('CRON_SECRET'),

    'frontend_url' => env('FRONTEND_URL', 'https://namflix.info'),

    'stripe' => [
        'secret'            => env('STRIPE_SECRET_KEY'),
        'webhook_secret'    => env('STRIPE_WEBHOOK_SECRET'),
        'monthly_price_id'  => env('STRIPE_MONTHLY_PRICE_ID'),
        'annual_price_id'   => env('STRIPE_ANNUAL_PRICE_ID'),
    ],

    'google_play' => [
        'package_name'         => env('GOOGLE_PLAY_PACKAGE_NAME', 'com.namflix.app'),
        'service_account_json' => env('GOOGLE_PLAY_SERVICE_ACCOUNT_JSON'),
    ],

    'apple' => [
        'shared_secret' => env('APPLE_SHARED_SECRET'),
    ],
];

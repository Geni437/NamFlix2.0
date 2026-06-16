<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login — NamFlix</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', sans-serif;
            background: #08080F;
            color: #fff;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-wrap { width: 100%; max-width: 400px; padding: 24px; }
        .login-brand { text-align: center; margin-bottom: 36px; }
        .brand-logo { font-size: 2rem; font-weight: 700; color: #E50914; letter-spacing: -1px; }
        .brand-sub { font-size: 0.8rem; color: #A0A0B0; margin-top: 6px; letter-spacing: 0.5px; text-transform: uppercase; }
        .login-card {
            background: #111118;
            border: 1px solid rgba(255,255,255,0.07);
            border-radius: 16px;
            padding: 32px;
        }
        .card-title { font-size: 1rem; font-weight: 600; margin-bottom: 24px; color: #fff; }
        .form-group { margin-bottom: 16px; }
        .form-label { display: block; font-size: 0.75rem; font-weight: 600; color: #A0A0B0; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 7px; }
        .form-input {
            width: 100%;
            background: #1a1a24;
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 8px;
            padding: 10px 14px;
            color: #fff;
            font-size: 0.9rem;
            font-family: inherit;
            outline: none;
            transition: border-color 0.15s;
        }
        .form-input:focus { border-color: rgba(229,9,20,0.5); }
        .form-input::placeholder { color: #555570; }
        .btn-login {
            width: 100%;
            background: #E50914;
            color: #fff;
            border: none;
            border-radius: 8px;
            padding: 11px;
            font-size: 0.9rem;
            font-weight: 600;
            font-family: inherit;
            cursor: pointer;
            margin-top: 8px;
            transition: background 0.15s;
        }
        .btn-login:hover { background: #c20812; }
        .alert-error {
            background: rgba(229,9,20,0.08);
            border: 1px solid rgba(229,9,20,0.2);
            color: #f87171;
            padding: 10px 14px;
            border-radius: 8px;
            font-size: 0.85rem;
            margin-bottom: 20px;
        }
        .login-footer { text-align: center; margin-top: 24px; font-size: 0.75rem; color: #555570; }
    </style>
</head>
<body>
    <div class="login-wrap">
        <div class="login-brand">
            <div class="brand-logo">NamFlix</div>
            <div class="brand-sub">Admin Dashboard</div>
        </div>

        <div class="login-card">
            <div class="card-title">Sign in to Admin</div>

            @if($errors->any())
                <div class="alert-error">{{ $errors->first() }}</div>
            @endif

            @if(session('error'))
                <div class="alert-error">{{ session('error') }}</div>
            @endif

            <form method="POST" action="{{ route('admin.login.post') }}">
                @csrf
                <div class="form-group">
                    <label class="form-label" for="email">Email Address</label>
                    <input
                        class="form-input"
                        type="email"
                        id="email"
                        name="email"
                        value="{{ old('email') }}"
                        placeholder="admin@example.com"
                        required
                        autofocus
                    >
                </div>
                <div class="form-group">
                    <label class="form-label" for="password">Password</label>
                    <input
                        class="form-input"
                        type="password"
                        id="password"
                        name="password"
                        placeholder="••••••••"
                        required
                    >
                </div>
                <button type="submit" class="btn-login">Sign In</button>
            </form>
        </div>

        <div class="login-footer">
            Create admin: <code style="color:#A0A0B0;">php artisan namflix:create-admin</code>
        </div>
    </div>
</body>
</html>

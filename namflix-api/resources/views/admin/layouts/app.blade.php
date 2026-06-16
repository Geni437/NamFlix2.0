<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>@yield('title', 'Dashboard') — NamFlix Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #08080F;
            --surface: #111118;
            --surface-2: #1a1a24;
            --surface-3: #22222e;
            --accent: #E50914;
            --accent-dim: rgba(229,9,20,0.12);
            --blue: #00C2FF;
            --text: #FFFFFF;
            --muted: #A0A0B0;
            --border: rgba(255,255,255,0.07);
            --sidebar-w: 240px;
            --topbar-h: 60px;
            --radius: 10px;
        }
        *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }
        html, body { height: 100%; }
        body { font-family: 'Inter', sans-serif; background: var(--bg); color: var(--text); display: flex; font-size: 14px; line-height: 1.5; }

        /* ─── Sidebar ─────────────────────────────── */
        .sidebar {
            width: var(--sidebar-w);
            background: var(--surface);
            position: fixed; top: 0; left: 0;
            height: 100vh;
            display: flex; flex-direction: column;
            border-right: 1px solid var(--border);
            z-index: 100; overflow-y: auto;
        }
        .sidebar-brand {
            padding: 18px 16px 16px;
            border-bottom: 1px solid var(--border);
            display: flex; align-items: center; gap: 10px;
        }
        .brand-logo { font-size: 1.35rem; font-weight: 700; color: var(--accent); letter-spacing: -0.5px; }
        .brand-badge {
            background: var(--accent-dim); color: var(--accent);
            font-size: 0.62rem; font-weight: 700;
            padding: 2px 6px; border-radius: 4px;
            text-transform: uppercase; letter-spacing: 0.8px;
        }
        .sidebar-nav { flex: 1; padding: 10px 8px; }
        .nav-section { font-size: 0.65rem; font-weight: 700; color: #444455; text-transform: uppercase; letter-spacing: 1px; padding: 12px 12px 6px; }
        .nav-link {
            display: flex; align-items: center; gap: 10px;
            padding: 9px 12px; border-radius: 8px;
            color: var(--muted); text-decoration: none;
            font-size: 0.875rem; font-weight: 500;
            margin-bottom: 2px; transition: all 0.15s;
        }
        .nav-link:hover { background: var(--surface-2); color: var(--text); }
        .nav-link.active { background: var(--accent-dim); color: var(--accent); }
        .nav-link svg { width: 17px; height: 17px; flex-shrink: 0; }
        .sidebar-footer {
            padding: 12px 8px;
            border-top: 1px solid var(--border);
        }

        /* ─── Main ────────────────────────────────── */
        .main { margin-left: var(--sidebar-w); flex: 1; display: flex; flex-direction: column; min-height: 100vh; }
        .topbar {
            background: var(--surface);
            border-bottom: 1px solid var(--border);
            height: var(--topbar-h);
            padding: 0 24px;
            display: flex; align-items: center; justify-content: space-between;
            position: sticky; top: 0; z-index: 50;
        }
        .topbar-title { font-size: 1rem; font-weight: 600; }
        .topbar-right { display: flex; align-items: center; gap: 12px; }
        .topbar-user { font-size: 0.8rem; color: var(--muted); }
        .content { padding: 24px; flex: 1; }

        /* ─── Alerts ──────────────────────────────── */
        .alert {
            display: flex; align-items: center; gap: 8px;
            padding: 11px 14px; border-radius: var(--radius);
            margin-bottom: 18px; font-weight: 500; font-size: 0.875rem;
        }
        .alert-success { background: rgba(34,197,94,0.08); border: 1px solid rgba(34,197,94,0.2); color: #4ade80; }
        .alert-error   { background: rgba(229,9,20,0.08); border: 1px solid rgba(229,9,20,0.2); color: #f87171; }
        .alert-warning { background: rgba(251,146,60,0.08); border: 1px solid rgba(251,146,60,0.2); color: #fb923c; }

        /* ─── KPI Cards ───────────────────────────── */
        .kpi-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 14px; margin-bottom: 20px; }
        .kpi-card {
            background: var(--surface); border: 1px solid var(--border);
            border-radius: var(--radius); padding: 18px 20px;
        }
        .kpi-label { font-size: 0.72rem; color: var(--muted); font-weight: 600; text-transform: uppercase; letter-spacing: 0.6px; margin-bottom: 8px; }
        .kpi-value { font-size: 1.75rem; font-weight: 700; line-height: 1; }
        .kpi-value.red { color: var(--accent); }
        .kpi-value.blue { color: var(--blue); }
        .kpi-value.green { color: #4ade80; }

        /* ─── Chart Grid ──────────────────────────── */
        .chart-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; margin-bottom: 14px; }
        .chart-card {
            background: var(--surface); border: 1px solid var(--border);
            border-radius: var(--radius); padding: 20px;
        }
        .chart-title { font-size: 0.72rem; font-weight: 700; color: var(--muted); text-transform: uppercase; letter-spacing: 0.6px; margin-bottom: 16px; }
        .chart-wrap { position: relative; height: 220px; }

        /* ─── Cards ───────────────────────────────── */
        .card {
            background: var(--surface); border: 1px solid var(--border);
            border-radius: var(--radius); padding: 20px; margin-bottom: 16px;
        }
        .card-title { font-size: 0.875rem; font-weight: 600; margin-bottom: 16px; }
        .card-grid-3 { display: grid; grid-template-columns: repeat(3, 1fr); gap: 14px; margin-bottom: 20px; }

        /* ─── Tables ──────────────────────────────── */
        .table-wrap { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); overflow: hidden; }
        .table-header { padding: 14px 18px; border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; }
        .table-header h3 { font-size: 0.875rem; font-weight: 600; }
        table { width: 100%; border-collapse: collapse; }
        thead th {
            background: var(--surface-2); padding: 10px 14px;
            text-align: left; font-size: 0.7rem; font-weight: 700;
            color: var(--muted); text-transform: uppercase; letter-spacing: 0.6px;
            border-bottom: 1px solid var(--border); white-space: nowrap;
        }
        thead th input[type="checkbox"] { cursor: pointer; }
        tbody tr { border-bottom: 1px solid var(--border); transition: background 0.1s; }
        tbody tr:last-child { border-bottom: none; }
        tbody tr:hover { background: rgba(255,255,255,0.02); }
        tbody td { padding: 10px 14px; color: var(--text); vertical-align: middle; }
        tbody td.muted { color: var(--muted); font-size: 0.8rem; }
        .truncate { max-width: 200px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; display: block; }

        /* ─── Badges ──────────────────────────────── */
        .badge {
            display: inline-flex; align-items: center; gap: 4px;
            padding: 3px 8px; border-radius: 4px;
            font-size: 0.68rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: 0.3px; white-space: nowrap;
        }
        .badge-green  { background: rgba(74,222,128,0.12); color: #4ade80; }
        .badge-red    { background: rgba(229,9,20,0.15); color: #f87171; }
        .badge-orange { background: rgba(251,146,60,0.15); color: #fb923c; }
        .badge-blue   { background: rgba(0,194,255,0.15); color: var(--blue); }
        .badge-gray   { background: rgba(160,160,176,0.12); color: var(--muted); }
        .badge-purple { background: rgba(167,139,250,0.12); color: #a78bfa; }
        .dot { width: 6px; height: 6px; border-radius: 50%; background: currentColor; display: inline-block; }

        /* ─── Buttons ─────────────────────────────── */
        .btn {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 7px 14px; border-radius: 8px; border: none;
            font-size: 0.8rem; font-weight: 600; cursor: pointer;
            text-decoration: none; font-family: inherit; transition: all 0.15s; white-space: nowrap;
        }
        .btn-primary { background: var(--accent); color: #fff; }
        .btn-primary:hover { background: #c20812; }
        .btn-secondary { background: var(--surface-2); color: var(--text); border: 1px solid var(--border); }
        .btn-secondary:hover { background: var(--surface-3); }
        .btn-ghost { background: transparent; color: var(--muted); border: 1px solid var(--border); }
        .btn-ghost:hover { color: var(--text); background: var(--surface-2); }
        .btn-danger { background: rgba(229,9,20,0.15); color: #f87171; border: 1px solid rgba(229,9,20,0.2); }
        .btn-danger:hover { background: rgba(229,9,20,0.25); }
        .btn-sm { padding: 4px 10px; font-size: 0.75rem; border-radius: 6px; }
        .btn:disabled { opacity: 0.5; cursor: not-allowed; }

        /* ─── Forms ───────────────────────────────── */
        .filters {
            background: var(--surface); border: 1px solid var(--border);
            border-radius: var(--radius); padding: 14px 16px;
            display: flex; gap: 10px; flex-wrap: wrap; align-items: flex-end;
            margin-bottom: 14px;
        }
        .form-group { display: flex; flex-direction: column; gap: 5px; }
        .form-label { font-size: 0.72rem; font-weight: 600; color: var(--muted); text-transform: uppercase; letter-spacing: 0.5px; }
        .form-input {
            background: var(--surface-2); border: 1px solid var(--border);
            border-radius: 7px; padding: 7px 11px;
            color: var(--text); font-size: 0.8rem; font-family: inherit;
            outline: none; transition: border-color 0.15s; min-width: 120px;
        }
        .form-input:focus { border-color: rgba(229,9,20,0.4); }
        .form-input::placeholder { color: #555570; }
        select.form-input option { background: var(--surface-2); }
        .checkbox-label { display: flex; align-items: center; gap: 6px; cursor: pointer; font-size: 0.8rem; color: var(--muted); padding-bottom: 7px; }
        .checkbox-label input { accent-color: var(--accent); width: 14px; height: 14px; }

        /* ─── Sync cards ──────────────────────────── */
        .sync-stat { font-size: 0.78rem; color: var(--muted); margin-bottom: 6px; }
        .sync-stat span { color: var(--text); font-weight: 500; }
        .spinner { display: inline-block; width: 14px; height: 14px; border: 2px solid rgba(255,255,255,0.3); border-top-color: #fff; border-radius: 50%; animation: spin 0.7s linear infinite; }
        @keyframes spin { to { transform: rotate(360deg); } }

        /* ─── Modal ───────────────────────────────── */
        .modal-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.75); z-index: 200; align-items: center; justify-content: center; }
        .modal-overlay.open { display: flex; }
        .modal { background: var(--surface); border: 1px solid var(--border); border-radius: 14px; padding: 24px; max-width: 580px; width: 92%; max-height: 88vh; overflow-y: auto; }
        .modal-head { display: flex; align-items: flex-start; justify-content: space-between; margin-bottom: 20px; }
        .modal-title { font-size: 1rem; font-weight: 600; }
        .modal-close { background: none; border: none; color: var(--muted); font-size: 1.4rem; cursor: pointer; line-height: 1; padding: 0; }
        .modal-close:hover { color: var(--text); }
        .detail-row { display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid var(--border); font-size: 0.85rem; }
        .detail-row:last-child { border-bottom: none; }
        .detail-key { color: var(--muted); }

        /* ─── Row color coding ────────────────────── */
        .row-live { border-left: 3px solid #4ade80 !important; }
        .row-dead { border-left: 3px solid #f87171 !important; }
        .row-geo  { border-left: 3px solid #fb923c !important; }

        /* ─── Page section headers ─────────────────── */
        .page-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px; }
        .page-title { font-size: 1.1rem; font-weight: 700; }
        .page-subtitle { font-size: 0.8rem; color: var(--muted); margin-top: 3px; }

        /* ─── Misc ────────────────────────────────── */
        .flex-gap { display: flex; gap: 8px; align-items: center; }
        .text-muted { color: var(--muted); }
        .text-sm { font-size: 0.8rem; }
        img.channel-logo { width: 28px; height: 28px; object-fit: contain; border-radius: 4px; background: var(--surface-2); }
        .flag { font-size: 1rem; }
        pre.error-json { background: var(--surface-2); border-radius: 6px; padding: 10px; font-size: 0.75rem; color: #fb923c; white-space: pre-wrap; word-break: break-all; max-height: 150px; overflow-y: auto; }
    </style>
</head>
<body>

{{-- Sidebar --}}
<aside class="sidebar">
    <div class="sidebar-brand">
        <span class="brand-logo">NamFlix</span>
        <span class="brand-badge">Admin</span>
    </div>
    <nav class="sidebar-nav">
        <div class="nav-section">Main</div>
        <a href="{{ route('admin.overview') }}" class="nav-link {{ request()->routeIs('admin.overview') ? 'active' : '' }}">
            <svg fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M3 13.125C3 12.504 3.504 12 4.125 12h2.25c.621 0 1.125.504 1.125 1.125v6.75C7.5 20.496 6.996 21 6.375 21h-2.25A1.125 1.125 0 0 1 3 19.875v-6.75ZM9.75 8.625c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125v11.25c0 .621-.504 1.125-1.125 1.125h-2.25a1.125 1.125 0 0 1-1.125-1.125V8.625ZM16.5 4.125c0-.621.504-1.125 1.125-1.125h2.25C20.496 3 21 3.504 21 4.125v15.75c0 .621-.504 1.125-1.125 1.125h-2.25a1.125 1.125 0 0 1-1.125-1.125V4.125Z" /></svg>
            Overview
        </a>
        <a href="{{ route('admin.channels') }}" class="nav-link {{ request()->routeIs('admin.channels*') ? 'active' : '' }}">
            <svg fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M6 20.25h12m-7.5-3v3m3-3v3m-10.125-3h17.25c.621 0 1.125-.504 1.125-1.125V4.875C21 4.254 20.496 3.75 19.875 3.75H4.125C3.504 3.75 3 4.254 3 4.875v11.25c0 .621.504 1.125 1.125 1.125Z" /></svg>
            Channels
        </a>
        <a href="{{ route('admin.streams') }}" class="nav-link {{ request()->routeIs('admin.streams*') ? 'active' : '' }}">
            <svg fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M8.288 15.038a5.25 5.25 0 0 1 7.424 0M5.106 11.856c3.807-3.808 9.98-3.808 13.788 0M1.924 8.674c5.565-5.565 14.587-5.565 20.152 0M12.53 18.22l-.53.53-.53-.53a.75.75 0 0 1 1.06 0Z" /></svg>
            Streams
        </a>
        <div class="nav-section">Tools</div>
        <a href="{{ route('admin.sync') }}" class="nav-link {{ request()->routeIs('admin.sync*') ? 'active' : '' }}">
            <svg fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M16.023 9.348h4.992v-.001M2.985 19.644v-4.992m0 0h4.992m-4.993 0 3.181 3.183a8.25 8.25 0 0 0 13.803-3.7M4.031 9.865a8.25 8.25 0 0 1 13.803-3.7l3.181 3.182m0-4.991v4.99" /></svg>
            Sync Control
        </a>
        <a href="{{ route('admin.users') }}" class="nav-link {{ request()->routeIs('admin.users*') ? 'active' : '' }}">
            <svg fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M15 19.128a9.38 9.38 0 0 0 2.625.372 9.337 9.337 0 0 0 4.121-.952 4.125 4.125 0 0 0-7.533-2.493M15 19.128v-.003c0-1.113-.285-2.16-.786-3.07M15 19.128v.106A12.318 12.318 0 0 1 8.624 21c-2.331 0-4.512-.645-6.374-1.766l-.001-.109a6.375 6.375 0 0 1 11.964-3.07M12 6.375a3.375 3.375 0 1 1-6.75 0 3.375 3.375 0 0 1 6.75 0Zm8.25 2.25a2.625 2.625 0 1 1-5.25 0 2.625 2.625 0 0 1 5.25 0Z" /></svg>
            Users
        </a>
        <a href="{{ route('admin.reports') }}" class="nav-link {{ request()->routeIs('admin.reports*') ? 'active' : '' }}">
            <svg fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M3 3v1.5M3 21v-6m0 0 2.77-.693a9 9 0 0 1 6.208.682l.108.054a9 9 0 0 0 6.086.71l3.114-.732a48.524 48.524 0 0 1-.005-10.499l-3.11.732a9 9 0 0 1-6.085-.711l-.108-.054a9 9 0 0 0-6.208-.682L3 4.5M3 15V4.5" /></svg>
            Reports
        </a>
        <a href="{{ route('admin.settings') }}" class="nav-link {{ request()->routeIs('admin.settings*') ? 'active' : '' }}">
            <svg fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M9.594 3.94c.09-.542.56-.94 1.11-.94h2.593c.55 0 1.02.398 1.11.94l.213 1.281c.063.374.313.686.645.87.074.04.147.083.22.127.325.196.72.257 1.075.124l1.217-.456a1.125 1.125 0 0 1 1.37.49l1.296 2.247a1.125 1.125 0 0 1-.26 1.431l-1.003.827c-.293.241-.438.613-.43.992a7.723 7.723 0 0 1 0 .255c-.008.378.137.75.43.991l1.004.827c.424.35.534.955.26 1.43l-1.298 2.247a1.125 1.125 0 0 1-1.369.491l-1.217-.456c-.355-.133-.75-.072-1.076.124a6.47 6.47 0 0 1-.22.128c-.331.183-.581.495-.644.869l-.213 1.281c-.09.543-.56.94-1.11.94h-2.594c-.55 0-1.019-.398-1.11-.94l-.213-1.281c-.062-.374-.312-.686-.644-.87a6.52 6.52 0 0 1-.22-.127c-.325-.196-.72-.257-1.076-.124l-1.217.456a1.125 1.125 0 0 1-1.369-.49l-1.297-2.247a1.125 1.125 0 0 1 .26-1.431l1.004-.827c.292-.24.437-.613.43-.991a6.932 6.932 0 0 1 0-.255c.007-.38-.138-.751-.43-.992l-1.004-.827a1.125 1.125 0 0 1-.26-1.43l1.297-2.247a1.125 1.125 0 0 1 1.37-.491l1.216.456c.356.133.751.072 1.076-.124.072-.044.146-.086.22-.128.332-.183.582-.495.644-.869l.214-1.28Z" /><path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z" /></svg>
            Settings
        </a>
    </nav>
    <div class="sidebar-footer">
        <form method="POST" action="{{ route('admin.logout') }}">
            @csrf
            <button type="submit" class="btn btn-ghost" style="width:100%;justify-content:center;">
                <svg style="width:15px;height:15px;" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M8.25 9V5.25A2.25 2.25 0 0 1 10.5 3h6a2.25 2.25 0 0 1 2.25 2.25v13.5A2.25 2.25 0 0 1 16.5 21h-6a2.25 2.25 0 0 1-2.25-2.25V15m-3 0-3-3m0 0 3-3m-3 3H15" /></svg>
                Sign Out
            </button>
        </form>
    </div>
</aside>

{{-- Main --}}
<main class="main">
    <div class="topbar">
        <div class="topbar-title">@yield('title', 'Dashboard')</div>
        <div class="topbar-right">
            <span class="topbar-user">{{ auth()->user()->email }}</span>
            <span class="badge badge-purple">Admin</span>
        </div>
    </div>
    <div class="content">
        @if(session('success'))
            <div class="alert alert-success">
                <svg style="width:16px;height:16px;flex-shrink:0;" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="m4.5 12.75 6 6 9-13.5" /></svg>
                {{ session('success') }}
            </div>
        @endif
        @if(session('error'))
            <div class="alert alert-error">
                <svg style="width:16px;height:16px;flex-shrink:0;" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126ZM12 15.75h.007v.008H12v-.008Z" /></svg>
                {{ session('error') }}
            </div>
        @endif
        @if($errors->any())
            <div class="alert alert-error">{{ $errors->first() }}</div>
        @endif
        @yield('content')
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
<script>
    Chart.defaults.color = '#A0A0B0';
    Chart.defaults.font.family = 'Inter';
    const gridColor = 'rgba(255,255,255,0.05)';
</script>
@yield('scripts')
</body>
</html>

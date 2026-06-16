@extends('admin.layouts.app')
@section('title', 'Overview')

@section('content')
<div class="page-header">
    <div>
        <div class="page-title">Platform Overview</div>
        <div class="page-subtitle">Live stats &amp; performance dashboard</div>
    </div>
</div>

{{-- KPI Cards --}}
<div class="kpi-grid">
    <div class="kpi-card">
        <div class="kpi-label">Total Channels</div>
        <div class="kpi-value red">{{ number_format($stats['total_channels']) }}</div>
        <div class="text-sm text-muted" style="margin-top:8px;">{{ number_format($stats['visible_channels']) }} visible</div>
    </div>
    <div class="kpi-card">
        <div class="kpi-label">Live Streams</div>
        <div class="kpi-value green">{{ number_format($stats['live_streams']) }}</div>
        <div class="text-sm text-muted" style="margin-top:8px;">of {{ number_format($stats['total_streams']) }} total</div>
    </div>
    <div class="kpi-card">
        <div class="kpi-label">Registered Users</div>
        <div class="kpi-value blue">{{ number_format($stats['total_users']) }}</div>
        <div class="text-sm text-muted" style="margin-top:8px;">{{ number_format($stats['pro_users']) }} Pro subscribers</div>
    </div>
    <div class="kpi-card">
        <div class="kpi-label">Open Reports</div>
        <div class="kpi-value" style="color:{{ $stats['open_reports'] > 0 ? '#fb923c' : '#4ade80' }}">{{ number_format($stats['open_reports']) }}</div>
        <div class="text-sm text-muted" style="margin-top:8px;">Stream quality reports</div>
    </div>
</div>
<div class="kpi-grid" style="margin-top:0;margin-bottom:20px;">
    <div class="kpi-card">
        <div class="kpi-label">Banned Users</div>
        <div class="kpi-value" style="font-size:1.3rem;">{{ number_format($stats['banned_users']) }}</div>
    </div>
    <div class="kpi-card">
        <div class="kpi-label">Hidden Channels</div>
        <div class="kpi-value" style="font-size:1.3rem;">{{ number_format($stats['hidden_channels']) }}</div>
    </div>
    <div class="kpi-card">
        <div class="kpi-label">Geo-Blocked Streams</div>
        <div class="kpi-value" style="font-size:1.3rem;color:#fb923c;">{{ number_format($stats['geo_blocked_streams']) }}</div>
    </div>
    <div class="kpi-card">
        <div class="kpi-label">Countries Covered</div>
        <div class="kpi-value" style="font-size:1.3rem;color:var(--blue);">{{ number_format($stats['countries']) }}</div>
    </div>
</div>

{{-- Charts --}}
<div class="chart-grid">
    <div class="chart-card">
        <div class="chart-title">Daily Views — Last 14 Days</div>
        <div class="chart-wrap"><canvas id="viewsChart"></canvas></div>
    </div>
    <div class="chart-card">
        <div class="chart-title">New Users — Last 14 Days</div>
        <div class="chart-wrap"><canvas id="usersChart"></canvas></div>
    </div>
</div>
<div class="chart-grid">
    <div class="chart-card">
        <div class="chart-title">Channels by Country (Top 10)</div>
        <div class="chart-wrap"><canvas id="countryChart"></canvas></div>
    </div>
    <div class="chart-card">
        <div class="chart-title">Channels by Category (Top 10)</div>
        <div class="chart-wrap"><canvas id="categoryChart"></canvas></div>
    </div>
</div>

{{-- Sync Status --}}
<div class="card">
    <div class="card-title">Last Sync Status</div>
    <div style="display:grid;grid-template-columns:repeat(3,1fr);gap:12px;">
        @foreach(['namflix:sync-iptv' => 'IPTV Sync', 'namflix:check-streams' => 'Stream Health', 'namflix:sync-epg' => 'EPG Sync'] as $cmd => $label)
            @php $log = $syncLogs[$cmd] ?? null; @endphp
            <div style="background:var(--surface-2);border-radius:8px;padding:14px;border:1px solid var(--border);">
                <div style="font-size:0.72rem;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.5px;margin-bottom:8px;">{{ $label }}</div>
                @if($log)
                    <div style="margin-bottom:6px;">
                        @if($log->status === 'success')
                            <span class="badge badge-green"><span class="dot"></span> Success</span>
                        @elseif($log->status === 'running')
                            <span class="badge badge-blue"><span class="dot"></span> Running</span>
                        @else
                            <span class="badge badge-red"><span class="dot"></span> Failed</span>
                        @endif
                    </div>
                    <div class="sync-stat">Started: <span>{{ \Carbon\Carbon::parse($log->started_at)->diffForHumans() }}</span></div>
                    @if($log->finished_at)
                        <div class="sync-stat">Duration: <span>{{ round(\Carbon\Carbon::parse($log->started_at)->diffInSeconds($log->finished_at)) }}s</span></div>
                    @endif
                    @if($log->records_synced !== null)
                        <div class="sync-stat">Records: <span>{{ number_format($log->records_synced) }}</span></div>
                    @endif
                    @if($log->error_message)
                        <div class="sync-stat" style="color:#f87171;">{{ Str::limit($log->error_message, 60) }}</div>
                    @endif
                @else
                    <div class="text-muted text-sm">Never run</div>
                @endif
            </div>
        @endforeach
    </div>
</div>
@endsection

@section('scripts')
<script>
    const statsData = @json($chartData);

    const lineDefaults = (label, data, color) => ({
        type: 'line',
        data: {
            labels: statsData.dates,
            datasets: [{
                label, data, borderColor: color,
                backgroundColor: color.replace(')', ',0.08)').replace('rgb(','rgba(').replace('#', 'rgba(').replace(/^rgba\(([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})/, (_, r, g, b) => `rgba(${parseInt(r,16)},${parseInt(g,16)},${parseInt(b,16)}`),
                borderWidth: 2, tension: 0.3, fill: true, pointRadius: 3, pointHoverRadius: 5
            }]
        },
        options: {
            responsive: true, maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                x: { grid: { color: gridColor }, ticks: { maxTicksLimit: 7, font: { size: 11 } } },
                y: { grid: { color: gridColor }, beginAtZero: true, ticks: { font: { size: 11 } } }
            }
        }
    });

    new Chart(document.getElementById('viewsChart'), lineDefaults('Views', statsData.views, '#E50914'));
    new Chart(document.getElementById('usersChart'), lineDefaults('New Users', statsData.new_users, '#00C2FF'));

    const barDefaults = (labels, data, color) => ({
        type: 'bar',
        data: {
            labels,
            datasets: [{ data, backgroundColor: color + 'cc', borderColor: color, borderWidth: 1, borderRadius: 4 }]
        },
        options: {
            indexAxis: 'y', responsive: true, maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                x: { grid: { color: gridColor }, beginAtZero: true, ticks: { font: { size: 10 } } },
                y: { grid: { display: false }, ticks: { font: { size: 10 } } }
            }
        }
    });

    new Chart(document.getElementById('countryChart'), barDefaults(
        statsData.countries.map(r => r.name),
        statsData.countries.map(r => r.count),
        '#00C2FF'
    ));
    new Chart(document.getElementById('categoryChart'), barDefaults(
        statsData.categories.map(r => r.name),
        statsData.categories.map(r => r.count),
        '#E50914'
    ));
</script>
@endsection

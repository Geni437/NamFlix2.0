@extends('admin.layouts.app')
@section('title', 'Sync Control')

@section('content')
<div class="page-header">
    <div>
        <div class="page-title">Sync Control</div>
        <div class="page-subtitle">Manually trigger data sync operations</div>
    </div>
</div>

<div class="card-grid-3">
    {{-- IPTV Sync --}}
    <div class="card" style="margin-bottom:0;">
        <div style="font-size:0.72rem;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.6px;margin-bottom:12px;">IPTV Channel Sync</div>
        <div class="sync-stat" style="margin-bottom:10px;">Syncs channels, streams, categories, countries, languages, and logos from iptv-org. Takes 2–5 minutes.</div>
        @if($syncLogs['namflix:sync-iptv'] ?? null)
            @php $log = $syncLogs['namflix:sync-iptv']; @endphp
            <div class="sync-stat">Last run: <span>{{ \Carbon\Carbon::parse($log->started_at)->diffForHumans() }}</span></div>
            <div class="sync-stat">Status: <span>
                @if($log->status === 'success') <span class="badge badge-green">Success</span>
                @elseif($log->status === 'running') <span class="badge badge-blue">Running</span>
                @else <span class="badge badge-red">Failed</span>
                @endif
            </span></div>
            @if($log->records_synced !== null)
                <div class="sync-stat">Records: <span>{{ number_format($log->records_synced) }}</span></div>
            @endif
            @if($log->error_message)
                <pre class="error-json" style="margin-top:8px;">{{ $log->error_message }}</pre>
            @endif
        @else
            <div class="text-muted text-sm" style="margin-bottom:10px;">Never synced</div>
        @endif
        <form method="POST" action="{{ route('admin.sync.iptv') }}" style="margin-top:12px;"
              onsubmit="startSync(this, 'Syncing channels...')">
            @csrf
            <button type="submit" class="btn btn-primary" style="width:100%;">
                <svg style="width:14px;height:14px;" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M16.023 9.348h4.992v-.001M2.985 19.644v-4.992m0 0h4.992m-4.993 0 3.181 3.183a8.25 8.25 0 0 0 13.803-3.7M4.031 9.865a8.25 8.25 0 0 1 13.803-3.7l3.181 3.182m0-4.991v4.99" /></svg>
                Run IPTV Sync
            </button>
        </form>
    </div>

    {{-- Stream Health --}}
    <div class="card" style="margin-bottom:0;">
        <div style="font-size:0.72rem;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.6px;margin-bottom:12px;">Stream Health Check</div>
        <div class="sync-stat" style="margin-bottom:10px;">Checks all stream URLs in batches of 50 via HTTP HEAD/GET. Marks each stream live, dead, or geo-blocked.</div>
        @if($syncLogs['namflix:check-streams'] ?? null)
            @php $log = $syncLogs['namflix:check-streams']; @endphp
            <div class="sync-stat">Last run: <span>{{ \Carbon\Carbon::parse($log->started_at)->diffForHumans() }}</span></div>
            <div class="sync-stat">Status: <span>
                @if($log->status === 'success') <span class="badge badge-green">Success</span>
                @elseif($log->status === 'running') <span class="badge badge-blue">Running</span>
                @else <span class="badge badge-red">Failed</span>
                @endif
            </span></div>
            @if($log->records_synced !== null)
                <div class="sync-stat">Streams checked: <span>{{ number_format($log->records_synced) }}</span></div>
            @endif
            @if($log->error_message)
                <pre class="error-json" style="margin-top:8px;">{{ $log->error_message }}</pre>
            @endif
        @else
            <div class="text-muted text-sm" style="margin-bottom:10px;">Never run</div>
        @endif
        <form method="POST" action="{{ route('admin.sync.health') }}" style="margin-top:12px;"
              onsubmit="startSync(this, 'Checking streams...')">
            @csrf
            <button type="submit" class="btn btn-secondary" style="width:100%;">
                <svg style="width:14px;height:14px;" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M8.288 15.038a5.25 5.25 0 0 1 7.424 0M5.106 11.856c3.807-3.808 9.98-3.808 13.788 0M1.924 8.674c5.565-5.565 14.587-5.565 20.152 0M12.53 18.22l-.53.53-.53-.53a.75.75 0 0 1 1.06 0Z" /></svg>
                Run Health Check
            </button>
        </form>
    </div>

    {{-- EPG Sync --}}
    <div class="card" style="margin-bottom:0;">
        <div style="font-size:0.72rem;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.6px;margin-bottom:12px;">EPG Program Guide Sync</div>
        <div class="sync-stat" style="margin-bottom:10px;">Downloads and parses XMLTV program data. Removes expired programs, keeps up to 7 days of future data.</div>
        @if($syncLogs['namflix:sync-epg'] ?? null)
            @php $log = $syncLogs['namflix:sync-epg']; @endphp
            <div class="sync-stat">Last run: <span>{{ \Carbon\Carbon::parse($log->started_at)->diffForHumans() }}</span></div>
            <div class="sync-stat">Status: <span>
                @if($log->status === 'success') <span class="badge badge-green">Success</span>
                @elseif($log->status === 'running') <span class="badge badge-blue">Running</span>
                @else <span class="badge badge-red">Failed</span>
                @endif
            </span></div>
            @if($log->records_synced !== null)
                <div class="sync-stat">Programs: <span>{{ number_format($log->records_synced) }}</span></div>
            @endif
            @if($log->error_message)
                <pre class="error-json" style="margin-top:8px;">{{ $log->error_message }}</pre>
            @endif
        @else
            <div class="text-muted text-sm" style="margin-bottom:10px;">Never synced</div>
        @endif
        <form method="POST" action="{{ route('admin.sync.epg') }}" style="margin-top:12px;"
              onsubmit="startSync(this, 'Syncing EPG data...')">
            @csrf
            <button type="submit" class="btn btn-secondary" style="width:100%;">
                <svg style="width:14px;height:14px;" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 0 1 2.25-2.25h13.5A2.25 2.25 0 0 1 21 7.5v11.25m-18 0A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75m-18 0v-7.5A2.25 2.25 0 0 1 5.25 9h13.5A2.25 2.25 0 0 1 21 11.25v7.5" /></svg>
                Run EPG Sync
            </button>
        </form>
    </div>
</div>

{{-- History --}}
<div class="table-wrap" style="margin-top:20px;">
    <div class="table-header">
        <h3>Sync History</h3>
    </div>
    <table>
        <thead>
            <tr>
                <th>Command</th>
                <th>Status</th>
                <th>Started</th>
                <th>Duration</th>
                <th>Records</th>
                <th>Notes</th>
            </tr>
        </thead>
        <tbody>
            @forelse($history as $log)
            <tr>
                <td style="font-family:monospace;font-size:0.78rem;color:var(--blue);">{{ $log->command }}</td>
                <td>
                    @if($log->status === 'success') <span class="badge badge-green">Success</span>
                    @elseif($log->status === 'running') <span class="badge badge-blue">Running</span>
                    @else <span class="badge badge-red">Failed</span>
                    @endif
                </td>
                <td class="muted">{{ \Carbon\Carbon::parse($log->started_at)->format('M j, H:i') }}</td>
                <td class="muted">
                    @if($log->finished_at)
                        {{ round(\Carbon\Carbon::parse($log->started_at)->diffInSeconds($log->finished_at)) }}s
                    @else
                        —
                    @endif
                </td>
                <td class="muted">{{ $log->records_synced !== null ? number_format($log->records_synced) : '—' }}</td>
                <td>
                    @if($log->error_message)
                        <span title="{{ $log->error_message }}" style="color:#fb923c;font-size:0.78rem;cursor:help;">{{ Str::limit($log->error_message, 50) }}</span>
                    @else
                        <span class="text-muted">—</span>
                    @endif
                </td>
            </tr>
            @empty
            <tr>
                <td colspan="6" style="text-align:center;padding:40px;color:var(--muted);">No sync history yet</td>
            </tr>
            @endforelse
        </tbody>
    </table>
</div>
@endsection

@section('scripts')
<script>
    function startSync(form, label) {
        const btn = form.querySelector('button[type="submit"]');
        btn.disabled = true;
        btn.innerHTML = `<span class="spinner"></span> ${label}`;
    }
</script>
@endsection

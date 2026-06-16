@extends('admin.layouts.app')
@section('title', 'Streams')

@section('content')
<div class="page-header">
    <div>
        <div class="page-title">Streams</div>
        <div class="page-subtitle">Monitor and recheck stream health</div>
    </div>
</div>

@if($staleCount > 0)
<div class="alert alert-warning" style="margin-bottom:16px;">
    <svg style="width:16px;height:16px;flex-shrink:0;" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126ZM12 15.75h.007v.008H12v-.008Z" /></svg>
    {{ number_format($staleCount) }} streams have not been checked in over 24 hours.
    <a href="{{ route('admin.sync') }}" style="color:inherit;margin-left:6px;text-decoration:underline;">Run stream health check →</a>
</div>
@endif

{{-- Filters --}}
<form method="GET" action="{{ route('admin.streams') }}">
    <div class="filters">
        <div class="form-group">
            <label class="form-label">Channel</label>
            <input class="form-input" type="text" name="channel" value="{{ request('channel') }}" placeholder="Channel name..." style="width:180px;">
        </div>
        <div class="form-group">
            <label class="form-label">Status</label>
            <select class="form-input" name="status">
                <option value="">All</option>
                <option value="live" {{ request('status') === 'live' ? 'selected' : '' }}>Live</option>
                <option value="dead" {{ request('status') === 'dead' ? 'selected' : '' }}>Dead</option>
                <option value="geo" {{ request('status') === 'geo' ? 'selected' : '' }}>Geo-Blocked</option>
            </select>
        </div>
        <div class="form-group">
            <label class="form-label">Format</label>
            <select class="form-input" name="format">
                <option value="">All</option>
                <option value="hls" {{ request('format') === 'hls' ? 'selected' : '' }}>HLS (.m3u8)</option>
                <option value="other" {{ request('format') === 'other' ? 'selected' : '' }}>Other</option>
            </select>
        </div>
        <div class="flex-gap" style="padding-bottom:1px;">
            <button type="submit" class="btn btn-primary btn-sm">Filter</button>
            <a href="{{ route('admin.streams') }}" class="btn btn-ghost btn-sm">Reset</a>
        </div>
    </div>
</form>

<div class="table-wrap">
    <div class="table-header">
        <h3>{{ number_format($streams->total()) }} streams</h3>
        <div class="flex-gap" style="font-size:0.75rem;color:var(--muted);">
            <span class="badge badge-green">■ Live</span>
            <span class="badge badge-red">■ Dead</span>
            <span class="badge badge-orange">■ Geo-blocked</span>
        </div>
    </div>
    <table>
        <thead>
            <tr>
                <th>Channel</th>
                <th>URL</th>
                <th>Status</th>
                <th>Failure Reason</th>
                <th>Last Checked</th>
                <th style="width:80px;">Action</th>
            </tr>
        </thead>
        <tbody>
            @forelse($streams as $stream)
            <tr class="{{ $stream->is_geo_blocked ? 'row-geo' : ($stream->is_live ? 'row-live' : 'row-dead') }}" style="border-left-width:3px;border-left-style:solid;">
                <td>
                    <div style="font-weight:500;font-size:0.85rem;">{{ $stream->channel_name }}</div>
                    <div class="muted" style="font-size:0.73rem;">{{ $stream->channel_id }}</div>
                </td>
                <td>
                    <span class="truncate" style="max-width:260px;display:block;" title="{{ $stream->url }}">{{ $stream->url }}</span>
                </td>
                <td>
                    @if($stream->is_geo_blocked)
                        <span class="badge badge-orange">Geo-blocked</span>
                    @elseif($stream->is_live)
                        <span class="badge badge-green">Live</span>
                    @else
                        <span class="badge badge-red">Dead</span>
                    @endif
                </td>
                <td>
                    @if($stream->failure_reason)
                        <span class="badge badge-gray">{{ $stream->failure_reason }}</span>
                    @else
                        <span class="text-muted">—</span>
                    @endif
                </td>
                <td class="muted">
                    @if($stream->last_checked_at)
                        {{ \Carbon\Carbon::parse($stream->last_checked_at)->diffForHumans() }}
                    @else
                        Never
                    @endif
                </td>
                <td>
                    <button
                        class="btn btn-ghost btn-sm recheck-btn"
                        data-id="{{ $stream->id }}"
                        onclick="recheckStream('{{ $stream->id }}', this)"
                    >Recheck</button>
                </td>
            </tr>
            @empty
            <tr>
                <td colspan="6" style="text-align:center;padding:40px;color:var(--muted);">No streams found</td>
            </tr>
            @endforelse
        </tbody>
    </table>
</div>

@include('admin.partials.pagination', ['paginator' => $streams])
@endsection

@section('scripts')
<script>
    function recheckStream(id, btn) {
        btn.disabled = true;
        btn.innerHTML = '<span class="spinner"></span>';
        fetch(`/admin/streams/${id}/recheck`, {
            method: 'POST',
            headers: {
                'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content,
                'Accept': 'application/json'
            }
        })
        .then(r => r.json())
        .then(data => {
            const row = btn.closest('tr');
            const statusCell = row.cells[2];
            const reasonCell = row.cells[3];
            const checkedCell = row.cells[4];

            row.classList.remove('row-live', 'row-dead', 'row-geo');

            if (data.is_geo_blocked) {
                statusCell.innerHTML = '<span class="badge badge-orange">Geo-blocked</span>';
                row.classList.add('row-geo');
            } else if (data.is_live) {
                statusCell.innerHTML = '<span class="badge badge-green">Live</span>';
                row.classList.add('row-live');
            } else {
                statusCell.innerHTML = '<span class="badge badge-red">Dead</span>';
                row.classList.add('row-dead');
            }

            reasonCell.innerHTML = data.failure_reason
                ? `<span class="badge badge-gray">${data.failure_reason}</span>`
                : '<span class="text-muted">—</span>';
            checkedCell.textContent = 'Just now';

            btn.disabled = false;
            btn.textContent = 'Recheck';
        })
        .catch(() => {
            btn.disabled = false;
            btn.textContent = 'Error';
        });
    }
</script>
@endsection

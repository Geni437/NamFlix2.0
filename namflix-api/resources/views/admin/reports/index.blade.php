@extends('admin.layouts.app')
@section('title', 'Stream Reports')

@section('content')
<div class="page-header">
    <div>
        <div class="page-title">Stream Reports</div>
        <div class="page-subtitle">User-submitted stream quality reports</div>
    </div>
</div>

{{-- Filters --}}
<form method="GET" action="{{ route('admin.reports') }}">
    <div class="filters">
        <div class="form-group">
            <label class="form-label">Reason</label>
            <select class="form-input" name="reason">
                <option value="">All Reasons</option>
                <option value="stream_not_working" {{ request('reason') === 'stream_not_working' ? 'selected' : '' }}>Not Working</option>
                <option value="poor_quality" {{ request('reason') === 'poor_quality' ? 'selected' : '' }}>Poor Quality</option>
                <option value="wrong_content" {{ request('reason') === 'wrong_content' ? 'selected' : '' }}>Wrong Content</option>
                <option value="buffering" {{ request('reason') === 'buffering' ? 'selected' : '' }}>Buffering</option>
                <option value="other" {{ request('reason') === 'other' ? 'selected' : '' }}>Other</option>
            </select>
        </div>
        <div class="flex-gap" style="padding-bottom:1px;">
            <button type="submit" class="btn btn-primary btn-sm">Filter</button>
            <a href="{{ route('admin.reports') }}" class="btn btn-ghost btn-sm">Reset</a>
        </div>
    </div>
</form>

<div class="table-wrap">
    <div class="table-header">
        <h3>{{ number_format($reports->total()) }} reported streams</h3>
    </div>
    <table>
        <thead>
            <tr>
                <th>Channel</th>
                <th>Stream URL</th>
                <th>Reports</th>
                <th>Reasons</th>
                <th>Stream Status</th>
                <th>Last Reported</th>
                <th style="width:160px;">Actions</th>
            </tr>
        </thead>
        <tbody>
            @forelse($reports as $report)
            <tr>
                <td>
                    <div style="font-weight:500;font-size:0.85rem;">{{ $report->channel_name }}</div>
                    <div class="muted" style="font-size:0.73rem;">{{ $report->channel_id }}</div>
                </td>
                <td>
                    <span class="truncate" title="{{ $report->url }}">{{ $report->url }}</span>
                </td>
                <td>
                    <span class="badge {{ $report->report_count >= 5 ? 'badge-red' : ($report->report_count >= 2 ? 'badge-orange' : 'badge-gray') }}">
                        {{ $report->report_count }}
                    </span>
                </td>
                <td>
                    @foreach(array_filter(explode(', ', $report->reasons ?? '')) as $reason)
                        <span class="badge badge-gray" style="margin-bottom:2px;">{{ str_replace('_', ' ', $reason) }}</span>
                    @endforeach
                </td>
                <td>
                    @if($report->is_live)
                        <span class="badge badge-green">Live</span>
                    @else
                        <span class="badge badge-red">Dead</span>
                    @endif
                </td>
                <td class="muted">
                    {{ \Carbon\Carbon::parse($report->last_reported)->diffForHumans() }}
                </td>
                <td>
                    <div class="flex-gap">
                        <form method="POST" action="{{ route('admin.reports.recheck', $report->stream_id) }}">
                            @csrf
                            <button type="submit" class="btn btn-primary btn-sm">Recheck</button>
                        </form>
                        <form method="POST" action="{{ route('admin.reports.dismiss', $report->stream_id) }}"
                              onsubmit="return confirm('Dismiss all reports for this stream?')">
                            @csrf
                            <button type="submit" class="btn btn-ghost btn-sm">Dismiss</button>
                        </form>
                    </div>
                </td>
            </tr>
            @empty
            <tr>
                <td colspan="7" style="text-align:center;padding:40px;color:var(--muted);">
                    No reports — all streams are healthy!
                </td>
            </tr>
            @endforelse
        </tbody>
    </table>
</div>

@include('admin.partials.pagination', ['paginator' => $reports])
@endsection

@extends('admin.layouts.app')
@section('title', 'Channels')

@section('content')
<div class="page-header">
    <div>
        <div class="page-title">Channels</div>
        <div class="page-subtitle">Manage IPTV channel catalogue</div>
    </div>
</div>

{{-- Filters --}}
<form method="GET" action="{{ route('admin.channels') }}">
    <div class="filters">
        <div class="form-group">
            <label class="form-label">Search</label>
            <input class="form-input" type="text" name="search" value="{{ request('search') }}" placeholder="Channel name..." style="width:200px;">
        </div>
        <div class="form-group">
            <label class="form-label">Country</label>
            <select class="form-input" name="country">
                <option value="">All Countries</option>
                @foreach($countries as $c)
                    <option value="{{ $c->code }}" {{ request('country') === $c->code ? 'selected' : '' }}>{{ $c->name }}</option>
                @endforeach
            </select>
        </div>
        <div class="form-group">
            <label class="form-label">Category</label>
            <select class="form-input" name="category">
                <option value="">All Categories</option>
                @foreach($categories as $cat)
                    <option value="{{ $cat->id }}" {{ request('category') === $cat->id ? 'selected' : '' }}>{{ $cat->name }}</option>
                @endforeach
            </select>
        </div>
        <div class="form-group">
            <label class="form-label">Status</label>
            <select class="form-input" name="hidden">
                <option value="">All</option>
                <option value="0" {{ request('hidden') === '0' ? 'selected' : '' }}>Visible</option>
                <option value="1" {{ request('hidden') === '1' ? 'selected' : '' }}>Hidden</option>
            </select>
        </div>
        <div class="flex-gap" style="padding-bottom:1px;">
            <button type="submit" class="btn btn-primary btn-sm">Filter</button>
            <a href="{{ route('admin.channels') }}" class="btn btn-ghost btn-sm">Reset</a>
        </div>
    </div>
</form>

{{-- Bulk actions --}}
<form id="bulkForm" method="POST" action="{{ route('admin.channels.bulk-hide') }}">
    @csrf
    <div class="table-wrap">
        <div class="table-header">
            <h3>{{ number_format($channels->total()) }} channels</h3>
            <div class="flex-gap">
                <select id="bulkAction" class="form-input" style="min-width:140px;">
                    <option value="">Bulk action...</option>
                    <option value="hide">Hide selected</option>
                    <option value="show">Show selected</option>
                </select>
                <button type="button" class="btn btn-secondary btn-sm" onclick="applyBulk()">Apply</button>
            </div>
        </div>
        <table>
            <thead>
                <tr>
                    <th style="width:38px;"><input type="checkbox" id="selectAll" onclick="toggleAll(this)"></th>
                    <th>Channel</th>
                    <th>Country</th>
                    <th>Categories</th>
                    <th>Streams</th>
                    <th>Live</th>
                    <th>Status</th>
                    <th style="width:100px;">Actions</th>
                </tr>
            </thead>
            <tbody>
                @forelse($channels as $channel)
                <tr>
                    <td><input type="checkbox" name="ids[]" value="{{ $channel->id }}" class="row-check"></td>
                    <td>
                        <div class="flex-gap">
                            @if($channel->logo_url)
                                <img class="channel-logo" src="{{ $channel->logo_url }}" alt="" loading="lazy" onerror="this.style.display='none'">
                            @endif
                            <div>
                                <div style="font-weight:500;font-size:0.85rem;">{{ $channel->name }}</div>
                                <div class="muted" style="font-size:0.73rem;">{{ $channel->id }}</div>
                            </div>
                        </div>
                    </td>
                    <td>
                        @if($channel->country)
                            <span title="{{ $channel->country }}">{{ $channel->country }}</span>
                        @else
                            <span class="text-muted">—</span>
                        @endif
                    </td>
                    <td>
                        @php $cats = json_decode($channel->categories ?? '[]', true); @endphp
                        @if($cats)
                            <span class="text-sm text-muted">{{ implode(', ', array_slice($cats, 0, 2)) }}{{ count($cats) > 2 ? ' +'.count($cats)-2 : '' }}</span>
                        @else
                            <span class="text-muted">—</span>
                        @endif
                    </td>
                    <td class="muted">{{ $channel->streams_count ?? 0 }}</td>
                    <td>
                        @if(($channel->live_streams_count ?? 0) > 0)
                            <span class="badge badge-green">{{ $channel->live_streams_count }}</span>
                        @else
                            <span class="badge badge-gray">0</span>
                        @endif
                    </td>
                    <td>
                        @if($channel->is_hidden)
                            <span class="badge badge-red">Hidden</span>
                        @else
                            <span class="badge badge-green">Visible</span>
                        @endif
                    </td>
                    <td>
                        <form method="POST" action="{{ route('admin.channels.toggle-hidden', $channel->id) }}" style="display:inline;">
                            @csrf
                            <button type="submit" class="btn btn-ghost btn-sm">
                                {{ $channel->is_hidden ? 'Show' : 'Hide' }}
                            </button>
                        </form>
                    </td>
                </tr>
                @empty
                <tr>
                    <td colspan="8" style="text-align:center;padding:40px;color:var(--muted);">No channels found</td>
                </tr>
                @endforelse
            </tbody>
        </table>
    </div>
    <input type="hidden" name="action" id="bulkActionInput" value="">
</form>

@include('admin.partials.pagination', ['paginator' => $channels])
@endsection

@section('scripts')
<script>
    function toggleAll(cb) {
        document.querySelectorAll('.row-check').forEach(c => c.checked = cb.checked);
    }
    function applyBulk() {
        const action = document.getElementById('bulkAction').value;
        const checked = document.querySelectorAll('.row-check:checked');
        if (!action) return alert('Select an action');
        if (!checked.length) return alert('Select at least one channel');
        document.getElementById('bulkActionInput').value = action;
        document.getElementById('bulkForm').submit();
    }
    document.querySelectorAll('.row-check').forEach(c => {
        c.addEventListener('change', () => {
            const all = document.querySelectorAll('.row-check');
            const checked = document.querySelectorAll('.row-check:checked');
            document.getElementById('selectAll').indeterminate = checked.length > 0 && checked.length < all.length;
            document.getElementById('selectAll').checked = checked.length === all.length;
        });
    });
</script>
@endsection

@extends('admin.layouts.app')
@section('title', 'Users')

@section('content')
<div class="page-header">
    <div>
        <div class="page-title">Users</div>
        <div class="page-subtitle">Manage registered accounts</div>
    </div>
</div>

{{-- Stats --}}
<div class="kpi-grid" style="margin-bottom:20px;">
    <div class="kpi-card">
        <div class="kpi-label">Total Users</div>
        <div class="kpi-value blue">{{ number_format($userStats['total']) }}</div>
    </div>
    <div class="kpi-card">
        <div class="kpi-label">Pro Subscribers</div>
        <div class="kpi-value" style="color:#a78bfa;">{{ number_format($userStats['pro']) }}</div>
    </div>
    <div class="kpi-card">
        <div class="kpi-label">Active Today</div>
        <div class="kpi-value green">{{ number_format($userStats['active_today']) }}</div>
    </div>
    <div class="kpi-card">
        <div class="kpi-label">Banned</div>
        <div class="kpi-value red">{{ number_format($userStats['banned']) }}</div>
    </div>
</div>

{{-- Filters --}}
<form method="GET" action="{{ route('admin.users') }}">
    <div class="filters">
        <div class="form-group">
            <label class="form-label">Search</label>
            <input class="form-input" type="text" name="search" value="{{ request('search') }}" placeholder="Email or username..." style="width:220px;">
        </div>
        <div class="form-group">
            <label class="form-label">Role</label>
            <select class="form-input" name="role">
                <option value="">All Roles</option>
                <option value="user" {{ request('role') === 'user' ? 'selected' : '' }}>User</option>
                <option value="admin" {{ request('role') === 'admin' ? 'selected' : '' }}>Admin</option>
            </select>
        </div>
        <div class="form-group">
            <label class="form-label">Status</label>
            <select class="form-input" name="banned">
                <option value="">All</option>
                <option value="0" {{ request('banned') === '0' ? 'selected' : '' }}>Active</option>
                <option value="1" {{ request('banned') === '1' ? 'selected' : '' }}>Banned</option>
            </select>
        </div>
        <label class="checkbox-label" style="padding-bottom:7px;">
            <input type="checkbox" name="pro" value="1" {{ request('pro') ? 'checked' : '' }}>
            Pro only
        </label>
        <div class="flex-gap" style="padding-bottom:1px;">
            <button type="submit" class="btn btn-primary btn-sm">Filter</button>
            <a href="{{ route('admin.users') }}" class="btn btn-ghost btn-sm">Reset</a>
        </div>
    </div>
</form>

<div class="table-wrap">
    <div class="table-header">
        <h3>{{ number_format($users->total()) }} users</h3>
    </div>
    <table>
        <thead>
            <tr>
                <th>User</th>
                <th>Role</th>
                <th>Pro</th>
                <th>Country</th>
                <th>Last Seen</th>
                <th>Joined</th>
                <th style="width:80px;">Actions</th>
            </tr>
        </thead>
        <tbody>
            @forelse($users as $user)
            <tr>
                <td>
                    <div style="font-weight:500;font-size:0.85rem;">{{ $user->email }}</div>
                    @if($user->username)
                        <div class="muted" style="font-size:0.73rem;">@{{ $user->username }}</div>
                    @endif
                    @if($user->is_banned)
                        <span class="badge badge-red" style="margin-top:3px;">Banned</span>
                    @endif
                </td>
                <td>
                    @if($user->role === 'admin')
                        <span class="badge badge-purple">Admin</span>
                    @else
                        <span class="badge badge-gray">User</span>
                    @endif
                </td>
                <td>
                    @if($user->is_pro)
                        <span class="badge badge-blue">Pro</span>
                        @if($user->pro_expires_at)
                            <div class="muted" style="font-size:0.72rem;margin-top:2px;">until {{ \Carbon\Carbon::parse($user->pro_expires_at)->format('M j, Y') }}</div>
                        @endif
                    @else
                        <span class="badge badge-gray">Free</span>
                    @endif
                </td>
                <td class="muted">{{ $user->preferred_country ?? '—' }}</td>
                <td class="muted">
                    {{ $user->last_seen_at ? \Carbon\Carbon::parse($user->last_seen_at)->diffForHumans() : 'Never' }}
                </td>
                <td class="muted">{{ \Carbon\Carbon::parse($user->created_at)->format('M j, Y') }}</td>
                <td>
                    <button class="btn btn-ghost btn-sm" onclick="viewUser('{{ $user->id }}')">View</button>
                </td>
            </tr>
            @empty
            <tr>
                <td colspan="7" style="text-align:center;padding:40px;color:var(--muted);">No users found</td>
            </tr>
            @endforelse
        </tbody>
    </table>
</div>

@include('admin.partials.pagination', ['paginator' => $users])

{{-- User Detail Modal --}}
<div class="modal-overlay" id="userModal">
    <div class="modal">
        <div class="modal-head">
            <div class="modal-title" id="modalTitle">User Details</div>
            <button class="modal-close" onclick="closeModal()">&times;</button>
        </div>
        <div id="modalBody" style="min-height:120px;display:flex;align-items:center;justify-content:center;">
            <span class="spinner" style="width:24px;height:24px;border-width:3px;"></span>
        </div>
    </div>
</div>
@endsection

@section('scripts')
<script>
    function viewUser(id) {
        document.getElementById('userModal').classList.add('open');
        document.getElementById('modalBody').innerHTML = '<span class="spinner" style="width:24px;height:24px;border-width:3px;"></span>';

        fetch(`/admin/users/${id}/details`, {
            headers: { 'Accept': 'application/json', 'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content }
        })
        .then(r => r.json())
        .then(data => {
            const u = data.user;
            let history = '';
            if (data.history && data.history.length > 0) {
                history = `<div style="margin-top:16px;">
                    <div style="font-size:0.72rem;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.5px;margin-bottom:10px;">Recent Watch History</div>
                    ${data.history.map(h => `
                        <div style="display:flex;justify-content:space-between;padding:7px 0;border-bottom:1px solid var(--border);font-size:0.82rem;">
                            <span>${h.channel_name || h.channel_id}</span>
                            <span style="color:var(--muted);">${h.watched_at ? new Date(h.watched_at).toLocaleString() : ''}</span>
                        </div>
                    `).join('')}
                </div>`;
            }

            document.getElementById('modalTitle').textContent = u.email;
            document.getElementById('modalBody').innerHTML = `
                <div class="detail-row"><span class="detail-key">ID</span><span style="font-family:monospace;font-size:0.78rem;">${u.id}</span></div>
                <div class="detail-row"><span class="detail-key">Username</span><span>${u.username || '—'}</span></div>
                <div class="detail-row"><span class="detail-key">Role</span><span>${u.role}</span></div>
                <div class="detail-row"><span class="detail-key">Pro</span><span>${u.is_pro ? '✓ Active' + (u.pro_expires_at ? ' until ' + u.pro_expires_at : '') : 'No'}</span></div>
                <div class="detail-row"><span class="detail-key">Banned</span><span style="color:${u.is_banned ? '#f87171' : '#4ade80'}">${u.is_banned ? 'Yes' : 'No'}</span></div>
                <div class="detail-row"><span class="detail-key">Country</span><span>${u.preferred_country || '—'}</span></div>
                <div class="detail-row"><span class="detail-key">Language</span><span>${u.preferred_language || '—'}</span></div>
                <div class="detail-row"><span class="detail-key">UI Language</span><span>${u.ui_language || '—'}</span></div>
                <div class="detail-row"><span class="detail-key">Last Seen</span><span>${u.last_seen_at || 'Never'}</span></div>
                <div class="detail-row"><span class="detail-key">Joined</span><span>${u.created_at}</span></div>
                ${history}
                <div style="display:flex;gap:8px;margin-top:16px;">
                    <form method="POST" action="/admin/users/${u.id}/toggle-ban">
                        <input type="hidden" name="_token" value="${document.querySelector('meta[name="csrf-token"]').content}">
                        <button type="submit" class="btn ${u.is_banned ? 'btn-secondary' : 'btn-danger'} btn-sm">
                            ${u.is_banned ? 'Unban User' : 'Ban User'}
                        </button>
                    </form>
                    <form method="POST" action="/admin/users/${u.id}/toggle-admin">
                        <input type="hidden" name="_token" value="${document.querySelector('meta[name="csrf-token"]').content}">
                        <button type="submit" class="btn btn-ghost btn-sm">
                            ${u.role === 'admin' ? 'Revoke Admin' : 'Grant Admin'}
                        </button>
                    </form>
                </div>
            `;
        })
        .catch(() => {
            document.getElementById('modalBody').innerHTML = '<span style="color:#f87171;">Failed to load user details.</span>';
        });
    }

    function closeModal() {
        document.getElementById('userModal').classList.remove('open');
    }

    document.getElementById('userModal').addEventListener('click', function(e) {
        if (e.target === this) closeModal();
    });
</script>
@endsection

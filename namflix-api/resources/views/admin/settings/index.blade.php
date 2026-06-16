@extends('admin.layouts.app')
@section('title', 'Settings')

@section('content')
<div class="page-header">
    <div>
        <div class="page-title">Platform Settings</div>
        <div class="page-subtitle">Configure global platform behaviour</div>
    </div>
</div>

<form method="POST" action="{{ route('admin.settings.update') }}">
    @csrf

    <div class="card" style="max-width:680px;">
        <div class="card-title">General</div>

        <div class="form-group" style="margin-bottom:18px;">
            <label class="form-label" for="platform_name">Platform Name</label>
            <input
                class="form-input"
                type="text"
                id="platform_name"
                name="platform_name"
                value="{{ old('platform_name', $settings['platform_name']) }}"
                required
                style="max-width:320px;"
            >
        </div>

        <div class="form-group" style="margin-bottom:18px;">
            <label class="form-label" for="admin_email">Admin Notification Email</label>
            <input
                class="form-input"
                type="email"
                id="admin_email"
                name="admin_email"
                value="{{ old('admin_email', $settings['admin_email']) }}"
                placeholder="admin@example.com"
                style="max-width:320px;"
            >
            <div class="text-sm text-muted" style="margin-top:5px;">Leave blank to disable email notifications.</div>
        </div>

        <div class="form-group" style="margin-bottom:18px;">
            <label class="checkbox-label" style="gap:10px;">
                <input
                    type="checkbox"
                    name="maintenance_mode"
                    value="1"
                    {{ old('maintenance_mode', $settings['maintenance_mode']) == '1' ? 'checked' : '' }}
                    style="width:16px;height:16px;accent-color:var(--accent);"
                >
                <div>
                    <div style="font-weight:600;color:var(--text);">Maintenance Mode</div>
                    <div class="text-sm text-muted">Returns HTTP 503 on all public API routes. Admin dashboard remains accessible.</div>
                </div>
            </label>
        </div>
    </div>

    <div class="card" style="max-width:680px;">
        <div class="card-title">Subscription Pricing</div>

        <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px;">
            <div class="form-group">
                <label class="form-label" for="pro_monthly_price">Monthly Price (USD)</label>
                <div style="position:relative;">
                    <span style="position:absolute;left:11px;top:50%;transform:translateY(-50%);color:var(--muted);">$</span>
                    <input
                        class="form-input"
                        type="number"
                        id="pro_monthly_price"
                        name="pro_monthly_price"
                        value="{{ old('pro_monthly_price', $settings['pro_monthly_price']) }}"
                        step="0.01" min="0" required
                        style="padding-left:22px;"
                    >
                </div>
            </div>
            <div class="form-group">
                <label class="form-label" for="pro_annual_price">Annual Price (USD)</label>
                <div style="position:relative;">
                    <span style="position:absolute;left:11px;top:50%;transform:translateY(-50%);color:var(--muted);">$</span>
                    <input
                        class="form-input"
                        type="number"
                        id="pro_annual_price"
                        name="pro_annual_price"
                        value="{{ old('pro_annual_price', $settings['pro_annual_price']) }}"
                        step="0.01" min="0" required
                        style="padding-left:22px;"
                    >
                </div>
            </div>
        </div>

        @if($settings['pro_monthly_price'] && $settings['pro_annual_price'] && floatval($settings['pro_monthly_price']) > 0)
            @php
                $monthly = floatval($settings['pro_monthly_price']);
                $annual = floatval($settings['pro_annual_price']);
                $savings = $monthly > 0 ? round((1 - ($annual / 12) / $monthly) * 100) : 0;
            @endphp
            @if($savings > 0)
                <div class="text-sm" style="color:#4ade80;margin-top:10px;">
                    Annual saves {{ $savings }}% vs monthly
                </div>
            @endif
        @endif
    </div>

    <div class="card" style="max-width:680px;">
        <div class="card-title">Free Tier Limits</div>

        <div class="form-group">
            <label class="form-label" for="max_free_favorites">Max Favorites (Free Users)</label>
            <input
                class="form-input"
                type="number"
                id="max_free_favorites"
                name="max_free_favorites"
                value="{{ old('max_free_favorites', $settings['max_free_favorites']) }}"
                min="1" max="500" required
                style="max-width:140px;"
            >
            <div class="text-sm text-muted" style="margin-top:5px;">Pro users have unlimited favorites.</div>
        </div>
    </div>

    <div style="display:flex;gap:10px;max-width:680px;">
        <button type="submit" class="btn btn-primary">
            <svg style="width:14px;height:14px;" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="m4.5 12.75 6 6 9-13.5" /></svg>
            Save Settings
        </button>
        <a href="{{ route('admin.settings') }}" class="btn btn-ghost">Discard Changes</a>
    </div>
</form>
@endsection

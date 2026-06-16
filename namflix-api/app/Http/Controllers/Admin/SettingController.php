<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Setting;
use Illuminate\Http\Request;

class SettingController extends Controller
{
    private array $defaults = [
        'platform_name' => 'NamFlix',
        'max_free_favorites' => '20',
        'pro_monthly_price' => '2.99',
        'pro_annual_price' => '19.99',
        'maintenance_mode' => '0',
        'admin_email' => '',
    ];

    public function index()
    {
        $settings = [];
        foreach ($this->defaults as $key => $default) {
            $settings[$key] = Setting::get($key, $default);
        }
        return view('admin.settings.index', compact('settings'));
    }

    public function update(Request $request)
    {
        $request->validate([
            'platform_name' => 'required|string|max:100',
            'max_free_favorites' => 'required|integer|min:1|max:500',
            'pro_monthly_price' => 'required|numeric|min:0',
            'pro_annual_price' => 'required|numeric|min:0',
            'admin_email' => 'nullable|email',
        ]);

        Setting::set('platform_name', $request->input('platform_name'));
        Setting::set('max_free_favorites', $request->input('max_free_favorites'));
        Setting::set('pro_monthly_price', $request->input('pro_monthly_price'));
        Setting::set('pro_annual_price', $request->input('pro_annual_price'));
        Setting::set('maintenance_mode', $request->boolean('maintenance_mode') ? '1' : '0');
        Setting::set('admin_email', $request->input('admin_email', ''));

        return back()->with('success', 'Settings saved successfully.');
    }
}

<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Country;
use App\Models\User;
use App\Models\UserFavorite;
use App\Models\WatchHistory;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class UserController extends Controller
{
    public function index(Request $request)
    {
        $stats = [
            'total' => User::count(),
            'active_7d' => User::where('last_seen_at', '>=', now()->subDays(7))->count(),
            'pro' => User::where('is_pro', true)->count(),
            'banned' => User::where('is_banned', true)->count(),
        ];

        $query = User::query();

        if ($search = $request->get('search')) {
            $query->where(function ($q) use ($search) {
                $q->where('email', 'like', "%{$search}%")
                  ->orWhere('username', 'like', "%{$search}%");
            });
        }

        $role = $request->get('role', 'all');
        if ($role !== 'all') {
            $query->where('role', $role);
        }

        $status = $request->get('status', 'all');
        if ($status === 'active') {
            $query->where('last_seen_at', '>=', now()->subDays(7));
        } elseif ($status === 'banned') {
            $query->where('is_banned', true);
        } elseif ($status === 'pro') {
            $query->where('is_pro', true);
        }

        if ($country = $request->get('country')) {
            $query->where('preferred_country', strtoupper($country));
        }

        $users = $query
            ->withCount(['watchHistory', 'favorites'])
            ->orderByDesc('created_at')
            ->paginate(50)
            ->withQueryString();

        $countries = Country::orderBy('name')->get(['code', 'name']);

        return view('admin.users.index', compact('users', 'stats', 'countries'));
    }

    public function details(User $user)
    {
        $recentHistory = WatchHistory::where('user_id', $user->id)
            ->with('channel:id,name')
            ->orderByDesc('watched_at')
            ->limit(10)
            ->get();

        return response()->json([
            'success' => true,
            'data' => [
                'user' => $user->only(['id', 'email', 'username', 'role', 'is_pro', 'is_banned', 'preferred_country', 'created_at', 'last_seen_at']),
                'watch_history' => $recentHistory,
                'favorites_count' => UserFavorite::where('user_id', $user->id)->count(),
                'watch_events_count' => WatchHistory::where('user_id', $user->id)->count(),
            ],
        ]);
    }

    public function toggleBan(User $user)
    {
        if ($user->id === Auth::id()) {
            return back()->with('error', 'You cannot ban your own account.');
        }

        $user->update(['is_banned' => !$user->is_banned]);
        $state = $user->is_banned ? 'banned' : 'unbanned';
        return back()->with('success', "User {$user->email} has been {$state}.");
    }

    public function toggleAdmin(User $user)
    {
        if ($user->id === Auth::id()) {
            return back()->with('error', 'You cannot change your own role.');
        }

        $newRole = $user->role === 'admin' ? 'user' : 'admin';
        $user->update(['role' => $newRole]);
        return back()->with('success', "User {$user->email} role changed to {$newRole}.");
    }
}

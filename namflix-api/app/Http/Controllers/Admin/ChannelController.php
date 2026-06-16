<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Models\Channel;
use App\Models\Country;
use Illuminate\Http\Request;

class ChannelController extends Controller
{
    public function index(Request $request)
    {
        $query = Channel::query();

        if ($search = $request->get('search')) {
            $query->where('name', 'like', "%{$search}%");
        }

        if ($country = $request->get('country')) {
            $query->where('country_code', strtoupper($country));
        }

        if ($category = $request->get('category')) {
            $query->whereJsonContains('categories', $category);
        }

        $status = $request->get('status', 'all');
        if ($status === 'active') {
            $query->where('is_hidden', false);
        } elseif ($status === 'hidden') {
            $query->where('is_hidden', true);
        }

        if ($request->boolean('has_live_streams')) {
            $query->whereHas('streams', fn ($q) => $q->where('is_live', true));
        }

        $channels = $query
            ->with('logo')
            ->withCount([
                'streams',
                'streams as live_streams_count' => fn ($q) => $q->where('is_live', true),
            ])
            ->orderBy('name')
            ->paginate(50)
            ->withQueryString();

        $countries = Country::orderBy('name')->get(['code', 'name', 'flag']);
        $categories = Category::orderBy('name')->get(['id', 'name']);

        return view('admin.channels.index', compact('channels', 'countries', 'categories'));
    }

    public function toggleHidden(Request $request, string $id)
    {
        $channel = Channel::findOrFail($id);
        $channel->update(['is_hidden' => !$channel->is_hidden]);
        $state = $channel->is_hidden ? 'hidden' : 'visible';
        return back()->with('success', "Channel \"{$channel->name}\" is now {$state}.");
    }

    public function bulkHide(Request $request)
    {
        $ids = $request->input('channel_ids', []);
        if (empty($ids)) {
            return back()->with('error', 'No channels selected.');
        }
        Channel::whereIn('id', $ids)->update(['is_hidden' => true]);
        return back()->with('success', count($ids) . ' channel(s) hidden.');
    }
}

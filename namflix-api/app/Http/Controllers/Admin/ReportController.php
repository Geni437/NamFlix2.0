<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Stream;
use App\Models\StreamReport;
use App\Services\StreamHealthService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ReportController extends Controller
{
    public function index(Request $request)
    {
        $query = DB::table('stream_reports')
            ->select(
                'streams.id as stream_id',
                'streams.url',
                'streams.is_live',
                'channels.id as channel_id',
                'channels.name as channel_name',
                DB::raw('COUNT(stream_reports.id) as report_count'),
                DB::raw('MAX(stream_reports.created_at) as last_reported'),
                DB::raw('GROUP_CONCAT(DISTINCT stream_reports.reason ORDER BY stream_reports.reason SEPARATOR ", ") as reasons')
            )
            ->join('streams', 'stream_reports.stream_id', '=', 'streams.id')
            ->join('channels', 'streams.channel_id', '=', 'channels.id')
            ->groupBy('streams.id', 'streams.url', 'streams.is_live', 'channels.id', 'channels.name');

        if ($reason = $request->get('reason')) {
            $query->where('stream_reports.reason', $reason);
        }

        $reports = $query->orderByDesc('report_count')
            ->paginate(50)
            ->withQueryString();

        return view('admin.reports.index', compact('reports'));
    }

    public function dismiss(string $streamId)
    {
        StreamReport::where('stream_id', $streamId)->delete();
        return back()->with('success', 'All reports for this stream have been dismissed.');
    }

    public function recheckAndDismiss(string $streamId)
    {
        $stream = Stream::findOrFail($streamId);
        $service = app(StreamHealthService::class);
        $result = $service->checkStream($stream);
        $stream->update(array_merge($result, ['last_checked_at' => now()]));
        StreamReport::where('stream_id', $streamId)->delete();

        $status = $stream->is_live ? 'online' : ($stream->is_geo_blocked ? 'geo-blocked' : 'offline');
        return back()->with('success', "Stream rechecked ({$status}) and reports cleared.");
    }
}

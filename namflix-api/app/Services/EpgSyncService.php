<?php

namespace App\Services;

use App\Models\Channel;
use App\Models\EpgProgram;
use App\Models\SyncLog;
use Carbon\Carbon;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;

class EpgSyncService
{
    private const GUIDES_URL    = 'https://iptv-org.github.io/api/guides.json';
    private const MAX_DAYS      = 7;
    private const BATCH_SIZE    = 100;

    public function sync(): array
    {
        $stats = ['sources_fetched' => 0, 'inserted' => 0, 'updated' => 0, 'errors' => 0];

        $log = SyncLog::create([
            'type'       => 'epg_sync',
            'status'     => 'running',
            'started_at' => now(),
            'errors'     => [],
        ]);

        $errorMessages = [];

        try {
            $guides = $this->fetchGuides();

            // Build channel_id → guide URL map (first guide wins per channel)
            $channelGuideMap = [];
            foreach ($guides as $guide) {
                $channelId = $guide['channel'] ?? null;
                $url       = $guide['url'] ?? null;
                if ($channelId && $url && !isset($channelGuideMap[$channelId])) {
                    $channelGuideMap[$channelId] = $url;
                }
            }

            // Restrict to channels we actually have
            $ourIds = Channel::whereIn('id', array_keys($channelGuideMap))->pluck('id')->toArray();

            // Group channels by XMLTV URL to avoid fetching the same file multiple times
            $urlToChannels = [];
            foreach ($ourIds as $id) {
                $urlToChannels[$channelGuideMap[$id]][] = $id;
            }

            foreach ($urlToChannels as $url => $channelIds) {
                try {
                    $this->processXmltvUrl($url, $channelIds, $stats);
                    $stats['sources_fetched']++;
                } catch (\Exception $e) {
                    $stats['errors']++;
                    $msg = "EPG URL {$url}: {$e->getMessage()}";
                    $errorMessages[] = $msg;
                    Log::warning($msg);
                }
            }

            // Remove stale programs (ended > 1 hour ago)
            EpgProgram::where('end_time', '<', now()->subHour())->delete();

            $log->update([
                'status'       => 'success',
                'completed_at' => now(),
                'errors'       => $errorMessages,
            ]);

        } catch (\Exception $e) {
            $stats['errors']++;
            Log::error('EPG sync critical failure: ' . $e->getMessage());
            $log->update([
                'status'       => 'failed',
                'completed_at' => now(),
                'errors'       => array_merge($errorMessages, [$e->getMessage()]),
            ]);
        }

        return $stats;
    }

    private function fetchGuides(): array
    {
        $response = Http::timeout(30)->retry(3, 1000)->get(self::GUIDES_URL);
        if (!$response->successful()) {
            throw new \RuntimeException("Failed to fetch guides.json: HTTP {$response->status()}");
        }
        return $response->json() ?? [];
    }

    private function processXmltvUrl(string $url, array $channelIds, array &$stats): void
    {
        $response = Http::timeout(90)->retry(2, 500)->get($url);
        if (!$response->successful()) {
            throw new \RuntimeException("HTTP {$response->status()}");
        }

        libxml_use_internal_errors(true);
        $xml = simplexml_load_string($response->body());
        libxml_clear_errors();

        if ($xml === false) {
            throw new \RuntimeException('Invalid XMLTV XML');
        }

        $maxTime    = now()->addDays(self::MAX_DAYS);
        $channelSet = array_flip($channelIds);
        $batch      = [];

        foreach ($xml->programme as $programme) {
            $channelId = (string) ($programme['channel'] ?? '');
            if (!isset($channelSet[$channelId])) continue;

            $start = $this->parseXmltvTime((string) ($programme['start'] ?? ''));
            $stop  = $this->parseXmltvTime((string) ($programme['stop'] ?? ''));

            if (!$start || !$stop)                  continue;
            if ($stop->isPast())                    continue;
            if ($start->gt($maxTime))               continue;
            if ($stop->lte($start))                 continue;

            $title = trim((string) ($programme->title ?? ''));
            if ($title === '') continue;

            $batch[] = [
                'id'          => Str::uuid()->toString(),
                'channel_id'  => $channelId,
                'title'       => $title,
                'description' => trim((string) ($programme->desc ?? '')) ?: null,
                'start_time'  => $start->toDateTimeString(),
                'end_time'    => $stop->toDateTimeString(),
                'category'    => trim((string) ($programme->category ?? '')) ?: null,
                'poster_url'  => isset($programme->icon)
                    ? (trim((string) ($programme->icon['src'] ?? '')) ?: null)
                    : null,
            ];

            if (count($batch) >= self::BATCH_SIZE) {
                $this->flushBatch($batch, $stats);
                $batch = [];
            }
        }

        if (!empty($batch)) {
            $this->flushBatch($batch, $stats);
        }
    }

    private function flushBatch(array $batch, array &$stats): void
    {
        // Count existing rows to split inserted vs updated in stats
        $existing = EpgProgram::where(function ($q) use ($batch) {
            foreach ($batch as $row) {
                $q->orWhere(fn($s) => $s
                    ->where('channel_id', $row['channel_id'])
                    ->where('start_time', $row['start_time']));
            }
        })->count();

        EpgProgram::upsert(
            $batch,
            ['channel_id', 'start_time'],
            ['title', 'description', 'end_time', 'category', 'poster_url']
        );

        $stats['updated'] += $existing;
        $stats['inserted'] += max(0, count($batch) - $existing);
    }

    /**
     * Parse XMLTV datetime: "YYYYMMDDHHmmss +HHMM" → Carbon UTC
     */
    private function parseXmltvTime(string $raw): ?Carbon
    {
        $raw = trim($raw);
        if ($raw === '') return null;

        try {
            // "20240101120000 +0100"
            if (preg_match('/^(\d{14})\s*([+-])(\d{2})(\d{2})$/', $raw, $m)) {
                $dt          = Carbon::createFromFormat('YmdHis', $m[1], 'UTC');
                $offsetMins  = ((int) $m[3]) * 60 + (int) $m[4];
                return $m[2] === '+' ? $dt->subMinutes($offsetMins) : $dt->addMinutes($offsetMins);
            }

            // "20240101120000" (bare — assume UTC)
            if (preg_match('/^(\d{14})$/', $raw)) {
                return Carbon::createFromFormat('YmdHis', $raw, 'UTC');
            }

            // Fallback to Carbon generic parser
            return Carbon::parse($raw)->utc();
        } catch (\Exception $e) {
            return null;
        }
    }
}

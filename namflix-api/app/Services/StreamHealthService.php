<?php

namespace App\Services;

use App\Models\Stream;
use App\Models\SyncLog;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class StreamHealthService
{
    private const BATCH_SIZE = 50;
    private const TIMEOUT = 8;

    public function checkAll(): void
    {
        $log = SyncLog::create([
            'type' => 'health_check',
            'status' => 'running',
            'started_at' => now(),
            'errors' => [],
        ]);

        $errors = [];

        try {
            Stream::orderByRaw('CASE WHEN last_checked_at IS NULL THEN 0 ELSE 1 END ASC, last_checked_at ASC')
                ->chunk(self::BATCH_SIZE, function ($streams) use (&$errors) {
                    $updates = [];

                    foreach ($streams as $stream) {
                        try {
                            $result = $this->checkStream($stream);
                            $updates[] = array_merge(['id' => $stream->id], $result);
                        } catch (\Exception $e) {
                            $errors[] = "Stream {$stream->id}: " . $e->getMessage();
                        }
                    }

                    foreach ($updates as $update) {
                        Stream::where('id', $update['id'])->update([
                            'is_live' => $update['is_live'],
                            'is_geo_blocked' => $update['is_geo_blocked'],
                            'failure_reason' => $update['failure_reason'],
                            'last_checked_at' => now(),
                        ]);
                    }
                });

            $log->update([
                'status' => 'success',
                'completed_at' => now(),
                'errors' => $errors,
            ]);
        } catch (\Exception $e) {
            Log::error('Stream health check failed: ' . $e->getMessage());
            $log->update([
                'status' => 'failed',
                'completed_at' => now(),
                'errors' => array_merge($errors, [$e->getMessage()]),
            ]);
        }
    }

    public function checkStream(Stream $stream): array
    {
        $url = $stream->url;
        $path = strtolower(parse_url($url, PHP_URL_PATH) ?? '');
        $isM3u8 = str_ends_with($path, '.m3u8');

        try {
            $builder = Http::timeout(self::TIMEOUT)->withoutVerifying();

            if ($stream->user_agent) {
                $builder = $builder->withHeaders(['User-Agent' => $stream->user_agent]);
            }

            if ($stream->referrer) {
                $builder = $builder->withHeaders(['Referer' => $stream->referrer]);
            }

            $response = $isM3u8 ? $builder->get($url) : $builder->head($url);
            $status = $response->status();

            if ($status === 403) {
                $isGeoBlocked = str_contains(strtolower($stream->label ?? ''), 'geo');
                return [
                    'is_live' => false,
                    'is_geo_blocked' => $isGeoBlocked,
                    'failure_reason' => $isGeoBlocked ? 'geo_blocked' : 'http_403',
                ];
            }

            if ($status === 404) {
                return ['is_live' => false, 'is_geo_blocked' => false, 'failure_reason' => 'http_404'];
            }

            if (!in_array($status, [200, 206])) {
                return ['is_live' => false, 'is_geo_blocked' => false, 'failure_reason' => "http_{$status}"];
            }

            if ($isM3u8 && !str_contains($response->body(), '#EXTM3U')) {
                return ['is_live' => false, 'is_geo_blocked' => false, 'failure_reason' => 'invalid_manifest'];
            }

            return ['is_live' => true, 'is_geo_blocked' => false, 'failure_reason' => null];

        } catch (\Illuminate\Http\Client\ConnectionException $e) {
            return ['is_live' => false, 'is_geo_blocked' => false, 'failure_reason' => 'timeout'];
        } catch (\Exception $e) {
            return ['is_live' => false, 'is_geo_blocked' => false, 'failure_reason' => 'network_error'];
        }
    }
}

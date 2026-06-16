<?php

namespace App\Services;

use App\Models\Category;
use App\Models\Channel;
use App\Models\Country;
use App\Models\Language;
use App\Models\Logo;
use App\Models\Region;
use App\Models\Stream;
use App\Models\SyncLog;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class IptvSyncService
{
    private const BASE_URL = 'https://iptv-org.github.io/api/';

    private array $errors = [];
    private int $channelsAdded = 0;
    private int $channelsUpdated = 0;
    private int $streamsSynced = 0;

    public function sync(): void
    {
        $log = SyncLog::create([
            'type' => 'iptv_sync',
            'status' => 'running',
            'started_at' => now(),
            'errors' => [],
        ]);

        try {
            $this->fetchAndProcess();

            $log->update([
                'status' => 'success',
                'completed_at' => now(),
                'channels_added' => $this->channelsAdded,
                'channels_updated' => $this->channelsUpdated,
                'streams_synced' => $this->streamsSynced,
                'errors' => $this->errors,
            ]);
        } catch (\Exception $e) {
            Log::error('IPTV sync failed: ' . $e->getMessage());
            $log->update([
                'status' => 'failed',
                'completed_at' => now(),
                'errors' => array_merge($this->errors, [$e->getMessage()]),
            ]);
        }
    }

    private function fetchAndProcess(): void
    {
        $endpoints = ['channels', 'streams', 'categories', 'countries', 'languages', 'logos', 'blocklist', 'regions'];
        $data = [];

        foreach ($endpoints as $key) {
            try {
                $response = Http::timeout(60)
                    ->retry(3, 1000)
                    ->get(self::BASE_URL . $key . '.json');

                $data[$key] = $response->successful() ? ($response->json() ?? []) : [];
            } catch (\Exception $e) {
                $this->errors[] = "Failed to fetch {$key}: " . $e->getMessage();
                $data[$key] = [];
            }
        }

        $blockedIds = collect($data['blocklist'])->pluck('channel')->filter()->flip()->toArray();

        $this->processCategories($data['categories']);
        $this->processCountries($data['countries']);
        $this->processLanguages($data['languages']);
        $this->processRegions($data['regions']);
        $this->processChannels($data['channels'], $blockedIds);
        $this->processStreams($data['streams'], $blockedIds);
        $this->processLogos($data['logos']);
    }

    private function processChannels(array $channels, array $blockedIds): void
    {
        foreach ($channels as $ch) {
            if (empty($ch['id'])) continue;
            if ($ch['is_nsfw'] ?? false) continue;

            $exists = Channel::where('id', $ch['id'])->exists();

            Channel::updateOrCreate(
                ['id' => $ch['id']],
                [
                    'name' => $ch['name'] ?? 'Unknown',
                    'alt_names' => !empty($ch['alt_names']) ? $ch['alt_names'] : null,
                    'network' => $ch['network'] ?? null,
                    'country_code' => !empty($ch['country']) ? strtoupper($ch['country']) : null,
                    'categories' => !empty($ch['categories']) ? $ch['categories'] : null,
                    'is_nsfw' => false,
                    'is_hidden' => array_key_exists($ch['id'], $blockedIds),
                    'launched' => $ch['launched'] ?? null,
                    'website' => $ch['website'] ?? null,
                    'synced_at' => now(),
                ]
            );

            $exists ? $this->channelsUpdated++ : $this->channelsAdded++;
        }
    }

    private function processStreams(array $streams, array $blockedIds): void
    {
        $validChannelIds = Channel::pluck('id')->flip()->toArray();

        foreach ($streams as $stream) {
            if (empty($stream['channel']) || empty($stream['url'])) continue;
            if (!array_key_exists($stream['channel'], $validChannelIds)) continue;
            if (array_key_exists($stream['channel'], $blockedIds)) continue;

            try {
                $existing = Stream::where('channel_id', $stream['channel'])
                    ->where('url', $stream['url'])
                    ->first();

                $attributes = [
                    'channel_id' => $stream['channel'],
                    'feed' => $stream['feed'] ?? null,
                    'title' => $stream['title'] ?? null,
                    'referrer' => $stream['referrer'] ?? null,
                    'user_agent' => $stream['user_agent'] ?? null,
                    'quality' => $stream['quality'] ?? null,
                    'label' => $stream['label'] ?? null,
                    'is_geo_blocked' => str_contains(strtolower($stream['label'] ?? ''), 'geo'),
                ];

                if ($existing) {
                    $existing->update($attributes);
                } else {
                    Stream::create(array_merge($attributes, ['url' => $stream['url']]));
                }

                $this->streamsSynced++;
            } catch (\Exception $e) {
                $this->errors[] = "Stream error for {$stream['channel']}: " . $e->getMessage();
            }
        }
    }

    private function processCategories(array $categories): void
    {
        foreach ($categories as $cat) {
            if (empty($cat['id'])) continue;
            Category::updateOrCreate(
                ['id' => $cat['id']],
                ['name' => $cat['name'] ?? $cat['id']]
            );
        }
    }

    private function processCountries(array $countries): void
    {
        foreach ($countries as $country) {
            if (empty($country['code'])) continue;
            Country::updateOrCreate(
                ['code' => strtoupper($country['code'])],
                [
                    'name' => $country['name'] ?? $country['code'],
                    'languages' => $country['languages'] ?? null,
                    'flag' => $country['flag'] ?? null,
                    'region_code' => $country['region'] ?? null,
                ]
            );
        }
    }

    private function processLanguages(array $languages): void
    {
        foreach ($languages as $lang) {
            if (empty($lang['code'])) continue;
            Language::updateOrCreate(
                ['code' => $lang['code']],
                ['name' => $lang['name'] ?? $lang['code']]
            );
        }
    }

    private function processLogos(array $logos): void
    {
        $validChannelIds = Channel::pluck('id')->flip()->toArray();

        foreach ($logos as $logo) {
            if (empty($logo['channel']) || empty($logo['url'])) continue;
            if (!array_key_exists($logo['channel'], $validChannelIds)) continue;

            try {
                $existing = Logo::where('channel_id', $logo['channel'])
                    ->where('url', $logo['url'])
                    ->first();

                $attributes = [
                    'feed' => $logo['feed'] ?? null,
                    'format' => $logo['format'] ?? null,
                    'width' => $logo['width'] ?? null,
                    'height' => $logo['height'] ?? null,
                    'tags' => $logo['tags'] ?? null,
                ];

                if ($existing) {
                    $existing->update($attributes);
                } else {
                    Logo::create(array_merge($attributes, [
                        'channel_id' => $logo['channel'],
                        'url' => $logo['url'],
                    ]));
                }
            } catch (\Exception $e) {
                $this->errors[] = "Logo error for {$logo['channel']}: " . $e->getMessage();
            }
        }
    }

    private function processRegions(array $regions): void
    {
        foreach ($regions as $region) {
            if (empty($region['code'])) continue;
            Region::updateOrCreate(
                ['code' => $region['code']],
                [
                    'name' => $region['name'] ?? $region['code'],
                    'countries' => $region['countries'] ?? null,
                ]
            );
        }
    }
}

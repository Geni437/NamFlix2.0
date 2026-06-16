'use client';

import { useEffect, useState, useCallback } from 'react';
import { useParams } from 'next/navigation';
import GlobalNav from '@/components/GlobalNav';
import ChannelCard from '@/components/ChannelCard';
import { apiFetch, buildUrl } from '@/lib/api';

export function generateStaticParams() {
  return [{ code: 'us' }];
}

const PAGE_SIZE = 48;

export default function CountryPage() {
  const { code } = useParams();
  const [channels, setChannels] = useState([]);
  const [countryName, setCountryName] = useState('');
  const [total, setTotal] = useState(0);
  const [page, setPage] = useState(1);
  const [loading, setLoading] = useState(true);
  const [loadingMore, setLoadingMore] = useState(false);
  const [hasMore, setHasMore] = useState(false);
  const [search, setSearch] = useState('');

  const load = useCallback(async (p, s, append = false) => {
    if (!code || code === 'us') return;
    if (append) setLoadingMore(true);
    else setLoading(true);

    const { data } = await apiFetch(buildUrl('/channels', {
      country: code,
      search: s,
      page: p,
      limit: PAGE_SIZE,
    }));

    const list = data?.channels || data?.data || [];
    const tot = data?.total || data?.meta?.total || list.length;

    if (append) setChannels(prev => [...prev, ...list]);
    else setChannels(list);

    setTotal(tot);
    setHasMore(list.length === PAGE_SIZE);
    if (!countryName && data?.country?.name) setCountryName(data.country.name);

    if (append) setLoadingMore(false);
    else setLoading(false);
  }, [code, countryName]);

  useEffect(() => {
    if (code && code !== 'us') {
      setPage(1);
      setChannels([]);
      load(1, '');
    }
  }, [code]);

  const handleSearch = (val) => {
    setSearch(val);
    setPage(1);
    load(1, val);
  };

  const loadMore = () => {
    const next = page + 1;
    setPage(next);
    load(next, search, true);
  };

  const displayName = countryName || code?.toUpperCase();

  if (code === 'us' && !loading) {
    return null;
  }

  return (
    <>
      <GlobalNav />
      <main className="max-w-screen-2xl mx-auto px-4 sm:px-6 py-8 pb-16">
        {/* Header */}
        <div className="mb-8">
          <div className="flex items-center gap-4 mb-3">
            <h1 className="text-3xl font-bold text-white">{displayName}</h1>
          </div>
          <p className="text-text-secondary">
            {loading ? '…' : `${total.toLocaleString()} channels`}
          </p>
        </div>

        {/* Search */}
        <div className="relative max-w-md mb-6">
          <input
            type="text"
            value={search}
            onChange={e => handleSearch(e.target.value)}
            placeholder={`Search ${displayName} channels…`}
            className="input w-full pl-9"
            aria-label={`Search ${displayName} channels`}
          />
          <svg className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-text-muted" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" d="m21 21-5.197-5.197m0 0A7.5 7.5 0 1 0 5.196 5.196a7.5 7.5 0 0 0 10.607 10.607Z" />
          </svg>
        </div>

        {/* Grid */}
        {loading ? (
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-4">
            {Array.from({ length: 18 }, (_, i) => (
              <div key={i} className="rounded-lg overflow-hidden border border-border">
                <div className="skeleton aspect-video" />
                <div className="p-3 bg-surface space-y-2">
                  <div className="skeleton h-3 w-4/5 rounded" />
                  <div className="skeleton h-3 w-1/2 rounded" />
                </div>
              </div>
            ))}
          </div>
        ) : channels.length === 0 ? (
          <div className="text-center py-20">
            <div className="text-5xl mb-5">📡</div>
            <p className="text-white text-lg font-semibold mb-2">No channels found</p>
            <p className="text-text-secondary">No channels available for this country.</p>
          </div>
        ) : (
          <>
            <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-4">
              {channels.map(channel => (
                <ChannelCard key={channel.id} channel={channel} />
              ))}
            </div>

            {hasMore && (
              <div className="flex justify-center mt-10">
                <button
                  onClick={loadMore}
                  disabled={loadingMore}
                  className="btn-secondary px-8"
                >
                  {loadingMore ? <span className="spinner w-4 h-4" /> : 'Load More'}
                </button>
              </div>
            )}
          </>
        )}
      </main>
    </>
  );
}

'use client';

import { useCallback, useEffect, useRef, useState } from 'react';
import GlobalNav from '@/components/GlobalNav';
import ChannelCard from '@/components/ChannelCard';
import FilterPanel from '@/components/FilterPanel';
import { apiFetch, buildUrl } from '@/lib/api';

const DEFAULT_FILTERS = {
  search: '',
  country: '',
  language: '',
  categories: [],
  live_only: false,
  quality: '',
  sort: 'name_asc',
  page: 1,
};

const PAGE_SIZE = 48;

function buildApiUrl(filters) {
  return buildUrl('/channels', {
    search: filters.search,
    country: filters.country,
    language: filters.language,
    categories: filters.categories?.join(','),
    live_only: filters.live_only ? 'true' : '',
    quality: filters.quality,
    sort: filters.sort,
    page: filters.page,
    limit: PAGE_SIZE,
  });
}

export default function LivePage() {
  const [filters, setFilters] = useState(DEFAULT_FILTERS);
  const [channels, setChannels] = useState([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(true);
  const [loadingMore, setLoadingMore] = useState(false);
  const [hasMore, setHasMore] = useState(false);
  const sentinelRef = useRef(null);

  const fetch = useCallback(async (f, append = false) => {
    if (append) setLoadingMore(true);
    else setLoading(true);

    const { data } = await apiFetch(buildApiUrl(f));
    const list = data?.channels || data?.data || [];
    const tot = data?.total || data?.meta?.total || list.length;

    if (append) {
      setChannels(prev => [...prev, ...list]);
    } else {
      setChannels(list);
    }
    setTotal(tot);
    setHasMore(list.length === PAGE_SIZE);

    if (append) setLoadingMore(false);
    else setLoading(false);
  }, []);

  useEffect(() => { fetch(filters); }, []);

  const handleFilterChange = (patch) => {
    const next = { ...filters, ...patch };
    setFilters(next);
    fetch(next);
  };

  // Infinite scroll
  useEffect(() => {
    const sentinel = sentinelRef.current;
    if (!sentinel) return;
    const observer = new IntersectionObserver((entries) => {
      if (entries[0].isIntersecting && hasMore && !loadingMore) {
        const next = { ...filters, page: filters.page + 1 };
        setFilters(next);
        fetch(next, true);
      }
    }, { rootMargin: '200px' });
    observer.observe(sentinel);
    return () => observer.disconnect();
  }, [hasMore, loadingMore, filters, fetch]);

  return (
    <>
      <GlobalNav />
      <main className="max-w-screen-2xl mx-auto px-4 sm:px-6 py-6 pb-16">
        <div className="flex items-center justify-between mb-6">
          <h1 className="text-2xl font-bold text-white">Live TV</h1>
          <p className="text-text-secondary text-sm">
            {loading ? '…' : `Showing ${channels.length} of ${total.toLocaleString()} channels`}
          </p>
        </div>

        <div className="flex gap-6 items-start">
          {/* Sidebar */}
          <FilterPanel filters={filters} onChange={handleFilterChange} />

          {/* Main */}
          <div className="flex-1 min-w-0">
            {/* Mobile filter row */}
            <div className="lg:hidden flex items-center gap-3 mb-4">
              <FilterPanel filters={filters} onChange={handleFilterChange} />
            </div>

            {loading ? (
              <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 xl:grid-cols-5 gap-4">
                {Array.from({ length: 20 }, (_, i) => (
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
                <p className="text-white text-lg font-semibold mb-2">No channels match your filters</p>
                <p className="text-text-secondary">Try adjusting or resetting your filters.</p>
              </div>
            ) : (
              <>
                <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 xl:grid-cols-5 gap-4">
                  {channels.map(channel => (
                    <ChannelCard key={channel.id} channel={channel} />
                  ))}
                </div>

                {/* Infinite scroll sentinel */}
                <div ref={sentinelRef} className="h-4 mt-4" />

                {loadingMore && (
                  <div className="flex justify-center py-8">
                    <div className="spinner w-8 h-8" style={{ borderWidth: 3 }} />
                  </div>
                )}

                {!hasMore && channels.length > 0 && (
                  <p className="text-center text-text-muted text-sm py-8">
                    All {channels.length} channels loaded
                  </p>
                )}
              </>
            )}
          </div>
        </div>
      </main>
    </>
  );
}

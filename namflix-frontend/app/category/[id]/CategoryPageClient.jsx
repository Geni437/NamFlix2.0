'use client';

import { useEffect, useState, useCallback } from 'react';
import { useParams } from 'next/navigation';
import GlobalNav from '@/components/GlobalNav';
import ChannelCard from '@/components/ChannelCard';
import { apiFetch, buildUrl } from '@/lib/api';

const PAGE_SIZE = 48;

const CATEGORY_LABELS = {
  news: 'News',
  sports: 'Sports',
  entertainment: 'Entertainment',
  music: 'Music',
  movies: 'Movies & Cinema',
  kids: 'Kids',
  documentary: 'Documentary',
  religious: 'Religious',
  cooking: 'Cooking',
  travel: 'Travel',
  science: 'Science',
  education: 'Education',
  auto: 'Auto',
  shop: 'Shopping',
  general: 'General',
};

export default function CategoryPageClient() {
  const { id } = useParams();
  const [channels, setChannels] = useState([]);
  const [total, setTotal] = useState(0);
  const [page, setPage] = useState(1);
  const [loading, setLoading] = useState(true);
  const [loadingMore, setLoadingMore] = useState(false);
  const [hasMore, setHasMore] = useState(false);
  const [country, setCountry] = useState('');
  const [countries, setCountries] = useState([]);

  const load = useCallback(async (p, c, append = false) => {
    if (!id || id === 'placeholder') return;
    if (append) setLoadingMore(true);
    else setLoading(true);

    const { data } = await apiFetch(buildUrl('/channels', {
      category: id,
      country: c,
      page: p,
      limit: PAGE_SIZE,
    }));

    const list = data?.channels || data?.data || [];
    const tot = data?.total || data?.meta?.total || list.length;

    if (append) setChannels(prev => [...prev, ...list]);
    else setChannels(list);

    setTotal(tot);
    setHasMore(list.length === PAGE_SIZE);

    if (append) setLoadingMore(false);
    else setLoading(false);
  }, [id]);

  useEffect(() => {
    if (id && id !== 'placeholder') {
      setPage(1);
      setChannels([]);
      load(1, '');
      apiFetch('/countries').then(({ data }) => setCountries(data || []));
    }
  }, [id]);

  const handleCountry = (c) => {
    setCountry(c);
    setPage(1);
    load(1, c);
  };

  const loadMore = () => {
    const next = page + 1;
    setPage(next);
    load(next, country, true);
  };

  const label = CATEGORY_LABELS[id] || (id ? id.charAt(0).toUpperCase() + id.slice(1) : '');

  if (id === 'placeholder' && !loading) return null;

  return (
    <>
      <GlobalNav />
      <main className="max-w-screen-2xl mx-auto px-4 sm:px-6 py-8 pb-16">
        <div className="flex items-start justify-between mb-8 gap-4 flex-wrap">
          <div>
            <h1 className="text-3xl font-bold text-white mb-1">{label}</h1>
            <p className="text-text-secondary">
              {loading ? '…' : `${total.toLocaleString()} channels`}
            </p>
          </div>

          {countries.length > 0 && (
            <select
              value={country}
              onChange={e => handleCountry(e.target.value)}
              className="input"
              aria-label="Filter by country"
              style={{ minWidth: 180 }}
            >
              <option value="">All Countries</option>
              {countries.map(c => (
                <option key={c.code} value={c.code}>{c.name}</option>
              ))}
            </select>
          )}
        </div>

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
            <div className="text-5xl mb-5">📺</div>
            <p className="text-white text-lg font-semibold mb-2">No channels found</p>
            <p className="text-text-secondary">No {label.toLowerCase()} channels available{country ? ' for this country' : ''}.</p>
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

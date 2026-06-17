'use client';

import { useEffect, useState } from 'react';
import Link from 'next/link';
import GlobalNav from '@/components/GlobalNav';
import HorizontalChannelRow from '@/components/HorizontalChannelRow';
import LiveBadge from '@/components/LiveBadge';
import { apiFetch, buildUrl } from '@/lib/api';
import { useAuth } from '@/context/AuthContext';

const CATEGORY_ROWS = [
  { id: 'news', label: 'News' },
  { id: 'sports', label: 'Sports' },
  { id: 'entertainment', label: 'Entertainment' },
  { id: 'music', label: 'Music' },
  { id: 'movies', label: 'Movies' },
];

function HeroSkeleton() {
  return (
    <div className="relative w-full h-[56vw] max-h-[560px] min-h-[280px] bg-surface animate-pulse flex items-center justify-center">
      <div className="w-28 h-28 rounded-xl bg-surface-2" />
    </div>
  );
}

function Hero({ channel }) {
  const [imgError, setImgError] = useState(false);

  if (!channel) return null;

  return (
    <div className="relative w-full h-[56vw] max-h-[560px] min-h-[280px] overflow-hidden flex items-center justify-center">
      {/* Background */}
      <div className="absolute inset-0 bg-gradient-to-b from-bg/20 via-bg/50 to-bg" />
      <div
        className="absolute inset-0"
        style={{
          background: 'radial-gradient(ellipse 80% 60% at 50% 40%, rgba(229,9,20,0.07) 0%, transparent 70%)',
        }}
      />

      {/* Channel logo — large, centered */}
      <div className="relative z-10 flex flex-col items-center text-center px-8">
        {channel.logo_url && !imgError ? (
          <img
            src={channel.logo_url}
            alt={channel.name}
            className="w-28 h-28 md:w-36 md:h-36 object-contain mb-6 drop-shadow-2xl"
            onError={() => setImgError(true)}
          />
        ) : (
          <div className="w-28 h-28 rounded-2xl bg-accent-red/20 flex items-center justify-center mb-6">
            <span className="text-white font-bold text-4xl">
              {channel.name?.[0] || 'N'}
            </span>
          </div>
        )}

        <div className="flex items-center gap-3 mb-3">
          <LiveBadge size="lg" />
          {channel.country && (
            <span className="text-text-secondary text-sm font-medium uppercase tracking-wider">
              {channel.country}
            </span>
          )}
        </div>

        <h1 className="text-white text-3xl md:text-5xl font-bold mb-6 leading-tight max-w-xl">
          {channel.name}
        </h1>

        <div className="flex items-center gap-3">
          <Link
            href={`/channel/${channel.id}/`}
            className="btn-primary text-base px-6 py-3"
          >
            <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
              <path fillRule="evenodd" d="M4.5 5.653c0-1.427 1.529-2.33 2.779-1.643l11.54 6.347c1.295.712 1.295 2.573 0 3.286L7.28 19.99c-1.25.687-2.779-.217-2.779-1.643V5.653Z" clipRule="evenodd" />
            </svg>
            Watch Now
          </Link>
          <Link
            href="/live/"
            className="btn-secondary text-base px-6 py-3"
          >
            Browse All
          </Link>
        </div>
      </div>
    </div>
  );
}

export default function HomePage() {
  const { user, loading: authLoading } = useAuth();
  const [featured, setFeatured] = useState(null);
  const [heroLoading, setHeroLoading] = useState(true);
  const [userCountry, setUserCountry] = useState(null);

  useEffect(() => {
    apiFetch(buildUrl('/trending', { limit: 20 })).then(({ data }) => {
      const list = data?.channels || data?.data || [];
      if (list.length > 0) setFeatured(list[0]);
      setHeroLoading(false);
    });
  }, []);

  useEffect(() => {
    if (!authLoading && user) {
      apiFetch('/me').then(({ data }) => {
        if (data?.preferred_country) setUserCountry(data.preferred_country);
      });
    }
  }, [user, authLoading]);

  return (
    <>
      <GlobalNav />

      <main className="-mt-16">
        {/* Hero */}
        {heroLoading ? <HeroSkeleton /> : <Hero channel={featured} />}

        {/* Content rows */}
        <div className="max-w-screen-2xl mx-auto px-4 sm:px-6 pb-16 space-y-12 mt-10">

          <HorizontalChannelRow
            title="🔴 Live Now"
            fetchUrl={buildUrl('/channels', { live_only: 'true', limit: 20 })}
            seeAllLink="/live/"
          />

          {CATEGORY_ROWS.map(({ id, label }) => (
            <HorizontalChannelRow
              key={id}
              title={label}
              fetchUrl={buildUrl('/channels', { category: id, limit: 20 })}
              seeAllLink={`/category/${id}/`}
            />
          ))}

          {userCountry && (
            <HorizontalChannelRow
              title={`Channels from ${userCountry.toUpperCase()}`}
              fetchUrl={buildUrl('/channels', { country: userCountry, limit: 20 })}
              seeAllLink={`/country/${userCountry}/`}
            />
          )}
        </div>
      </main>
    </>
  );
}

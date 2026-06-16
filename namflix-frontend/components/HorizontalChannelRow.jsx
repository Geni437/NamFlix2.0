'use client';

import { useEffect, useRef, useState } from 'react';
import Link from 'next/link';
import { apiFetch } from '@/lib/api';
import ChannelCard from './ChannelCard';

function SkeletonCard() {
  return (
    <div className="flex-shrink-0 rounded-lg overflow-hidden border border-border" style={{ minWidth: 180, width: 180 }}>
      <div className="skeleton aspect-video w-full" />
      <div className="p-3 bg-surface space-y-2">
        <div className="skeleton h-3.5 w-4/5 rounded" />
        <div className="skeleton h-3 w-1/2 rounded" />
      </div>
    </div>
  );
}

export default function HorizontalChannelRow({ title, fetchUrl, seeAllLink, excludeId }) {
  const [channels, setChannels] = useState([]);
  const [loading, setLoading] = useState(true);
  const scrollRef = useRef(null);
  const [canLeft, setCanLeft] = useState(false);
  const [canRight, setCanRight] = useState(true);

  useEffect(() => {
    if (!fetchUrl) return;
    setLoading(true);
    apiFetch(fetchUrl).then(({ data }) => {
      let list = data?.channels || data?.data || data || [];
      if (excludeId) list = list.filter(c => c.id !== excludeId);
      setChannels(list.slice(0, 20));
      setLoading(false);
    });
  }, [fetchUrl, excludeId]);

  const updateArrows = () => {
    const el = scrollRef.current;
    if (!el) return;
    setCanLeft(el.scrollLeft > 10);
    setCanRight(el.scrollLeft < el.scrollWidth - el.clientWidth - 10);
  };

  const scroll = (dir) => {
    const el = scrollRef.current;
    if (!el) return;
    el.scrollBy({ left: dir * 600, behavior: 'smooth' });
  };

  if (!loading && channels.length === 0) return null;

  return (
    <section className="relative" aria-label={title}>
      {/* Row header */}
      <div className="flex items-center justify-between mb-4 px-1">
        <h2 className="text-white text-lg font-bold">{title}</h2>
        {seeAllLink && (
          <Link
            href={seeAllLink}
            className="text-text-secondary text-sm hover:text-accent-red transition-colors flex items-center gap-1 focus-visible:outline-2"
          >
            See All
            <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" d="m8.25 4.5 7.5 7.5-7.5 7.5" />
            </svg>
          </Link>
        )}
      </div>

      {/* Scroll container */}
      <div className="relative group">
        {/* Left arrow */}
        {canLeft && (
          <button
            onClick={() => scroll(-1)}
            className="hidden md:flex absolute left-0 top-1/2 -translate-y-1/2 -translate-x-1/2 z-10 w-10 h-10 items-center justify-center rounded-full bg-surface border border-border text-white hover:bg-border shadow-lg opacity-0 group-hover:opacity-100 transition-opacity focus-visible:opacity-100"
            aria-label="Scroll left"
            tabIndex={0}
          >
            <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" d="m15.75 19.5-7.5-7.5 7.5-7.5" />
            </svg>
          </button>
        )}

        <div
          ref={scrollRef}
          className="flex gap-4 overflow-x-auto scrollbar-hide pb-2"
          onScroll={updateArrows}
          style={{ scrollSnapType: 'x mandatory' }}
          tabIndex={-1}
        >
          {loading
            ? Array.from({ length: 7 }, (_, i) => <SkeletonCard key={i} />)
            : channels.map(channel => (
              <div key={channel.id} className="flex-shrink-0" style={{ width: 200, scrollSnapAlign: 'start' }}>
                <ChannelCard channel={channel} />
              </div>
            ))
          }
        </div>

        {/* Right arrow */}
        {canRight && (
          <button
            onClick={() => scroll(1)}
            className="hidden md:flex absolute right-0 top-1/2 -translate-y-1/2 translate-x-1/2 z-10 w-10 h-10 items-center justify-center rounded-full bg-surface border border-border text-white hover:bg-border shadow-lg opacity-0 group-hover:opacity-100 transition-opacity focus-visible:opacity-100"
            aria-label="Scroll right"
            tabIndex={0}
          >
            <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" d="m8.25 4.5 7.5 7.5-7.5 7.5" />
            </svg>
          </button>
        )}
      </div>
    </section>
  );
}

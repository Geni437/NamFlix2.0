'use client';

import Link from 'next/link';
import { useState } from 'react';
import LiveBadge from './LiveBadge';

function ChannelInitials({ name }) {
  const words = (name || '').split(' ').filter(Boolean);
  const initials = words.length >= 2
    ? words[0][0] + words[1][0]
    : (words[0] || '?').slice(0, 2);

  const colors = ['#E50914', '#00C2FF', '#7C3AED', '#059669', '#D97706', '#0891B2'];
  const colorIndex = name ? name.charCodeAt(0) % colors.length : 0;

  return (
    <div
      className="w-full h-full flex items-center justify-center text-white font-bold text-lg"
      style={{ backgroundColor: colors[colorIndex] }}
    >
      {initials.toUpperCase()}
    </div>
  );
}

export default function ChannelCard({ channel }) {
  const [imgError, setImgError] = useState(false);

  const isLive = channel.streams?.some(s => s.is_live) || channel.is_live;
  const quality = channel.streams?.[0]?.quality;

  return (
    <Link
      href={`/channel/${channel.id}/`}
      className="group flex flex-col bg-surface rounded-lg border border-border overflow-hidden hover:border-accent-red hover:scale-[1.03] transition-all duration-200 focus-visible:outline-2 focus-visible:outline-accent-red"
      tabIndex={0}
      style={{ minWidth: '180px' }}
      aria-label={`${channel.name} – ${channel.country || ''}`}
    >
      {/* Logo */}
      <div className="relative aspect-video bg-surface-2 flex items-center justify-center overflow-hidden">
        {channel.logo_url && !imgError ? (
          <img
            src={channel.logo_url}
            alt={channel.name}
            className="w-16 h-16 object-contain"
            loading="lazy"
            onError={() => setImgError(true)}
          />
        ) : (
          <div className="w-16 h-16 rounded overflow-hidden">
            <ChannelInitials name={channel.name} />
          </div>
        )}

        {isLive && (
          <div className="absolute top-2 left-2">
            <LiveBadge />
          </div>
        )}

        {quality && (
          <div className="absolute top-2 right-2">
            <span className="badge-quality">{quality}</span>
          </div>
        )}
      </div>

      {/* Info */}
      <div className="p-3 flex-1 flex flex-col gap-1">
        <p className="text-white text-sm font-semibold line-clamp-1 group-hover:text-accent-red transition-colors">
          {channel.name}
        </p>
        <div className="flex items-center gap-1.5">
          {channel.country && (
            <span className="text-text-muted text-xs uppercase tracking-wide">
              {channel.country}
            </span>
          )}
        </div>
      </div>
    </Link>
  );
}

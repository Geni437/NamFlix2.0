'use client';

import { useEffect, useState } from 'react';
import { useParams } from 'next/navigation';
import Link from 'next/link';
import GlobalNav from '@/components/GlobalNav';
import StreamPlayer from '@/components/StreamPlayer';
import EPGBar from '@/components/EPGBar';
import HorizontalChannelRow from '@/components/HorizontalChannelRow';
import { apiFetch, buildUrl } from '@/lib/api';
import { useAuth } from '@/context/AuthContext';

function FavoriteButton({ channelId }) {
  const { user, openAuthModal } = useAuth();
  const [isFav, setIsFav] = useState(false);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (!user || !channelId || channelId === 'placeholder') return;
    apiFetch('/me/favorites').then(({ data }) => {
      const ids = (data?.data || []).map(c => c.id);
      setIsFav(ids.includes(channelId));
    });
  }, [user, channelId]);

  const toggle = async () => {
    if (!user) { openAuthModal(); return; }
    setLoading(true);
    if (isFav) {
      await apiFetch(`/me/favorites/${channelId}`, { method: 'DELETE' });
      setIsFav(false);
    } else {
      await apiFetch(`/me/favorites/${channelId}`, { method: 'POST' });
      setIsFav(true);
    }
    setLoading(false);
  };

  return (
    <button
      onClick={toggle}
      disabled={loading}
      className={`flex items-center gap-2 px-4 py-2 rounded-lg border transition-all text-sm font-medium focus-visible:outline-2 ${
        isFav
          ? 'bg-accent-red/15 border-accent-red text-accent-red hover:bg-accent-red/25'
          : 'bg-surface-2 border-border text-text-secondary hover:text-white hover:border-white'
      }`}
      style={{ minHeight: 44 }}
      aria-pressed={isFav}
      aria-label={isFav ? 'Remove from favorites' : 'Add to favorites'}
    >
      <svg className="w-4 h-4" fill={isFav ? 'currentColor' : 'none'} viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
        <path strokeLinecap="round" strokeLinejoin="round" d="M21 8.25c0-2.485-2.099-4.5-4.688-4.5-1.935 0-3.597 1.126-4.312 2.733-.715-1.607-2.377-2.733-4.313-2.733C5.1 3.75 3 5.765 3 8.25c0 7.22 9 12 9 12s9-4.78 9-12Z" />
      </svg>
      {isFav ? 'Saved' : 'Add to Favorites'}
    </button>
  );
}

function ReportModal({ streamId, onClose, onSubmit }) {
  const [reason, setReason] = useState('stream_not_working');
  const [loading, setLoading] = useState(false);
  const reasons = [
    { value: 'stream_not_working', label: 'Stream not working' },
    { value: 'poor_quality', label: 'Poor video quality' },
    { value: 'wrong_content', label: 'Wrong content' },
    { value: 'buffering', label: 'Constant buffering' },
    { value: 'other', label: 'Other' },
  ];

  const submit = async () => {
    setLoading(true);
    await onSubmit(streamId, reason);
    setLoading(false);
    onClose();
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4" style={{ background: 'rgba(0,0,0,0.8)' }}>
      <div className="bg-surface border border-border rounded-xl p-6 max-w-sm w-full animate-fade-in">
        <div className="flex items-center justify-between mb-5">
          <h2 className="text-white font-bold text-lg">Report Stream</h2>
          <button onClick={onClose} className="text-text-secondary hover:text-white p-1" aria-label="Close">
            <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" d="M6 18 18 6M6 6l12 12" />
            </svg>
          </button>
        </div>
        <div className="flex flex-col gap-2 mb-5">
          {reasons.map(r => (
            <label key={r.value} className="flex items-center gap-3 cursor-pointer py-2 group" style={{ minHeight: 44 }}>
              <input
                type="radio"
                name="reason"
                value={r.value}
                checked={reason === r.value}
                onChange={() => setReason(r.value)}
                className="accent-accent-red w-4 h-4"
              />
              <span className={`text-sm ${reason === r.value ? 'text-white font-medium' : 'text-text-secondary'}`}>
                {r.label}
              </span>
            </label>
          ))}
        </div>
        <button onClick={submit} disabled={loading} className="btn-primary w-full">
          {loading ? <span className="spinner w-4 h-4" /> : 'Submit Report'}
        </button>
      </div>
    </div>
  );
}

export default function ChannelPageClient() {
  const { id } = useParams();
  const [channel, setChannel] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [reportModal, setReportModal] = useState(false);
  const [reportStreamId, setReportStreamId] = useState(null);

  useEffect(() => {
    if (!id || id === 'placeholder') return;

    apiFetch(`/channels/${id}`).then(({ data, error }) => {
      if (error) setError(error);
      else setChannel(data?.data);
      setLoading(false);
    });

    apiFetch('/me/history', {
      method: 'POST',
      body: JSON.stringify({ channel_id: id }),
    }).catch(() => {});
  }, [id]);

  const handleReport = async (streamId, reason) => {
    await apiFetch('/stream-reports', {
      method: 'POST',
      body: JSON.stringify({ stream_id: streamId, reason }),
    });
  };

  if (id === 'placeholder') {
    return (
      <>
        <GlobalNav />
        <main className="max-w-screen-xl mx-auto px-4 sm:px-6 py-8">
          <div className="skeleton aspect-video rounded-xl mb-6 max-w-4xl" />
        </main>
      </>
    );
  }

  if (loading) {
    return (
      <>
        <GlobalNav />
        <main className="max-w-screen-xl mx-auto px-4 sm:px-6 py-8">
          <div className="skeleton aspect-video rounded-xl mb-6 max-w-4xl" />
          <div className="flex items-center gap-4 mb-6">
            <div className="skeleton w-16 h-16 rounded-xl" />
            <div className="space-y-2">
              <div className="skeleton h-6 w-48 rounded" />
              <div className="skeleton h-4 w-24 rounded" />
            </div>
          </div>
        </main>
      </>
    );
  }

  if (error || !channel) {
    return (
      <>
        <GlobalNav />
        <main className="max-w-screen-xl mx-auto px-4 sm:px-6 py-20 text-center">
          <p className="text-text-secondary mb-4">Channel not found.</p>
          <Link href="/live/" className="btn-primary">Browse Channels</Link>
        </main>
      </>
    );
  }

  const streams = channel.streams || [];
  const categories = channel.categories || [];

  return (
    <>
      <GlobalNav />
      {reportModal && reportStreamId && (
        <ReportModal
          streamId={reportStreamId}
          onClose={() => setReportModal(false)}
          onSubmit={handleReport}
        />
      )}

      <main className="max-w-screen-xl mx-auto px-4 sm:px-6 py-6 pb-16">
        <div className="grid grid-cols-1 xl:grid-cols-3 gap-6">
          <div className="xl:col-span-2 space-y-5">
            <StreamPlayer
              streams={streams}
              channelName={channel.name}
              channelLogo={channel.logo_url}
              onReport={() => {
                setReportStreamId(streams[0]?.id);
                setReportModal(true);
              }}
            />

            <div className="flex items-start gap-4">
              {channel.logo_url && (
                <img
                  src={channel.logo_url}
                  alt={channel.name}
                  className="w-14 h-14 object-contain rounded-lg bg-surface-2 flex-shrink-0"
                  onError={e => e.target.style.display = 'none'}
                />
              )}
              <div className="flex-1 min-w-0">
                <h1 className="text-white text-xl font-bold line-clamp-1">{channel.name}</h1>
                <div className="flex flex-wrap items-center gap-2 mt-1.5">
                  {channel.country && (
                    <Link href={`/country/${channel.country}/`} className="text-text-secondary text-sm hover:text-accent-blue transition-colors uppercase tracking-wide">
                      {channel.country}
                    </Link>
                  )}
                  {categories.slice(0, 3).map(cat => (
                    <Link key={cat} href={`/category/${cat}/`} className="px-2 py-0.5 bg-surface-2 border border-border rounded text-xs text-text-secondary hover:text-white hover:border-border transition-colors">
                      {cat}
                    </Link>
                  ))}
                </div>
              </div>
              <div className="flex items-center gap-2 flex-shrink-0">
                <FavoriteButton channelId={channel.id} />
              </div>
            </div>

            <EPGBar channelId={channel.id} />

            <div className="flex items-center gap-3 flex-wrap">
              {streams[0] && (
                <button onClick={() => { setReportStreamId(streams[0].id); setReportModal(true); }} className="btn-ghost text-sm">
                  <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" d="M3 3v1.5M3 21v-6m0 0 2.77-.693a9 9 0 0 1 6.208.682l.108.054a9 9 0 0 0 6.086.71l3.114-.732a48.524 48.524 0 0 1-.005-10.499l-3.11.732a9 9 0 0 1-6.085-.711l-.108-.054a9 9 0 0 0-6.208-.682L3 4.5M3 15V4.5" />
                  </svg>
                  Report Stream
                </button>
              )}
              {channel.website && (
                <a href={channel.website} target="_blank" rel="noopener noreferrer" className="btn-ghost text-sm">
                  <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" d="M13.19 8.688a4.5 4.5 0 0 1 1.242 7.244l-4.5 4.5a4.5 4.5 0 0 1-6.364-6.364l1.757-1.757m13.35-.622 1.757-1.757a4.5 4.5 0 0 0-6.364-6.364l-4.5 4.5a4.5 4.5 0 0 0 1.242 7.244" />
                  </svg>
                  Official Website
                </a>
              )}
            </div>
          </div>

          <div className="space-y-4">
            <div className="bg-surface border border-border rounded-xl p-4">
              <h3 className="text-sm font-semibold text-text-secondary uppercase tracking-wide mb-3">
                Available Streams ({streams.length})
              </h3>
              <div className="space-y-2">
                {streams.slice(0, 8).map((s, i) => (
                  <div key={i} className="flex items-center justify-between py-2 border-b border-border last:border-0">
                    <div className="flex items-center gap-2">
                      <span className={`w-2 h-2 rounded-full flex-shrink-0 ${s.is_live ? 'bg-green-400' : 'bg-red-500'}`} />
                      <span className="text-text-secondary text-xs truncate max-w-[140px]">{s.quality || `Stream ${i + 1}`}</span>
                    </div>
                    {s.is_live
                      ? <span className="text-xs text-green-400 font-medium">Online</span>
                      : <span className="text-xs text-red-400">Offline</span>
                    }
                  </div>
                ))}
              </div>
            </div>
          </div>
        </div>

        {channel.country && (
          <div className="mt-12">
            <HorizontalChannelRow
              title={`More from ${channel.country.toUpperCase()}`}
              fetchUrl={buildUrl('/channels', { country: channel.country, limit: 12 })}
              seeAllLink={`/country/${channel.country}/`}
              excludeId={channel.id}
            />
          </div>
        )}
      </main>
    </>
  );
}

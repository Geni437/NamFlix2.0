'use client';

import { useEffect, useState } from 'react';
import Link from 'next/link';
import GlobalNav from '@/components/GlobalNav';
import { apiFetch } from '@/lib/api';
import { useAuth } from '@/context/AuthContext';

function formatDate(iso) {
  const d = new Date(iso);
  const today = new Date();
  const yesterday = new Date(today);
  yesterday.setDate(today.getDate() - 1);

  if (d.toDateString() === today.toDateString()) return 'Today';
  if (d.toDateString() === yesterday.toDateString()) return 'Yesterday';
  return new Intl.DateTimeFormat(undefined, { weekday: 'long', month: 'long', day: 'numeric' }).format(d);
}

function formatTime(iso) {
  return new Intl.DateTimeFormat(undefined, { hour: '2-digit', minute: '2-digit' }).format(new Date(iso));
}

function groupByDate(history) {
  const groups = {};
  for (const item of history) {
    const key = new Date(item.watched_at).toDateString();
    if (!groups[key]) groups[key] = { label: formatDate(item.watched_at), items: [] };
    groups[key].items.push(item);
  }
  return Object.values(groups);
}

export default function HistoryPage() {
  const { user, loading: authLoading, openAuthModal } = useAuth();
  const [groups, setGroups] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (authLoading) return;
    if (!user) { setLoading(false); return; }

    apiFetch('/me/history').then(({ data }) => {
      const list = data?.history || data || [];
      setGroups(groupByDate(list));
      setLoading(false);
    });
  }, [user, authLoading]);

  if (authLoading || loading) {
    return (
      <>
        <GlobalNav />
        <main className="max-w-screen-md mx-auto px-4 sm:px-6 py-8">
          <div className="space-y-3">
            {Array.from({ length: 8 }, (_, i) => (
              <div key={i} className="skeleton h-16 rounded-lg" />
            ))}
          </div>
        </main>
      </>
    );
  }

  if (!user) {
    return (
      <>
        <GlobalNav />
        <main className="max-w-screen-md mx-auto px-4 sm:px-6 py-20 flex flex-col items-center text-center">
          <div className="text-6xl mb-6">📋</div>
          <h1 className="text-white text-2xl font-bold mb-3">Watch History</h1>
          <p className="text-text-secondary mb-8 max-w-md">
            Sign in to see what you've been watching.
          </p>
          <button onClick={openAuthModal} className="btn-primary text-base px-8 py-3">
            Sign In to Continue
          </button>
        </main>
      </>
    );
  }

  return (
    <>
      <GlobalNav />
      <main className="max-w-screen-md mx-auto px-4 sm:px-6 py-8 pb-16">
        <h1 className="text-2xl font-bold text-white mb-8">Watch History</h1>

        {groups.length === 0 ? (
          <div className="text-center py-20">
            <div className="text-6xl mb-6">📺</div>
            <p className="text-white text-xl font-semibold mb-2">No history yet</p>
            <p className="text-text-secondary mb-8">Start watching and your history will appear here.</p>
            <Link href="/live/" className="btn-primary text-base px-6">Browse Live TV</Link>
          </div>
        ) : (
          <div className="space-y-8">
            {groups.map(group => (
              <section key={group.label}>
                <h2 className="text-sm font-semibold text-text-secondary uppercase tracking-wider mb-3">
                  {group.label}
                </h2>
                <div className="bg-surface border border-border rounded-xl overflow-hidden divide-y divide-border">
                  {group.items.map((item, idx) => (
                    <Link
                      key={idx}
                      href={`/channel/${item.channel_id}/`}
                      className="flex items-center gap-4 px-4 py-3 hover:bg-surface-2 transition-colors group focus-visible:outline-2"
                      style={{ minHeight: 64 }}
                    >
                      {item.logo_url && (
                        <img
                          src={item.logo_url}
                          alt={item.channel_name}
                          className="w-10 h-10 object-contain rounded bg-surface-2 flex-shrink-0"
                          loading="lazy"
                          onError={e => e.target.style.display = 'none'}
                        />
                      )}
                      <div className="flex-1 min-w-0">
                        <p className="text-white font-medium text-sm group-hover:text-accent-red transition-colors line-clamp-1">
                          {item.channel_name || item.channel_id}
                        </p>
                        {item.country && (
                          <p className="text-text-muted text-xs mt-0.5 uppercase tracking-wide">
                            {item.country}
                          </p>
                        )}
                      </div>
                      <span className="text-text-muted text-xs flex-shrink-0">
                        {formatTime(item.watched_at)}
                      </span>
                    </Link>
                  ))}
                </div>
              </section>
            ))}
          </div>
        )}
      </main>
    </>
  );
}

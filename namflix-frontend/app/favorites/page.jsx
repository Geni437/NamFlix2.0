'use client';

import { useEffect, useState } from 'react';
import GlobalNav from '@/components/GlobalNav';
import ChannelCard from '@/components/ChannelCard';
import { apiFetch } from '@/lib/api';
import { useAuth } from '@/context/AuthContext';
import Link from 'next/link';

export default function FavoritesPage() {
  const { user, loading: authLoading, openAuthModal } = useAuth();
  const [channels, setChannels] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    if (authLoading) return;
    if (!user) { setLoading(false); return; }

    apiFetch('/me/favorites').then(({ data, error }) => {
      if (error) setError(error);
      else setChannels(data?.data || []);
      setLoading(false);
    });
  }, [user, authLoading]);

  if (authLoading || loading) {
    return (
      <>
        <GlobalNav />
        <main className="max-w-screen-xl mx-auto px-4 sm:px-6 py-8">
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-4">
            {Array.from({ length: 12 }, (_, i) => (
              <div key={i} className="rounded-lg overflow-hidden border border-border">
                <div className="skeleton aspect-video" />
                <div className="p-3 bg-surface space-y-2">
                  <div className="skeleton h-3 w-4/5 rounded" />
                  <div className="skeleton h-3 w-1/2 rounded" />
                </div>
              </div>
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
        <main className="max-w-screen-xl mx-auto px-4 sm:px-6 py-20 flex flex-col items-center text-center">
          <div className="text-6xl mb-6">❤️</div>
          <h1 className="text-white text-2xl font-bold mb-3">Save Your Favorite Channels</h1>
          <p className="text-text-secondary mb-8 max-w-md">
            Sign in to save channels and access them from any device.
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
      <main className="max-w-screen-xl mx-auto px-4 sm:px-6 py-8 pb-16">
        <div className="flex items-center justify-between mb-8">
          <h1 className="text-2xl font-bold text-white">My Favorites</h1>
          <span className="text-text-secondary text-sm">{channels.length} channels</span>
        </div>

        {error && (
          <div className="text-red-400 text-sm mb-6 bg-red-900/10 border border-red-500/20 rounded-lg px-4 py-3">
            {error}
          </div>
        )}

        {channels.length === 0 && !error ? (
          <div className="text-center py-20">
            <div className="text-6xl mb-6">📺</div>
            <p className="text-white text-xl font-semibold mb-2">No favorites yet</p>
            <p className="text-text-secondary mb-8">Browse channels and tap the heart to save them here.</p>
            <Link href="/live/" className="btn-primary text-base px-6">
              Browse Live TV
            </Link>
          </div>
        ) : (
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-4">
            {channels.map(channel => (
              <ChannelCard key={channel.id} channel={channel} />
            ))}
          </div>
        )}
      </main>
    </>
  );
}

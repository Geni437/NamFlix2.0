'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import GlobalNav from '@/components/GlobalNav';
import { apiFetch } from '@/lib/api';
import { useAuth } from '@/context/AuthContext';
import Link from 'next/link';

export default function ProSuccessPage() {
  const router = useRouter();
  const { user, loading: authLoading } = useAuth();
  const [billingStatus, setBillingStatus] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (authLoading) return;
    if (!user) { router.replace('/pro'); return; }

    // Poll billing status briefly — webhook may not have fired yet
    let attempts = 0;
    const maxAttempts = 6;

    async function poll() {
      const { data } = await apiFetch('/billing/status');
      const status = data?.data;
      attempts++;

      if (status?.is_pro) {
        setBillingStatus(status);
        setLoading(false);
      } else if (attempts < maxAttempts) {
        setTimeout(poll, 2000);
      } else {
        // Show success anyway — webhook may be slightly delayed
        setBillingStatus({ is_pro: true });
        setLoading(false);
      }
    }

    poll();
  }, [user, authLoading, router]);

  if (authLoading || loading) {
    return (
      <>
        <GlobalNav />
        <main className="min-h-[60vh] flex flex-col items-center justify-center px-4 text-center">
          <div className="w-8 h-8 border-2 border-amber-400 border-t-transparent rounded-full animate-spin mb-4" />
          <p className="text-text-secondary text-sm">Activating your Pro membership...</p>
        </main>
      </>
    );
  }

  return (
    <>
      <GlobalNav />
      <main className="min-h-[60vh] flex flex-col items-center justify-center px-4 py-16 text-center">
        {/* Success icon */}
        <div className="w-20 h-20 rounded-full bg-amber-400/15 flex items-center justify-center mb-6">
          <svg className="w-10 h-10 text-amber-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
            <path strokeLinecap="round" strokeLinejoin="round" d="M5 13l4 4L19 7" />
          </svg>
        </div>

        <div className="flex items-center gap-2 mb-3">
          <span className="text-3xl font-black text-white">NamFlix</span>
          <span className="px-2.5 py-0.5 rounded text-xs font-black bg-gradient-to-r from-amber-400 to-yellow-300 text-amber-900 tracking-wider">
            PRO
          </span>
        </div>

        <h1 className="text-2xl font-bold text-white mb-3">Welcome to NamFlix Pro!</h1>
        <p className="text-text-secondary max-w-sm mb-2">
          Your subscription is active. Enjoy unlimited favorites, no ads, and 90-day history.
        </p>

        {billingStatus?.pro_expires_at && (
          <p className="text-text-muted text-sm mb-8">
            Next billing date: {new Date(billingStatus.pro_expires_at).toLocaleDateString()}
          </p>
        )}

        {!billingStatus?.pro_expires_at && <div className="mb-8" />}

        <div className="flex flex-col sm:flex-row gap-3 justify-center">
          <Link
            href="/live"
            className="btn-primary px-8 py-3 text-base font-semibold rounded-xl"
          >
            Start Watching
          </Link>
          <Link
            href="/pro"
            className="px-8 py-3 text-sm text-text-secondary hover:text-white border border-border rounded-xl transition-colors"
          >
            Manage Subscription
          </Link>
        </div>
      </main>
    </>
  );
}

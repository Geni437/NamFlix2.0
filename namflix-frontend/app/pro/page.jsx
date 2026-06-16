'use client';

import { useState, useEffect } from 'react';
import GlobalNav from '@/components/GlobalNav';
import { apiFetch } from '@/lib/api';
import { useAuth } from '@/context/AuthContext';

const FEATURES = [
  { label: 'Live TV Access',  free: '✅ All channels', pro: '✅ All channels' },
  { label: 'Advertisements',  free: '✅ Ad-supported',  pro: '❌ None' },
  { label: 'Favorites',       free: '20 max',           pro: 'Unlimited' },
  { label: 'Watch History',   free: '7 days',           pro: '90 days' },
  { label: 'HD Priority',     free: '❌',               pro: '✅' },
];

export default function ProPage() {
  const { user, loading: authLoading, openAuthModal } = useAuth();
  const [billingStatus, setBillingStatus] = useState(null);
  const [checkoutLoading, setCheckoutLoading] = useState(null); // 'monthly' | 'annual'
  const [portalLoading, setPortalLoading] = useState(false);
  const [error, setError] = useState(null);

  useEffect(() => {
    if (!user) return;
    apiFetch('/billing/status').then(({ data }) => {
      if (data?.data) setBillingStatus(data.data);
    });
  }, [user]);

  async function handleSubscribe(plan) {
    if (!user) { openAuthModal(); return; }
    setError(null);
    setCheckoutLoading(plan);

    const { data, error: apiError } = await apiFetch('/billing/create-checkout-session', {
      method: 'POST',
      body: JSON.stringify({ plan }),
    });

    if (apiError || !data?.data?.checkout_url) {
      setError(apiError || 'Could not start checkout. Please try again.');
      setCheckoutLoading(null);
      return;
    }

    window.location.href = data.data.checkout_url;
  }

  async function handleManage() {
    setError(null);
    setPortalLoading(true);
    const { data, error: apiError } = await apiFetch('/billing/portal', { method: 'POST' });
    if (apiError || !data?.data?.portal_url) {
      setError(apiError || 'Could not open billing portal.');
      setPortalLoading(false);
      return;
    }
    window.location.href = data.data.portal_url;
  }

  const isPro = billingStatus?.is_pro;

  return (
    <>
      <GlobalNav />
      <main className="max-w-screen-md mx-auto px-4 sm:px-6 py-12 pb-20">

        {/* Hero */}
        <div className="text-center mb-12">
          <div className="inline-flex items-center gap-3 mb-4">
            <span className="text-4xl font-black text-white">NamFlix</span>
            <span className="px-3 py-1 rounded-md text-sm font-black bg-gradient-to-r from-amber-400 to-yellow-300 text-amber-900 tracking-wider">
              PRO
            </span>
          </div>
          <h1 className="text-2xl sm:text-3xl font-bold text-white mb-3">
            Watch More, Worry Less
          </h1>
          <p className="text-text-secondary max-w-md mx-auto">
            Unlimited favorites, no ads, 90-day history, and HD priority — all for less than a cup of coffee a month.
          </p>
        </div>

        {/* Feature comparison */}
        <div className="bg-surface border border-border rounded-2xl overflow-hidden mb-10">
          <div className="grid grid-cols-3 border-b border-border">
            <div className="p-4 text-text-muted text-xs font-semibold uppercase tracking-wider">Feature</div>
            <div className="p-4 text-center text-text-muted text-xs font-semibold uppercase tracking-wider border-l border-border">Free</div>
            <div className="p-4 text-center text-amber-400 text-xs font-bold uppercase tracking-wider border-l border-border">Pro</div>
          </div>
          {FEATURES.map(({ label, free, pro }, i) => (
            <div
              key={label}
              className={`grid grid-cols-3 ${i < FEATURES.length - 1 ? 'border-b border-border' : ''}`}
            >
              <div className="p-4 text-sm text-text-secondary">{label}</div>
              <div className="p-4 text-center text-sm text-text-muted border-l border-border">{free}</div>
              <div className="p-4 text-center text-sm text-green-400 font-medium border-l border-border">{pro}</div>
            </div>
          ))}
        </div>

        {error && (
          <div className="mb-6 text-red-400 text-sm bg-red-900/10 border border-red-500/20 rounded-lg px-4 py-3">
            {error}
          </div>
        )}

        {/* Current Pro user — show management */}
        {isPro && (
          <div className="bg-amber-400/10 border border-amber-400/30 rounded-2xl p-6 text-center mb-6">
            <div className="text-amber-400 font-bold text-lg mb-1">You&apos;re a Pro member</div>
            {billingStatus?.pro_expires_at && (
              <p className="text-text-secondary text-sm mb-4">
                Active until {new Date(billingStatus.pro_expires_at).toLocaleDateString()}
              </p>
            )}
            {billingStatus?.plan === 'stripe' && (
              <button
                onClick={handleManage}
                disabled={portalLoading}
                className="btn-primary px-6 py-2 text-sm disabled:opacity-50"
              >
                {portalLoading ? 'Opening portal...' : 'Manage Subscription'}
              </button>
            )}
          </div>
        )}

        {/* Pricing cards */}
        {!isPro && (
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            {/* Monthly */}
            <button
              onClick={() => handleSubscribe('monthly')}
              disabled={!!checkoutLoading || authLoading}
              className="relative flex flex-col items-center justify-center p-6 rounded-2xl border border-border
                hover:border-white/30 hover:bg-white/5 transition-all text-left disabled:opacity-50 disabled:cursor-not-allowed"
            >
              <span className="text-text-secondary text-sm mb-2 self-start">Monthly</span>
              <span className="text-white font-black text-4xl mb-1">$2.99</span>
              <span className="text-text-muted text-xs mb-6">per month</span>
              <span className="w-full py-2.5 rounded-xl bg-surface border border-border text-white text-sm font-semibold text-center">
                {checkoutLoading === 'monthly' ? 'Redirecting...' : (user ? 'Get Monthly' : 'Sign In to Subscribe')}
              </span>
            </button>

            {/* Annual — highlighted */}
            <button
              onClick={() => handleSubscribe('annual')}
              disabled={!!checkoutLoading || authLoading}
              className="relative flex flex-col items-center justify-center p-6 rounded-2xl border-2 border-amber-400
                bg-amber-400/5 hover:bg-amber-400/10 transition-all text-left disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {/* Best value badge */}
              <span className="absolute -top-3 left-1/2 -translate-x-1/2 px-3 py-0.5 bg-amber-400 text-amber-900
                rounded-full text-[10px] font-black whitespace-nowrap tracking-wide">
                BEST VALUE
              </span>
              <span className="text-text-secondary text-sm mb-2 self-start mt-2">Annual</span>
              <span className="text-amber-400 font-black text-4xl mb-1">$19.99</span>
              <span className="text-amber-400/70 text-xs mb-1">per year</span>
              <span className="text-text-muted text-xs mb-6">Save 44% vs monthly</span>
              <span className="w-full py-2.5 rounded-xl bg-amber-400 text-amber-900 text-sm font-bold text-center">
                {checkoutLoading === 'annual' ? 'Redirecting...' : (user ? 'Get Annual' : 'Sign In to Subscribe')}
              </span>
            </button>
          </div>
        )}

        <p className="text-center text-text-muted text-xs mt-8">
          Subscriptions auto-renew. Cancel any time. Prices in USD.
        </p>
      </main>
    </>
  );
}

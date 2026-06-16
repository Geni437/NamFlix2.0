'use client';

import { useState, useEffect } from 'react';
import { apiFetch } from '@/lib/api';
import { useAuth } from '@/context/AuthContext';

const FEATURES = [
  { label: 'Live TV Access', free: 'All channels', pro: 'All channels' },
  { label: 'Advertisements',  free: 'Yes',          pro: 'None' },
  { label: 'Favorites',       free: '20 max',       pro: 'Unlimited' },
  { label: 'Watch History',   free: '7 days',       pro: '90 days' },
  { label: 'HD Priority',     free: '—',            pro: 'Yes' },
];

export default function ProUpgradeModal({ isOpen, onClose }) {
  const { user, openAuthModal } = useAuth();
  const [loading, setLoading] = useState(null); // 'monthly' | 'annual' | null

  useEffect(() => {
    if (isOpen) document.body.style.overflow = 'hidden';
    else document.body.style.overflow = '';
    return () => { document.body.style.overflow = ''; };
  }, [isOpen]);

  if (!isOpen) return null;

  async function handleSubscribe(plan) {
    if (!user) {
      onClose();
      openAuthModal();
      return;
    }

    setLoading(plan);
    const { data, error } = await apiFetch('/billing/create-checkout-session', {
      method: 'POST',
      body: JSON.stringify({ plan }),
    });

    if (error || !data?.data?.checkout_url) {
      setLoading(null);
      alert(error || 'Could not start checkout. Please try again.');
      return;
    }

    window.location.href = data.data.checkout_url;
  }

  return (
    <div
      className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/70 backdrop-blur-sm"
      onClick={(e) => e.target === e.currentTarget && onClose()}
    >
      <div className="relative bg-surface border border-border rounded-2xl w-full max-w-md p-6 shadow-2xl">
        {/* Close */}
        <button
          onClick={onClose}
          className="absolute top-4 right-4 text-text-muted hover:text-white transition-colors"
          aria-label="Close"
        >
          <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
            <path strokeLinecap="round" strokeLinejoin="round" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>

        {/* Header */}
        <div className="text-center mb-6">
          <div className="inline-flex items-center gap-2 mb-2">
            <span className="text-2xl font-black text-white">NamFlix</span>
            <span className="px-2 py-0.5 rounded text-xs font-bold bg-gradient-to-r from-amber-400 to-yellow-300 text-amber-900">
              PRO
            </span>
          </div>
          <p className="text-text-secondary text-sm">Unlock the full experience</p>
        </div>

        {/* Feature list */}
        <div className="space-y-2 mb-6">
          {FEATURES.map(({ label, free, pro }) => (
            <div key={label} className="flex items-center justify-between text-sm">
              <span className="text-text-secondary">{label}</span>
              <div className="flex gap-6">
                <span className="text-text-muted w-20 text-center line-through">{free}</span>
                <span className="text-green-400 w-20 text-center font-medium">{pro}</span>
              </div>
            </div>
          ))}
        </div>

        {/* Column headers */}
        <div className="flex justify-end gap-6 text-[10px] font-bold tracking-widest text-text-muted uppercase mb-1 pr-0">
          <span className="w-20 text-center">Free</span>
          <span className="w-20 text-center text-amber-400">Pro</span>
        </div>

        {/* CTA buttons */}
        <div className="grid grid-cols-2 gap-3 mt-4">
          <button
            onClick={() => handleSubscribe('monthly')}
            disabled={!!loading}
            className="flex flex-col items-center justify-center py-3 rounded-xl border border-border
              hover:border-white/30 hover:bg-white/5 transition-all disabled:opacity-50"
          >
            <span className="text-xs text-text-secondary mb-0.5">Monthly</span>
            <span className="text-white font-bold text-lg">$2.99</span>
            <span className="text-text-muted text-[10px]">per month</span>
            {loading === 'monthly' && <span className="text-xs text-text-muted mt-1">...</span>}
          </button>

          <button
            onClick={() => handleSubscribe('annual')}
            disabled={!!loading}
            className="flex flex-col items-center justify-center py-3 rounded-xl border-2 border-amber-400
              bg-amber-400/10 hover:bg-amber-400/20 transition-all relative disabled:opacity-50"
          >
            <span className="absolute -top-2.5 left-1/2 -translate-x-1/2 px-2 py-0.5 bg-amber-400 text-amber-900
              rounded-full text-[9px] font-bold whitespace-nowrap">
              BEST VALUE
            </span>
            <span className="text-xs text-text-secondary mb-0.5 mt-1">Annual</span>
            <span className="text-white font-bold text-lg">$19.99</span>
            <span className="text-amber-400 text-[10px]">Save 44%</span>
            {loading === 'annual' && <span className="text-xs text-text-muted mt-1">...</span>}
          </button>
        </div>

        <button
          onClick={onClose}
          className="w-full mt-4 text-text-muted text-sm hover:text-white transition-colors py-2"
        >
          Maybe Later
        </button>
      </div>
    </div>
  );
}

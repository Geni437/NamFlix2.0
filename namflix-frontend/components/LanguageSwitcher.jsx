'use client';

import { useEffect, useRef, useState } from 'react';
import { LOCALE_FLAGS, LOCALE_NAMES, SUPPORTED_LOCALES } from '@/i18n/request';
import { useLocale } from '@/context/LocaleContext';
import { apiFetch } from '@/lib/api';

export default function LanguageSwitcher({ className = '' }) {
  const { locale, setLocale } = useLocale();
  const [open, setOpen] = useState(false);
  const ref = useRef(null);

  // Close on outside click
  useEffect(() => {
    function handle(e) {
      if (ref.current && !ref.current.contains(e.target)) setOpen(false);
    }
    document.addEventListener('mousedown', handle);
    return () => document.removeEventListener('mousedown', handle);
  }, []);

  async function handleSelect(code) {
    setOpen(false);
    await setLocale(code);
    // Sync to backend if user is authenticated (fire-and-forget)
    try {
      const token = typeof window !== 'undefined'
        ? (JSON.parse(localStorage.getItem('sb-session') ?? 'null')?.access_token)
        : null;
      if (token) {
        apiFetch('/me', { method: 'PUT', body: JSON.stringify({ ui_language: code }) }).catch(() => {});
      }
    } catch {}
  }

  return (
    <div ref={ref} className={`relative ${className}`} style={{ display: 'inline-block' }}>
      {/* Trigger button */}
      <button
        onClick={() => setOpen((o) => !o)}
        aria-label="Select language"
        style={{
          display: 'flex',
          alignItems: 'center',
          gap: '6px',
          padding: '6px 10px',
          background: 'var(--surface)',
          border: '1px solid var(--border)',
          borderRadius: '8px',
          cursor: 'pointer',
          color: 'var(--text-primary)',
          fontSize: '13px',
        }}
      >
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" style={{ color: 'var(--text-muted)' }}>
          <circle cx="12" cy="12" r="10" />
          <line x1="2" y1="12" x2="22" y2="12" />
          <path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z" />
        </svg>
        <span>{LOCALE_FLAGS[locale]}</span>
        <span style={{ color: 'var(--text-secondary)' }}>{LOCALE_NAMES[locale]}</span>
        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" style={{ color: 'var(--text-muted)', transition: 'transform 0.15s', transform: open ? 'rotate(180deg)' : 'rotate(0deg)' }}>
          <polyline points="6 9 12 15 18 9" />
        </svg>
      </button>

      {/* Dropdown */}
      {open && (
        <div
          style={{
            position: 'absolute',
            top: 'calc(100% + 6px)',
            insetInlineEnd: 0,
            minWidth: '190px',
            background: 'var(--surface)',
            border: '1px solid var(--border)',
            borderRadius: '10px',
            boxShadow: '0 8px 24px rgba(0,0,0,0.5)',
            zIndex: 9999,
            overflow: 'hidden',
          }}
          role="listbox"
          aria-label="Language options"
        >
          {SUPPORTED_LOCALES.map((code) => {
            const active = code === locale;
            return (
              <button
                key={code}
                role="option"
                aria-selected={active}
                onClick={() => handleSelect(code)}
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: '10px',
                  width: '100%',
                  padding: '9px 14px',
                  background: active ? 'var(--surface-2)' : 'transparent',
                  border: 'none',
                  cursor: 'pointer',
                  textAlign: 'start',
                }}
                onMouseEnter={(e) => { if (!active) e.currentTarget.style.background = 'rgba(255,255,255,0.04)'; }}
                onMouseLeave={(e) => { if (!active) e.currentTarget.style.background = 'transparent'; }}
              >
                <span style={{ fontSize: '18px', lineHeight: 1 }}>{LOCALE_FLAGS[code]}</span>
                <span style={{ flex: 1, color: active ? 'var(--text-primary)' : 'var(--text-secondary)', fontSize: '13px', fontWeight: active ? 600 : 400 }}>
                  {LOCALE_NAMES[code]}
                </span>
                {active && (
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="var(--accent-blue)" strokeWidth="2.5">
                    <polyline points="20 6 9 17 4 12" />
                  </svg>
                )}
              </button>
            );
          })}
        </div>
      )}
    </div>
  );
}

'use client';

import { createContext, useCallback, useContext, useEffect, useState } from 'react';
import {
  LOCALE_STORAGE_KEY,
  SUPPORTED_LOCALES,
  getLocale,
  isRTL,
  loadMessages,
} from '@/i18n/request';

const LocaleContext = createContext(null);

function get(messages, path) {
  return path.split('.').reduce((obj, key) => obj?.[key], messages) ?? path;
}

function interpolate(str, params) {
  if (!params || typeof str !== 'string') return str;
  return Object.entries(params).reduce(
    (acc, [k, v]) => acc.replace(new RegExp(`\\{${k}\\}`, 'g'), String(v)),
    str,
  );
}

export function LocaleProvider({ children }) {
  const [locale, setLocaleState] = useState('en');
  const [messages, setMessages] = useState({});
  const [ready, setReady] = useState(false);

  useEffect(() => {
    const detected = getLocale();
    loadMessages(detected).then((msgs) => {
      setLocaleState(detected);
      setMessages(msgs);
      applyDirAndLang(detected);
      setReady(true);
    });
  }, []);

  const setLocale = useCallback(async (newLocale) => {
    if (!SUPPORTED_LOCALES.includes(newLocale)) return;
    const msgs = await loadMessages(newLocale);
    localStorage.setItem(LOCALE_STORAGE_KEY, newLocale);
    setLocaleState(newLocale);
    setMessages(msgs);
    applyDirAndLang(newLocale);
  }, []);

  // t('nav.home') or t('nav.home', { count: 5 })
  const t = useCallback(
    (key, params) => interpolate(get(messages, key), params),
    [messages],
  );

  return (
    <LocaleContext.Provider value={{ locale, setLocale, t, isRTL: isRTL(locale), ready }}>
      {children}
    </LocaleContext.Provider>
  );
}

function applyDirAndLang(locale) {
  if (typeof document === 'undefined') return;
  document.documentElement.lang = locale;
  document.documentElement.dir = isRTL(locale) ? 'rtl' : 'ltr';
}

export function useLocale() {
  const ctx = useContext(LocaleContext);
  if (!ctx) throw new Error('useLocale must be used inside LocaleProvider');
  return ctx;
}

export const SUPPORTED_LOCALES = [
  'en', 'fr', 'es', 'ar', 'pt', 'de', 'hi', 'ru', 'zh', 'id', 'tr', 'sw',
] as const;

export type Locale = typeof SUPPORTED_LOCALES[number];

export const LOCALE_NAMES: Record<Locale, string> = {
  en: 'English',
  fr: 'Français',
  es: 'Español',
  ar: 'العربية',
  pt: 'Português',
  de: 'Deutsch',
  hi: 'हिन्दी',
  ru: 'Русский',
  zh: '中文',
  id: 'Bahasa Indonesia',
  tr: 'Türkçe',
  sw: 'Kiswahili',
};

export const LOCALE_FLAGS: Record<Locale, string> = {
  en: '🇺🇸',
  fr: '🇫🇷',
  es: '🇪🇸',
  ar: '🇸🇦',
  pt: '🇧🇷',
  de: '🇩🇪',
  hi: '🇮🇳',
  ru: '🇷🇺',
  zh: '🇨🇳',
  id: '🇮🇩',
  tr: '🇹🇷',
  sw: '🇰🇪',
};

export const RTL_LOCALES: Locale[] = ['ar'];

export const LOCALE_STORAGE_KEY = 'namflix_language';

export function getLocale(): Locale {
  if (typeof window === 'undefined') return 'en';
  const stored = localStorage.getItem(LOCALE_STORAGE_KEY) as Locale | null;
  if (stored && (SUPPORTED_LOCALES as readonly string[]).includes(stored)) {
    return stored;
  }
  const nav = navigator.language.split('-')[0] as Locale;
  return (SUPPORTED_LOCALES as readonly string[]).includes(nav) ? nav : 'en';
}

export function isRTL(locale: Locale): boolean {
  return RTL_LOCALES.includes(locale);
}

export async function loadMessages(locale: Locale): Promise<Record<string, unknown>> {
  try {
    const messages = await import(`../public/locales/${locale}/common.json`);
    return messages.default ?? messages;
  } catch {
    const fallback = await import('../public/locales/en/common.json');
    return fallback.default ?? fallback;
  }
}

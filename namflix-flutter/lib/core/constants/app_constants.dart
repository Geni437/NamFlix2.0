class AppConstants {
  AppConstants._();

  // dart-define injected at build time:
  //   flutter run --dart-define=LARAVEL_API_URL=https://namflix.info/api/v1
  //   flutter run --dart-define=SUPABASE_URL=https://xxx.supabase.co
  //   flutter run --dart-define=SUPABASE_ANON_KEY=eyJhb...
  static const laravelApiUrl  = String.fromEnvironment('LARAVEL_API_URL',  defaultValue: 'https://namflix.info/api/v1');
  static const supabaseUrl    = String.fromEnvironment('SUPABASE_URL',     defaultValue: '');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');

  // Hive box names
  static const boxSettings       = 'settings';
  static const boxUserPrefs      = 'user_prefs';
  static const boxChannelsCache  = 'channels_cache';
  static const boxCategoriesCache = 'categories_cache';
  static const boxCountriesCache = 'countries_cache';
  static const boxRecentSearches = 'recent_searches';

  // Hive keys
  static const keyOnboardingDone       = 'onboarding_done';
  static const keyPreferredCountry     = 'preferred_country';
  static const keyPreferredCategories  = 'preferred_categories';
  static const keyPreferredLanguage    = 'preferred_language';
  static const keyDefaultQuality       = 'default_quality';
  static const keyUiLanguage           = 'ui_language';

  // Pagination
  static const channelsPerPage = 48;
  static const maxRecentSearches = 10;

  // Timeouts
  static const apiTimeoutSec = 15;
  static const cacheChannelsTtlHours = 6;

  // Deep link scheme
  static const deepLinkScheme = 'namflix';
}

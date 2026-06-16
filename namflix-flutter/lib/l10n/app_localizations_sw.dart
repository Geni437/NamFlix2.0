// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swahili (`sw`).
class AppLocalizationsSw extends AppLocalizations {
  AppLocalizationsSw([String locale = 'sw']) : super(locale);

  @override
  String get navHome => 'Nyumbani';

  @override
  String get navLiveTv => 'TV Moja kwa Moja';

  @override
  String get navSearch => 'Tafuta';

  @override
  String get navFavorites => 'Vipendwa';

  @override
  String get navHistory => 'Historia';

  @override
  String get navProfile => 'Wasifu';

  @override
  String get navSignIn => 'Ingia';

  @override
  String get navSignOut => 'Toka';

  @override
  String get navSettings => 'Mipangilio';

  @override
  String get homeLiveNow => 'Moja kwa Moja Sasa';

  @override
  String get homeNews => 'Habari';

  @override
  String get homeSports => 'Michezo';

  @override
  String get homeEntertainment => 'Burudani';

  @override
  String get homeMusic => 'Muziki';

  @override
  String get homeMovies => 'Filamu';

  @override
  String get homeSeeAll => 'Ona Zote';

  @override
  String homeChannelsInCountry(String country) {
    return 'Vituo vya $country';
  }

  @override
  String get homeWatchNow => 'Tazama Sasa';

  @override
  String get homeTrendingGlobally => 'Inayoongoza Duniani';

  @override
  String get homeFeatured => 'Iliyoangaziwa';

  @override
  String get liveAllChannels => 'Vituo Vyote';

  @override
  String get liveFilter => 'Chuja';

  @override
  String get liveSort => 'Panga';

  @override
  String get liveSearchPlaceholder => 'Tafuta vituo...';

  @override
  String liveShowingCount(int count) {
    return 'Kuonyesha vituo $count';
  }

  @override
  String get liveNoResults => 'Hakuna vituo vilivyopatikana';

  @override
  String get liveLiveOnly => 'Moja kwa Moja Tu';

  @override
  String get liveAllCountries => 'Nchi Zote';

  @override
  String get liveAllCategories => 'Makundi Yote';

  @override
  String get liveAllLanguages => 'Lugha Zote';

  @override
  String get liveSortAz => 'A hadi Z';

  @override
  String get liveSortPopular => 'Maarufu Zaidi';

  @override
  String get liveSortCountry => 'Kwa Nchi';

  @override
  String get liveLoadMore => 'Pakia Zaidi';

  @override
  String liveChannelCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vituo $count',
      one: 'kituo 1',
      zero: 'Hakuna vituo',
    );
    return '$_temp0';
  }

  @override
  String get channelWatchNow => 'Tazama Sasa';

  @override
  String get channelAddFavorite => 'Ongeza kwenye Vipendwa';

  @override
  String get channelRemoveFavorite => 'Ondoa kwenye Vipendwa';

  @override
  String get channelReportStream => 'Ripoti Utiririshaji';

  @override
  String channelMoreFromCountry(String country) {
    return 'Zaidi kutoka $country';
  }

  @override
  String get channelStreamUnavailable => 'Utiririshaji Haupatikani';

  @override
  String get channelTryAnotherQuality => 'Jaribu Ubora Mwingine';

  @override
  String get channelRetry => 'Jaribu Tena';

  @override
  String get channelNowPlaying => 'Inachezwa Sasa';

  @override
  String get channelUpNext => 'Kinachofuata';

  @override
  String channelEndsAt(String time) {
    return 'Inaisha saa $time';
  }

  @override
  String get channelOfficialWebsite => 'Tovuti Rasmi';

  @override
  String get channelQualityAuto => 'Kiotomatiki';

  @override
  String get channelQualityHd => 'HD';

  @override
  String get channelQualitySd => 'SD';

  @override
  String get playerPlay => 'Cheza';

  @override
  String get playerPause => 'Simamisha';

  @override
  String get playerFullscreen => 'Skrini Nzima';

  @override
  String get playerExitFullscreen => 'Toka Skrini Nzima';

  @override
  String get playerMute => 'Zima Sauti';

  @override
  String get playerUnmute => 'Washa Sauti';

  @override
  String get playerQuality => 'Ubora';

  @override
  String get playerLiveLabel => 'MOJA KWA MOJA';

  @override
  String get playerLoading => 'Inapakia utiririshaji...';

  @override
  String get playerErrorTitle => 'Hitilafu ya Kucheza';

  @override
  String get playerErrorMessage =>
      'Utiririshaji huu haukuweza kupakiwa. Jaribu ubora mwingine au angalia baadaye.';

  @override
  String get searchPlaceholder => 'Tafuta vituo...';

  @override
  String searchResultsFor(String query) {
    return 'Matokeo ya \"$query\"';
  }

  @override
  String get searchNoResultsTitle => 'Hakuna Matokeo';

  @override
  String get searchNoResultsSubtitle =>
      'Jaribu neno tofauti la utafutaji au vinjari kwa kategoria';

  @override
  String get searchRecentSearches => 'Utafutaji wa Hivi Karibuni';

  @override
  String get searchClearRecent => 'Futa';

  @override
  String get authSignIn => 'Ingia';

  @override
  String get authSignUp => 'Jisajili';

  @override
  String get authEmail => 'Barua pepe';

  @override
  String get authPassword => 'Nenosiri';

  @override
  String get authConfirmPassword => 'Thibitisha Nenosiri';

  @override
  String get authGoogleSignIn => 'Endelea na Google';

  @override
  String get authForgotPassword => 'Umesahau Nenosiri?';

  @override
  String get authNoAccount => 'Huna akaunti?';

  @override
  String get authHaveAccount => 'Una akaunti tayari?';

  @override
  String get authContinueAsGuest => 'Endelea kama Mgeni';

  @override
  String get authSignInToContinue => 'Ingia ili uendelee';

  @override
  String get authSignInForFavorites => 'Ingia ili uhifadhi vipendwa';

  @override
  String get authSignInForHistory => 'Ingia ili uone historia yako';

  @override
  String get authCreateAccount => 'Unda Akaunti';

  @override
  String get authOrContinueWith => 'au endelea na';

  @override
  String get epgNowPlaying => 'Inachezwa Sasa';

  @override
  String get epgUpNext => 'Kinachofuata';

  @override
  String epgEndsAt(String time) {
    return 'Inaisha $time';
  }

  @override
  String get epgNoGuideAvailable => 'Mwongozo wa programu haupatikani';

  @override
  String get epgTodaysSchedule => 'Ratiba ya Leo';

  @override
  String get epgNowBadge => 'SASA';

  @override
  String get epgScheduleCollapsed => 'Onyesha Ratiba';

  @override
  String get epgScheduleExpanded => 'Ficha Ratiba';

  @override
  String get reportTitle => 'Ripoti Tatizo la Utiririshaji';

  @override
  String get reportReasonOffline => 'Utiririshaji uko nje ya mtandao';

  @override
  String get reportReasonGeoBlocked => 'Imezuiwa katika eneo langu';

  @override
  String get reportReasonPoorQuality => 'Ubora mbaya wa video';

  @override
  String get reportReasonWrongContent => 'Maudhui mabaya ya kituo';

  @override
  String get reportSubmit => 'Tuma Ripoti';

  @override
  String get reportCancel => 'Ghairi';

  @override
  String get reportThankYou => 'Asante kwa ripoti yako!';

  @override
  String get onboardingWhereWatching => 'Unatazama kutoka wapi?';

  @override
  String get onboardingWhatEnjoy => 'Unapenda kutazama nini?';

  @override
  String get onboardingFreeOrSignin => 'Tazama bure au ingia kwa zaidi';

  @override
  String get onboardingSkip => 'Ruka';

  @override
  String get onboardingContinueBtn => 'Endelea';

  @override
  String get onboardingSelectCountry => 'Chagua nchi yako';

  @override
  String get onboardingSelectCategories => 'Chagua maslahi yako';

  @override
  String get errorsSomethingWrong => 'Kuna hitilafu imetokea';

  @override
  String get errorsStreamUnavailable => 'Utiririshaji huu haupatikani kwa sasa';

  @override
  String get errorsNoInternet => 'Hakuna muunganisho wa intaneti';

  @override
  String get errorsTryAgain => 'Tafadhali jaribu tena';

  @override
  String get errorsNotFound => 'Ukurasa haupatikani';

  @override
  String get errorsGoHome => 'Nenda Nyumbani';

  @override
  String get errorsServerError =>
      'Hitilafu ya seva. Tafadhali jaribu tena baadaye.';

  @override
  String get commonLoading => 'Inapakia...';

  @override
  String get commonError => 'Hitilafu';

  @override
  String get commonRetry => 'Jaribu Tena';

  @override
  String get commonClose => 'Funga';

  @override
  String get commonCancel => 'Ghairi';

  @override
  String get commonSave => 'Hifadhi';

  @override
  String get commonDone => 'Imekamilika';

  @override
  String get commonBack => 'Rudi';

  @override
  String get commonOk => 'Sawa';

  @override
  String get commonShare => 'Shiriki';

  @override
  String get commonReport => 'Ripoti';

  @override
  String get commonFavorite => 'Kipendwa';

  @override
  String get commonUnfavorite => 'Ondoa Kipendwa';

  @override
  String get commonProBadge => 'PRO';

  @override
  String get commonLiveBadge => 'MOJA KWA MOJA';

  @override
  String get commonHdBadge => 'HD';

  @override
  String get commonSdBadge => 'SD';

  @override
  String get commonMore => 'Zaidi';

  @override
  String get commonLess => 'Chini';

  @override
  String get commonSeeAll => 'Ona Zote';
}

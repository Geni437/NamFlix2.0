import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sw.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('id'),
    Locale('pt'),
    Locale('ru'),
    Locale('sw'),
    Locale('tr'),
    Locale('zh')
  ];

  /// Home nav item
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Live TV nav item
  ///
  /// In en, this message translates to:
  /// **'Live TV'**
  String get navLiveTv;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @navFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get navFavorites;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get navSignIn;

  /// No description provided for @navSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get navSignOut;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @homeLiveNow.
  ///
  /// In en, this message translates to:
  /// **'Live Now'**
  String get homeLiveNow;

  /// No description provided for @homeNews.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get homeNews;

  /// No description provided for @homeSports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get homeSports;

  /// No description provided for @homeEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get homeEntertainment;

  /// No description provided for @homeMusic.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get homeMusic;

  /// No description provided for @homeMovies.
  ///
  /// In en, this message translates to:
  /// **'Movies'**
  String get homeMovies;

  /// No description provided for @homeSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get homeSeeAll;

  /// No description provided for @homeChannelsInCountry.
  ///
  /// In en, this message translates to:
  /// **'Channels in {country}'**
  String homeChannelsInCountry(String country);

  /// No description provided for @homeWatchNow.
  ///
  /// In en, this message translates to:
  /// **'Watch Now'**
  String get homeWatchNow;

  /// No description provided for @homeTrendingGlobally.
  ///
  /// In en, this message translates to:
  /// **'Trending Globally'**
  String get homeTrendingGlobally;

  /// No description provided for @homeFeatured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get homeFeatured;

  /// No description provided for @liveAllChannels.
  ///
  /// In en, this message translates to:
  /// **'All Channels'**
  String get liveAllChannels;

  /// No description provided for @liveFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get liveFilter;

  /// No description provided for @liveSort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get liveSort;

  /// No description provided for @liveSearchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search channels...'**
  String get liveSearchPlaceholder;

  /// No description provided for @liveShowingCount.
  ///
  /// In en, this message translates to:
  /// **'Showing {count} channels'**
  String liveShowingCount(int count);

  /// No description provided for @liveNoResults.
  ///
  /// In en, this message translates to:
  /// **'No channels found'**
  String get liveNoResults;

  /// No description provided for @liveLiveOnly.
  ///
  /// In en, this message translates to:
  /// **'Live Only'**
  String get liveLiveOnly;

  /// No description provided for @liveAllCountries.
  ///
  /// In en, this message translates to:
  /// **'All Countries'**
  String get liveAllCountries;

  /// No description provided for @liveAllCategories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get liveAllCategories;

  /// No description provided for @liveAllLanguages.
  ///
  /// In en, this message translates to:
  /// **'All Languages'**
  String get liveAllLanguages;

  /// No description provided for @liveSortAz.
  ///
  /// In en, this message translates to:
  /// **'A to Z'**
  String get liveSortAz;

  /// No description provided for @liveSortPopular.
  ///
  /// In en, this message translates to:
  /// **'Most Popular'**
  String get liveSortPopular;

  /// No description provided for @liveSortCountry.
  ///
  /// In en, this message translates to:
  /// **'By Country'**
  String get liveSortCountry;

  /// No description provided for @liveLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Load More'**
  String get liveLoadMore;

  /// No description provided for @liveChannelCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No channels} =1{1 channel} other{{count} channels}}'**
  String liveChannelCount(int count);

  /// No description provided for @channelWatchNow.
  ///
  /// In en, this message translates to:
  /// **'Watch Now'**
  String get channelWatchNow;

  /// No description provided for @channelAddFavorite.
  ///
  /// In en, this message translates to:
  /// **'Add to Favorites'**
  String get channelAddFavorite;

  /// No description provided for @channelRemoveFavorite.
  ///
  /// In en, this message translates to:
  /// **'Remove from Favorites'**
  String get channelRemoveFavorite;

  /// No description provided for @channelReportStream.
  ///
  /// In en, this message translates to:
  /// **'Report Stream'**
  String get channelReportStream;

  /// No description provided for @channelMoreFromCountry.
  ///
  /// In en, this message translates to:
  /// **'More from {country}'**
  String channelMoreFromCountry(String country);

  /// No description provided for @channelStreamUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Stream Unavailable'**
  String get channelStreamUnavailable;

  /// No description provided for @channelTryAnotherQuality.
  ///
  /// In en, this message translates to:
  /// **'Try Another Quality'**
  String get channelTryAnotherQuality;

  /// No description provided for @channelRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get channelRetry;

  /// No description provided for @channelNowPlaying.
  ///
  /// In en, this message translates to:
  /// **'Now Playing'**
  String get channelNowPlaying;

  /// No description provided for @channelUpNext.
  ///
  /// In en, this message translates to:
  /// **'Up Next'**
  String get channelUpNext;

  /// No description provided for @channelEndsAt.
  ///
  /// In en, this message translates to:
  /// **'Ends at {time}'**
  String channelEndsAt(String time);

  /// No description provided for @channelOfficialWebsite.
  ///
  /// In en, this message translates to:
  /// **'Official Website'**
  String get channelOfficialWebsite;

  /// No description provided for @channelQualityAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get channelQualityAuto;

  /// No description provided for @channelQualityHd.
  ///
  /// In en, this message translates to:
  /// **'HD'**
  String get channelQualityHd;

  /// No description provided for @channelQualitySd.
  ///
  /// In en, this message translates to:
  /// **'SD'**
  String get channelQualitySd;

  /// No description provided for @playerPlay.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get playerPlay;

  /// No description provided for @playerPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get playerPause;

  /// No description provided for @playerFullscreen.
  ///
  /// In en, this message translates to:
  /// **'Fullscreen'**
  String get playerFullscreen;

  /// No description provided for @playerExitFullscreen.
  ///
  /// In en, this message translates to:
  /// **'Exit Fullscreen'**
  String get playerExitFullscreen;

  /// No description provided for @playerMute.
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get playerMute;

  /// No description provided for @playerUnmute.
  ///
  /// In en, this message translates to:
  /// **'Unmute'**
  String get playerUnmute;

  /// No description provided for @playerQuality.
  ///
  /// In en, this message translates to:
  /// **'Quality'**
  String get playerQuality;

  /// No description provided for @playerLiveLabel.
  ///
  /// In en, this message translates to:
  /// **'LIVE'**
  String get playerLiveLabel;

  /// No description provided for @playerLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading stream...'**
  String get playerLoading;

  /// No description provided for @playerErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Playback Error'**
  String get playerErrorTitle;

  /// No description provided for @playerErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'This stream could not be loaded. Please try another quality or check back later.'**
  String get playerErrorMessage;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search for channels...'**
  String get searchPlaceholder;

  /// No description provided for @searchResultsFor.
  ///
  /// In en, this message translates to:
  /// **'Results for \"{query}\"'**
  String searchResultsFor(String query);

  /// No description provided for @searchNoResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Results Found'**
  String get searchNoResultsTitle;

  /// No description provided for @searchNoResultsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term or browse by category'**
  String get searchNoResultsSubtitle;

  /// No description provided for @searchRecentSearches.
  ///
  /// In en, this message translates to:
  /// **'Recent Searches'**
  String get searchRecentSearches;

  /// No description provided for @searchClearRecent.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get searchClearRecent;

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get authSignIn;

  /// No description provided for @authSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get authSignUp;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get authConfirmPassword;

  /// No description provided for @authGoogleSignIn.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authGoogleSignIn;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get authForgotPassword;

  /// No description provided for @authNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get authNoAccount;

  /// No description provided for @authHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get authHaveAccount;

  /// No description provided for @authContinueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get authContinueAsGuest;

  /// No description provided for @authSignInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get authSignInToContinue;

  /// No description provided for @authSignInForFavorites.
  ///
  /// In en, this message translates to:
  /// **'Sign in to save your favorites'**
  String get authSignInForFavorites;

  /// No description provided for @authSignInForHistory.
  ///
  /// In en, this message translates to:
  /// **'Sign in to view your watch history'**
  String get authSignInForHistory;

  /// No description provided for @authCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authCreateAccount;

  /// No description provided for @authOrContinueWith.
  ///
  /// In en, this message translates to:
  /// **'or continue with'**
  String get authOrContinueWith;

  /// No description provided for @epgNowPlaying.
  ///
  /// In en, this message translates to:
  /// **'Now Playing'**
  String get epgNowPlaying;

  /// No description provided for @epgUpNext.
  ///
  /// In en, this message translates to:
  /// **'Up Next'**
  String get epgUpNext;

  /// No description provided for @epgEndsAt.
  ///
  /// In en, this message translates to:
  /// **'Ends {time}'**
  String epgEndsAt(String time);

  /// No description provided for @epgNoGuideAvailable.
  ///
  /// In en, this message translates to:
  /// **'Program guide not available'**
  String get epgNoGuideAvailable;

  /// No description provided for @epgTodaysSchedule.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Schedule'**
  String get epgTodaysSchedule;

  /// No description provided for @epgNowBadge.
  ///
  /// In en, this message translates to:
  /// **'NOW'**
  String get epgNowBadge;

  /// No description provided for @epgScheduleCollapsed.
  ///
  /// In en, this message translates to:
  /// **'Show Schedule'**
  String get epgScheduleCollapsed;

  /// No description provided for @epgScheduleExpanded.
  ///
  /// In en, this message translates to:
  /// **'Hide Schedule'**
  String get epgScheduleExpanded;

  /// No description provided for @reportTitle.
  ///
  /// In en, this message translates to:
  /// **'Report Stream Issue'**
  String get reportTitle;

  /// No description provided for @reportReasonOffline.
  ///
  /// In en, this message translates to:
  /// **'Stream is offline'**
  String get reportReasonOffline;

  /// No description provided for @reportReasonGeoBlocked.
  ///
  /// In en, this message translates to:
  /// **'Geo-blocked in my region'**
  String get reportReasonGeoBlocked;

  /// No description provided for @reportReasonPoorQuality.
  ///
  /// In en, this message translates to:
  /// **'Poor video quality'**
  String get reportReasonPoorQuality;

  /// No description provided for @reportReasonWrongContent.
  ///
  /// In en, this message translates to:
  /// **'Wrong channel content'**
  String get reportReasonWrongContent;

  /// No description provided for @reportSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit Report'**
  String get reportSubmit;

  /// No description provided for @reportCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get reportCancel;

  /// No description provided for @reportThankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your report!'**
  String get reportThankYou;

  /// No description provided for @onboardingWhereWatching.
  ///
  /// In en, this message translates to:
  /// **'Where are you watching from?'**
  String get onboardingWhereWatching;

  /// No description provided for @onboardingWhatEnjoy.
  ///
  /// In en, this message translates to:
  /// **'What do you enjoy watching?'**
  String get onboardingWhatEnjoy;

  /// No description provided for @onboardingFreeOrSignin.
  ///
  /// In en, this message translates to:
  /// **'Watch free or sign in for more'**
  String get onboardingFreeOrSignin;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingContinueBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardingContinueBtn;

  /// No description provided for @onboardingSelectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select your country'**
  String get onboardingSelectCountry;

  /// No description provided for @onboardingSelectCategories.
  ///
  /// In en, this message translates to:
  /// **'Select your interests'**
  String get onboardingSelectCategories;

  /// No description provided for @errorsSomethingWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorsSomethingWrong;

  /// No description provided for @errorsStreamUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This stream is currently unavailable'**
  String get errorsStreamUnavailable;

  /// No description provided for @errorsNoInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get errorsNoInternet;

  /// No description provided for @errorsTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Please try again'**
  String get errorsTryAgain;

  /// No description provided for @errorsNotFound.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get errorsNotFound;

  /// No description provided for @errorsGoHome.
  ///
  /// In en, this message translates to:
  /// **'Go to Home'**
  String get errorsGoHome;

  /// No description provided for @errorsServerError.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again later.'**
  String get errorsServerError;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get commonLoading;

  /// No description provided for @commonError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get commonError;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get commonShare;

  /// No description provided for @commonReport.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get commonReport;

  /// No description provided for @commonFavorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get commonFavorite;

  /// No description provided for @commonUnfavorite.
  ///
  /// In en, this message translates to:
  /// **'Unfavorite'**
  String get commonUnfavorite;

  /// No description provided for @commonProBadge.
  ///
  /// In en, this message translates to:
  /// **'PRO'**
  String get commonProBadge;

  /// No description provided for @commonLiveBadge.
  ///
  /// In en, this message translates to:
  /// **'LIVE'**
  String get commonLiveBadge;

  /// No description provided for @commonHdBadge.
  ///
  /// In en, this message translates to:
  /// **'HD'**
  String get commonHdBadge;

  /// No description provided for @commonSdBadge.
  ///
  /// In en, this message translates to:
  /// **'SD'**
  String get commonSdBadge;

  /// No description provided for @commonMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get commonMore;

  /// No description provided for @commonLess.
  ///
  /// In en, this message translates to:
  /// **'Less'**
  String get commonLess;

  /// No description provided for @commonSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get commonSeeAll;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'de',
        'en',
        'es',
        'fr',
        'hi',
        'id',
        'pt',
        'ru',
        'sw',
        'tr',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'sw':
      return AppLocalizationsSw();
    case 'tr':
      return AppLocalizationsTr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

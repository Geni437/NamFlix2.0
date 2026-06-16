// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navHome => 'Home';

  @override
  String get navLiveTv => 'Live TV';

  @override
  String get navSearch => 'Search';

  @override
  String get navFavorites => 'Favorites';

  @override
  String get navHistory => 'History';

  @override
  String get navProfile => 'Profile';

  @override
  String get navSignIn => 'Sign In';

  @override
  String get navSignOut => 'Sign Out';

  @override
  String get navSettings => 'Settings';

  @override
  String get homeLiveNow => 'Live Now';

  @override
  String get homeNews => 'News';

  @override
  String get homeSports => 'Sports';

  @override
  String get homeEntertainment => 'Entertainment';

  @override
  String get homeMusic => 'Music';

  @override
  String get homeMovies => 'Movies';

  @override
  String get homeSeeAll => 'See All';

  @override
  String homeChannelsInCountry(String country) {
    return 'Channels in $country';
  }

  @override
  String get homeWatchNow => 'Watch Now';

  @override
  String get homeTrendingGlobally => 'Trending Globally';

  @override
  String get homeFeatured => 'Featured';

  @override
  String get liveAllChannels => 'All Channels';

  @override
  String get liveFilter => 'Filter';

  @override
  String get liveSort => 'Sort';

  @override
  String get liveSearchPlaceholder => 'Search channels...';

  @override
  String liveShowingCount(int count) {
    return 'Showing $count channels';
  }

  @override
  String get liveNoResults => 'No channels found';

  @override
  String get liveLiveOnly => 'Live Only';

  @override
  String get liveAllCountries => 'All Countries';

  @override
  String get liveAllCategories => 'All Categories';

  @override
  String get liveAllLanguages => 'All Languages';

  @override
  String get liveSortAz => 'A to Z';

  @override
  String get liveSortPopular => 'Most Popular';

  @override
  String get liveSortCountry => 'By Country';

  @override
  String get liveLoadMore => 'Load More';

  @override
  String liveChannelCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count channels',
      one: '1 channel',
      zero: 'No channels',
    );
    return '$_temp0';
  }

  @override
  String get channelWatchNow => 'Watch Now';

  @override
  String get channelAddFavorite => 'Add to Favorites';

  @override
  String get channelRemoveFavorite => 'Remove from Favorites';

  @override
  String get channelReportStream => 'Report Stream';

  @override
  String channelMoreFromCountry(String country) {
    return 'More from $country';
  }

  @override
  String get channelStreamUnavailable => 'Stream Unavailable';

  @override
  String get channelTryAnotherQuality => 'Try Another Quality';

  @override
  String get channelRetry => 'Retry';

  @override
  String get channelNowPlaying => 'Now Playing';

  @override
  String get channelUpNext => 'Up Next';

  @override
  String channelEndsAt(String time) {
    return 'Ends at $time';
  }

  @override
  String get channelOfficialWebsite => 'Official Website';

  @override
  String get channelQualityAuto => 'Auto';

  @override
  String get channelQualityHd => 'HD';

  @override
  String get channelQualitySd => 'SD';

  @override
  String get playerPlay => 'Play';

  @override
  String get playerPause => 'Pause';

  @override
  String get playerFullscreen => 'Fullscreen';

  @override
  String get playerExitFullscreen => 'Exit Fullscreen';

  @override
  String get playerMute => 'Mute';

  @override
  String get playerUnmute => 'Unmute';

  @override
  String get playerQuality => 'Quality';

  @override
  String get playerLiveLabel => 'LIVE';

  @override
  String get playerLoading => 'Loading stream...';

  @override
  String get playerErrorTitle => 'Playback Error';

  @override
  String get playerErrorMessage =>
      'This stream could not be loaded. Please try another quality or check back later.';

  @override
  String get searchPlaceholder => 'Search for channels...';

  @override
  String searchResultsFor(String query) {
    return 'Results for \"$query\"';
  }

  @override
  String get searchNoResultsTitle => 'No Results Found';

  @override
  String get searchNoResultsSubtitle =>
      'Try a different search term or browse by category';

  @override
  String get searchRecentSearches => 'Recent Searches';

  @override
  String get searchClearRecent => 'Clear';

  @override
  String get authSignIn => 'Sign In';

  @override
  String get authSignUp => 'Sign Up';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Password';

  @override
  String get authConfirmPassword => 'Confirm Password';

  @override
  String get authGoogleSignIn => 'Continue with Google';

  @override
  String get authForgotPassword => 'Forgot Password?';

  @override
  String get authNoAccount => 'Don\'t have an account?';

  @override
  String get authHaveAccount => 'Already have an account?';

  @override
  String get authContinueAsGuest => 'Continue as Guest';

  @override
  String get authSignInToContinue => 'Sign in to continue';

  @override
  String get authSignInForFavorites => 'Sign in to save your favorites';

  @override
  String get authSignInForHistory => 'Sign in to view your watch history';

  @override
  String get authCreateAccount => 'Create Account';

  @override
  String get authOrContinueWith => 'or continue with';

  @override
  String get epgNowPlaying => 'Now Playing';

  @override
  String get epgUpNext => 'Up Next';

  @override
  String epgEndsAt(String time) {
    return 'Ends $time';
  }

  @override
  String get epgNoGuideAvailable => 'Program guide not available';

  @override
  String get epgTodaysSchedule => 'Today\'s Schedule';

  @override
  String get epgNowBadge => 'NOW';

  @override
  String get epgScheduleCollapsed => 'Show Schedule';

  @override
  String get epgScheduleExpanded => 'Hide Schedule';

  @override
  String get reportTitle => 'Report Stream Issue';

  @override
  String get reportReasonOffline => 'Stream is offline';

  @override
  String get reportReasonGeoBlocked => 'Geo-blocked in my region';

  @override
  String get reportReasonPoorQuality => 'Poor video quality';

  @override
  String get reportReasonWrongContent => 'Wrong channel content';

  @override
  String get reportSubmit => 'Submit Report';

  @override
  String get reportCancel => 'Cancel';

  @override
  String get reportThankYou => 'Thank you for your report!';

  @override
  String get onboardingWhereWatching => 'Where are you watching from?';

  @override
  String get onboardingWhatEnjoy => 'What do you enjoy watching?';

  @override
  String get onboardingFreeOrSignin => 'Watch free or sign in for more';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingContinueBtn => 'Continue';

  @override
  String get onboardingSelectCountry => 'Select your country';

  @override
  String get onboardingSelectCategories => 'Select your interests';

  @override
  String get errorsSomethingWrong => 'Something went wrong';

  @override
  String get errorsStreamUnavailable => 'This stream is currently unavailable';

  @override
  String get errorsNoInternet => 'No internet connection';

  @override
  String get errorsTryAgain => 'Please try again';

  @override
  String get errorsNotFound => 'Page not found';

  @override
  String get errorsGoHome => 'Go to Home';

  @override
  String get errorsServerError => 'Server error. Please try again later.';

  @override
  String get commonLoading => 'Loading...';

  @override
  String get commonError => 'Error';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonClose => 'Close';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDone => 'Done';

  @override
  String get commonBack => 'Back';

  @override
  String get commonOk => 'OK';

  @override
  String get commonShare => 'Share';

  @override
  String get commonReport => 'Report';

  @override
  String get commonFavorite => 'Favorite';

  @override
  String get commonUnfavorite => 'Unfavorite';

  @override
  String get commonProBadge => 'PRO';

  @override
  String get commonLiveBadge => 'LIVE';

  @override
  String get commonHdBadge => 'HD';

  @override
  String get commonSdBadge => 'SD';

  @override
  String get commonMore => 'More';

  @override
  String get commonLess => 'Less';

  @override
  String get commonSeeAll => 'See All';
}

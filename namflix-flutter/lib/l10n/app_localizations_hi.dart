// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get navHome => 'होम';

  @override
  String get navLiveTv => 'लाइव टीवी';

  @override
  String get navSearch => 'खोज';

  @override
  String get navFavorites => 'पसंदीदा';

  @override
  String get navHistory => 'इतिहास';

  @override
  String get navProfile => 'प्रोफ़ाइल';

  @override
  String get navSignIn => 'साइन इन';

  @override
  String get navSignOut => 'साइन आउट';

  @override
  String get navSettings => 'सेटिंग्स';

  @override
  String get homeLiveNow => 'अभी लाइव';

  @override
  String get homeNews => 'समाचार';

  @override
  String get homeSports => 'खेल';

  @override
  String get homeEntertainment => 'मनोरंजन';

  @override
  String get homeMusic => 'संगीत';

  @override
  String get homeMovies => 'फिल्में';

  @override
  String get homeSeeAll => 'सभी देखें';

  @override
  String homeChannelsInCountry(String country) {
    return '$country के चैनल';
  }

  @override
  String get homeWatchNow => 'अभी देखें';

  @override
  String get homeTrendingGlobally => 'विश्व स्तर पर ट्रेंडिंग';

  @override
  String get homeFeatured => 'विशेष रुप से प्रदर्शित';

  @override
  String get liveAllChannels => 'सभी चैनल';

  @override
  String get liveFilter => 'फ़िल्टर';

  @override
  String get liveSort => 'क्रमबद्ध करें';

  @override
  String get liveSearchPlaceholder => 'चैनल खोजें...';

  @override
  String liveShowingCount(int count) {
    return '$count चैनल दिखाए जा रहे हैं';
  }

  @override
  String get liveNoResults => 'कोई चैनल नहीं मिला';

  @override
  String get liveLiveOnly => 'केवल लाइव';

  @override
  String get liveAllCountries => 'सभी देश';

  @override
  String get liveAllCategories => 'सभी श्रेणियाँ';

  @override
  String get liveAllLanguages => 'सभी भाषाएँ';

  @override
  String get liveSortAz => 'A से Z';

  @override
  String get liveSortPopular => 'सबसे लोकप्रिय';

  @override
  String get liveSortCountry => 'देश के अनुसार';

  @override
  String get liveLoadMore => 'और लोड करें';

  @override
  String liveChannelCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count चैनल',
      one: '1 चैनल',
      zero: 'कोई चैनल नहीं',
    );
    return '$_temp0';
  }

  @override
  String get channelWatchNow => 'अभी देखें';

  @override
  String get channelAddFavorite => 'पसंदीदा में जोड़ें';

  @override
  String get channelRemoveFavorite => 'पसंदीदा से हटाएँ';

  @override
  String get channelReportStream => 'स्ट्रीम रिपोर्ट करें';

  @override
  String channelMoreFromCountry(String country) {
    return '$country से और';
  }

  @override
  String get channelStreamUnavailable => 'स्ट्रीम उपलब्ध नहीं';

  @override
  String get channelTryAnotherQuality => 'दूसरी गुणवत्ता आज़माएँ';

  @override
  String get channelRetry => 'पुनः प्रयास करें';

  @override
  String get channelNowPlaying => 'अभी चल रहा है';

  @override
  String get channelUpNext => 'आगे';

  @override
  String channelEndsAt(String time) {
    return '$time पर समाप्त';
  }

  @override
  String get channelOfficialWebsite => 'आधिकारिक वेबसाइट';

  @override
  String get channelQualityAuto => 'स्वचालित';

  @override
  String get channelQualityHd => 'HD';

  @override
  String get channelQualitySd => 'SD';

  @override
  String get playerPlay => 'चलाएँ';

  @override
  String get playerPause => 'रोकें';

  @override
  String get playerFullscreen => 'पूर्ण स्क्रीन';

  @override
  String get playerExitFullscreen => 'पूर्ण स्क्रीन से बाहर';

  @override
  String get playerMute => 'मौन';

  @override
  String get playerUnmute => 'ध्वनि चालू करें';

  @override
  String get playerQuality => 'गुणवत्ता';

  @override
  String get playerLiveLabel => 'लाइव';

  @override
  String get playerLoading => 'स्ट्रीम लोड हो रही है...';

  @override
  String get playerErrorTitle => 'प्लेबैक त्रुटि';

  @override
  String get playerErrorMessage =>
      'यह स्ट्रीम लोड नहीं हो सकी। कृपया दूसरी गुणवत्ता आज़माएँ या बाद में जाँचें।';

  @override
  String get searchPlaceholder => 'चैनल खोजें...';

  @override
  String searchResultsFor(String query) {
    return '\"$query\" के लिए परिणाम';
  }

  @override
  String get searchNoResultsTitle => 'कोई परिणाम नहीं मिला';

  @override
  String get searchNoResultsSubtitle =>
      'कोई अलग खोज शब्द आज़माएँ या श्रेणी के अनुसार ब्राउज़ करें';

  @override
  String get searchRecentSearches => 'हाल की खोजें';

  @override
  String get searchClearRecent => 'साफ़ करें';

  @override
  String get authSignIn => 'साइन इन';

  @override
  String get authSignUp => 'साइन अप';

  @override
  String get authEmail => 'ईमेल';

  @override
  String get authPassword => 'पासवर्ड';

  @override
  String get authConfirmPassword => 'पासवर्ड की पुष्टि करें';

  @override
  String get authGoogleSignIn => 'Google से जारी रखें';

  @override
  String get authForgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get authNoAccount => 'खाता नहीं है?';

  @override
  String get authHaveAccount => 'पहले से खाता है?';

  @override
  String get authContinueAsGuest => 'अतिथि के रूप में जारी रखें';

  @override
  String get authSignInToContinue => 'जारी रखने के लिए साइन इन करें';

  @override
  String get authSignInForFavorites => 'पसंदीदा सहेजने के लिए साइन इन करें';

  @override
  String get authSignInForHistory => 'इतिहास देखने के लिए साइन इन करें';

  @override
  String get authCreateAccount => 'खाता बनाएँ';

  @override
  String get authOrContinueWith => 'या इसके साथ जारी रखें';

  @override
  String get epgNowPlaying => 'अभी चल रहा है';

  @override
  String get epgUpNext => 'आगे';

  @override
  String epgEndsAt(String time) {
    return '$time पर समाप्त';
  }

  @override
  String get epgNoGuideAvailable => 'प्रोग्राम गाइड उपलब्ध नहीं';

  @override
  String get epgTodaysSchedule => 'आज का कार्यक्रम';

  @override
  String get epgNowBadge => 'लाइव';

  @override
  String get epgScheduleCollapsed => 'शेड्यूल दिखाएँ';

  @override
  String get epgScheduleExpanded => 'शेड्यूल छुपाएँ';

  @override
  String get reportTitle => 'स्ट्रीम समस्या रिपोर्ट करें';

  @override
  String get reportReasonOffline => 'स्ट्रीम ऑफ़लाइन है';

  @override
  String get reportReasonGeoBlocked => 'मेरे क्षेत्र में भू-अवरोधित';

  @override
  String get reportReasonPoorQuality => 'खराब वीडियो गुणवत्ता';

  @override
  String get reportReasonWrongContent => 'गलत चैनल सामग्री';

  @override
  String get reportSubmit => 'रिपोर्ट भेजें';

  @override
  String get reportCancel => 'रद्द करें';

  @override
  String get reportThankYou => 'आपकी रिपोर्ट के लिए धन्यवाद!';

  @override
  String get onboardingWhereWatching => 'आप कहाँ से देख रहे हैं?';

  @override
  String get onboardingWhatEnjoy => 'आप क्या देखना पसंद करते हैं?';

  @override
  String get onboardingFreeOrSignin =>
      'मुफ्त में देखें या अधिक के लिए साइन इन करें';

  @override
  String get onboardingSkip => 'छोड़ें';

  @override
  String get onboardingContinueBtn => 'जारी रखें';

  @override
  String get onboardingSelectCountry => 'अपना देश चुनें';

  @override
  String get onboardingSelectCategories => 'अपनी रुचियाँ चुनें';

  @override
  String get errorsSomethingWrong => 'कुछ गलत हो गया';

  @override
  String get errorsStreamUnavailable => 'यह स्ट्रीम वर्तमान में उपलब्ध नहीं है';

  @override
  String get errorsNoInternet => 'इंटरनेट कनेक्शन नहीं है';

  @override
  String get errorsTryAgain => 'कृपया पुनः प्रयास करें';

  @override
  String get errorsNotFound => 'पेज नहीं मिला';

  @override
  String get errorsGoHome => 'होम पर जाएँ';

  @override
  String get errorsServerError =>
      'सर्वर त्रुटि। कृपया बाद में पुनः प्रयास करें।';

  @override
  String get commonLoading => 'लोड हो रहा है...';

  @override
  String get commonError => 'त्रुटि';

  @override
  String get commonRetry => 'पुनः प्रयास';

  @override
  String get commonClose => 'बंद करें';

  @override
  String get commonCancel => 'रद्द करें';

  @override
  String get commonSave => 'सहेजें';

  @override
  String get commonDone => 'हो गया';

  @override
  String get commonBack => 'वापस';

  @override
  String get commonOk => 'ठीक है';

  @override
  String get commonShare => 'साझा करें';

  @override
  String get commonReport => 'रिपोर्ट';

  @override
  String get commonFavorite => 'पसंदीदा';

  @override
  String get commonUnfavorite => 'पसंदीदा हटाएँ';

  @override
  String get commonProBadge => 'PRO';

  @override
  String get commonLiveBadge => 'लाइव';

  @override
  String get commonHdBadge => 'HD';

  @override
  String get commonSdBadge => 'SD';

  @override
  String get commonMore => 'अधिक';

  @override
  String get commonLess => 'कम';

  @override
  String get commonSeeAll => 'सभी देखें';
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navLiveTv => 'التلفزيون المباشر';

  @override
  String get navSearch => 'بحث';

  @override
  String get navFavorites => 'المفضلة';

  @override
  String get navHistory => 'السجل';

  @override
  String get navProfile => 'الملف الشخصي';

  @override
  String get navSignIn => 'تسجيل الدخول';

  @override
  String get navSignOut => 'تسجيل الخروج';

  @override
  String get navSettings => 'الإعدادات';

  @override
  String get homeLiveNow => 'مباشر الآن';

  @override
  String get homeNews => 'أخبار';

  @override
  String get homeSports => 'رياضة';

  @override
  String get homeEntertainment => 'ترفيه';

  @override
  String get homeMusic => 'موسيقى';

  @override
  String get homeMovies => 'أفلام';

  @override
  String get homeSeeAll => 'عرض الكل';

  @override
  String homeChannelsInCountry(String country) {
    return 'قنوات $country';
  }

  @override
  String get homeWatchNow => 'شاهد الآن';

  @override
  String get homeTrendingGlobally => 'الأكثر مشاهدة عالمياً';

  @override
  String get homeFeatured => 'مميز';

  @override
  String get liveAllChannels => 'جميع القنوات';

  @override
  String get liveFilter => 'تصفية';

  @override
  String get liveSort => 'ترتيب';

  @override
  String get liveSearchPlaceholder => 'البحث عن القنوات...';

  @override
  String liveShowingCount(int count) {
    return 'عرض $count قناة';
  }

  @override
  String get liveNoResults => 'لم يتم العثور على قنوات';

  @override
  String get liveLiveOnly => 'المباشر فقط';

  @override
  String get liveAllCountries => 'جميع الدول';

  @override
  String get liveAllCategories => 'جميع الفئات';

  @override
  String get liveAllLanguages => 'جميع اللغات';

  @override
  String get liveSortAz => 'أ إلى ي';

  @override
  String get liveSortPopular => 'الأكثر شيوعاً';

  @override
  String get liveSortCountry => 'حسب الدولة';

  @override
  String get liveLoadMore => 'تحميل المزيد';

  @override
  String liveChannelCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count قناة',
      many: '$count قناة',
      few: '$count قنوات',
      two: 'قناتان',
      one: 'قناة واحدة',
      zero: 'لا توجد قنوات',
    );
    return '$_temp0';
  }

  @override
  String get channelWatchNow => 'شاهد الآن';

  @override
  String get channelAddFavorite => 'أضف إلى المفضلة';

  @override
  String get channelRemoveFavorite => 'إزالة من المفضلة';

  @override
  String get channelReportStream => 'الإبلاغ عن بث';

  @override
  String channelMoreFromCountry(String country) {
    return 'المزيد من $country';
  }

  @override
  String get channelStreamUnavailable => 'البث غير متاح';

  @override
  String get channelTryAnotherQuality => 'جرب جودة أخرى';

  @override
  String get channelRetry => 'إعادة المحاولة';

  @override
  String get channelNowPlaying => 'يُبث الآن';

  @override
  String get channelUpNext => 'التالي';

  @override
  String channelEndsAt(String time) {
    return 'ينتهي في $time';
  }

  @override
  String get channelOfficialWebsite => 'الموقع الرسمي';

  @override
  String get channelQualityAuto => 'تلقائي';

  @override
  String get channelQualityHd => 'جودة عالية';

  @override
  String get channelQualitySd => 'جودة عادية';

  @override
  String get playerPlay => 'تشغيل';

  @override
  String get playerPause => 'إيقاف مؤقت';

  @override
  String get playerFullscreen => 'ملء الشاشة';

  @override
  String get playerExitFullscreen => 'الخروج من ملء الشاشة';

  @override
  String get playerMute => 'كتم الصوت';

  @override
  String get playerUnmute => 'تشغيل الصوت';

  @override
  String get playerQuality => 'الجودة';

  @override
  String get playerLiveLabel => 'مباشر';

  @override
  String get playerLoading => 'جارٍ تحميل البث...';

  @override
  String get playerErrorTitle => 'خطأ في التشغيل';

  @override
  String get playerErrorMessage =>
      'تعذر تحميل هذا البث. يُرجى تجربة جودة أخرى أو المحاولة لاحقاً.';

  @override
  String get searchPlaceholder => 'البحث عن القنوات...';

  @override
  String searchResultsFor(String query) {
    return 'نتائج البحث عن \"$query\"';
  }

  @override
  String get searchNoResultsTitle => 'لا توجد نتائج';

  @override
  String get searchNoResultsSubtitle => 'جرب مصطلح بحث مختلف أو تصفح حسب الفئة';

  @override
  String get searchRecentSearches => 'عمليات البحث الأخيرة';

  @override
  String get searchClearRecent => 'مسح';

  @override
  String get authSignIn => 'تسجيل الدخول';

  @override
  String get authSignUp => 'إنشاء حساب';

  @override
  String get authEmail => 'البريد الإلكتروني';

  @override
  String get authPassword => 'كلمة المرور';

  @override
  String get authConfirmPassword => 'تأكيد كلمة المرور';

  @override
  String get authGoogleSignIn => 'المتابعة مع Google';

  @override
  String get authForgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get authNoAccount => 'ليس لديك حساب؟';

  @override
  String get authHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get authContinueAsGuest => 'المتابعة كضيف';

  @override
  String get authSignInToContinue => 'سجل الدخول للمتابعة';

  @override
  String get authSignInForFavorites => 'سجل الدخول لحفظ المفضلة';

  @override
  String get authSignInForHistory => 'سجل الدخول لعرض سجل المشاهدة';

  @override
  String get authCreateAccount => 'إنشاء حساب';

  @override
  String get authOrContinueWith => 'أو تابع باستخدام';

  @override
  String get epgNowPlaying => 'يُبث الآن';

  @override
  String get epgUpNext => 'التالي';

  @override
  String epgEndsAt(String time) {
    return 'ينتهي $time';
  }

  @override
  String get epgNoGuideAvailable => 'دليل البرامج غير متاح';

  @override
  String get epgTodaysSchedule => 'برنامج اليوم';

  @override
  String get epgNowBadge => 'مباشر';

  @override
  String get epgScheduleCollapsed => 'عرض البرنامج';

  @override
  String get epgScheduleExpanded => 'إخفاء البرنامج';

  @override
  String get reportTitle => 'الإبلاغ عن مشكلة في البث';

  @override
  String get reportReasonOffline => 'البث متوقف';

  @override
  String get reportReasonGeoBlocked => 'محجوب في منطقتي';

  @override
  String get reportReasonPoorQuality => 'جودة فيديو رديئة';

  @override
  String get reportReasonWrongContent => 'محتوى القناة خاطئ';

  @override
  String get reportSubmit => 'إرسال البلاغ';

  @override
  String get reportCancel => 'إلغاء';

  @override
  String get reportThankYou => 'شكراً على بلاغك!';

  @override
  String get onboardingWhereWatching => 'من أين تشاهد؟';

  @override
  String get onboardingWhatEnjoy => 'ماذا تحب أن تشاهد؟';

  @override
  String get onboardingFreeOrSignin => 'شاهد مجاناً أو سجل دخولاً للمزيد';

  @override
  String get onboardingSkip => 'تخطي';

  @override
  String get onboardingContinueBtn => 'متابعة';

  @override
  String get onboardingSelectCountry => 'اختر دولتك';

  @override
  String get onboardingSelectCategories => 'اختر اهتماماتك';

  @override
  String get errorsSomethingWrong => 'حدث خطأ ما';

  @override
  String get errorsStreamUnavailable => 'هذا البث غير متاح حالياً';

  @override
  String get errorsNoInternet => 'لا يوجد اتصال بالإنترنت';

  @override
  String get errorsTryAgain => 'يُرجى المحاولة مرة أخرى';

  @override
  String get errorsNotFound => 'الصفحة غير موجودة';

  @override
  String get errorsGoHome => 'العودة للرئيسية';

  @override
  String get errorsServerError => 'خطأ في الخادم. يُرجى المحاولة لاحقاً.';

  @override
  String get commonLoading => 'جارٍ التحميل...';

  @override
  String get commonError => 'خطأ';

  @override
  String get commonRetry => 'إعادة المحاولة';

  @override
  String get commonClose => 'إغلاق';

  @override
  String get commonCancel => 'إلغاء';

  @override
  String get commonSave => 'حفظ';

  @override
  String get commonDone => 'تم';

  @override
  String get commonBack => 'رجوع';

  @override
  String get commonOk => 'موافق';

  @override
  String get commonShare => 'مشاركة';

  @override
  String get commonReport => 'إبلاغ';

  @override
  String get commonFavorite => 'مفضلة';

  @override
  String get commonUnfavorite => 'إزالة من المفضلة';

  @override
  String get commonProBadge => 'PRO';

  @override
  String get commonLiveBadge => 'مباشر';

  @override
  String get commonHdBadge => 'HD';

  @override
  String get commonSdBadge => 'SD';

  @override
  String get commonMore => 'المزيد';

  @override
  String get commonLess => 'أقل';

  @override
  String get commonSeeAll => 'عرض الكل';
}

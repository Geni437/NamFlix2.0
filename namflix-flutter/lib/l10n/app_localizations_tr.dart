// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get navHome => 'Ana Sayfa';

  @override
  String get navLiveTv => 'Canlı TV';

  @override
  String get navSearch => 'Ara';

  @override
  String get navFavorites => 'Favoriler';

  @override
  String get navHistory => 'Geçmiş';

  @override
  String get navProfile => 'Profil';

  @override
  String get navSignIn => 'Giriş Yap';

  @override
  String get navSignOut => 'Çıkış Yap';

  @override
  String get navSettings => 'Ayarlar';

  @override
  String get homeLiveNow => 'Şu An Canlı';

  @override
  String get homeNews => 'Haberler';

  @override
  String get homeSports => 'Spor';

  @override
  String get homeEntertainment => 'Eğlence';

  @override
  String get homeMusic => 'Müzik';

  @override
  String get homeMovies => 'Filmler';

  @override
  String get homeSeeAll => 'Tümünü Gör';

  @override
  String homeChannelsInCountry(String country) {
    return '$country Kanalları';
  }

  @override
  String get homeWatchNow => 'Şimdi İzle';

  @override
  String get homeTrendingGlobally => 'Dünya Genelinde Trend';

  @override
  String get homeFeatured => 'Öne Çıkan';

  @override
  String get liveAllChannels => 'Tüm Kanallar';

  @override
  String get liveFilter => 'Filtrele';

  @override
  String get liveSort => 'Sırala';

  @override
  String get liveSearchPlaceholder => 'Kanal ara...';

  @override
  String liveShowingCount(int count) {
    return '$count kanal gösteriliyor';
  }

  @override
  String get liveNoResults => 'Kanal bulunamadı';

  @override
  String get liveLiveOnly => 'Yalnızca Canlı';

  @override
  String get liveAllCountries => 'Tüm Ülkeler';

  @override
  String get liveAllCategories => 'Tüm Kategoriler';

  @override
  String get liveAllLanguages => 'Tüm Diller';

  @override
  String get liveSortAz => 'A\'dan Z\'ye';

  @override
  String get liveSortPopular => 'En Popüler';

  @override
  String get liveSortCountry => 'Ülkeye Göre';

  @override
  String get liveLoadMore => 'Daha Fazla Yükle';

  @override
  String liveChannelCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kanal',
      one: '1 kanal',
      zero: 'Kanal yok',
    );
    return '$_temp0';
  }

  @override
  String get channelWatchNow => 'Şimdi İzle';

  @override
  String get channelAddFavorite => 'Favorilere Ekle';

  @override
  String get channelRemoveFavorite => 'Favorilerden Çıkar';

  @override
  String get channelReportStream => 'Yayını Bildir';

  @override
  String channelMoreFromCountry(String country) {
    return '$country\'dan Daha Fazla';
  }

  @override
  String get channelStreamUnavailable => 'Yayın Kullanılamıyor';

  @override
  String get channelTryAnotherQuality => 'Başka Kalite Dene';

  @override
  String get channelRetry => 'Yeniden Dene';

  @override
  String get channelNowPlaying => 'Şu An Yayında';

  @override
  String get channelUpNext => 'Sıradaki';

  @override
  String channelEndsAt(String time) {
    return '$time\'da Bitiyor';
  }

  @override
  String get channelOfficialWebsite => 'Resmi Web Sitesi';

  @override
  String get channelQualityAuto => 'Otomatik';

  @override
  String get channelQualityHd => 'HD';

  @override
  String get channelQualitySd => 'SD';

  @override
  String get playerPlay => 'Oynat';

  @override
  String get playerPause => 'Duraklat';

  @override
  String get playerFullscreen => 'Tam Ekran';

  @override
  String get playerExitFullscreen => 'Tam Ekrandan Çık';

  @override
  String get playerMute => 'Sesi Kapat';

  @override
  String get playerUnmute => 'Sesi Aç';

  @override
  String get playerQuality => 'Kalite';

  @override
  String get playerLiveLabel => 'CANLI';

  @override
  String get playerLoading => 'Yayın yükleniyor...';

  @override
  String get playerErrorTitle => 'Oynatma Hatası';

  @override
  String get playerErrorMessage =>
      'Bu yayın yüklenemedi. Başka bir kalite deneyin veya daha sonra tekrar kontrol edin.';

  @override
  String get searchPlaceholder => 'Kanal ara...';

  @override
  String searchResultsFor(String query) {
    return '\"$query\" için sonuçlar';
  }

  @override
  String get searchNoResultsTitle => 'Sonuç Bulunamadı';

  @override
  String get searchNoResultsSubtitle =>
      'Farklı bir arama terimi deneyin veya kategoriye göre göz atın';

  @override
  String get searchRecentSearches => 'Son Aramalar';

  @override
  String get searchClearRecent => 'Temizle';

  @override
  String get authSignIn => 'Giriş Yap';

  @override
  String get authSignUp => 'Kayıt Ol';

  @override
  String get authEmail => 'E-posta';

  @override
  String get authPassword => 'Şifre';

  @override
  String get authConfirmPassword => 'Şifreyi Onayla';

  @override
  String get authGoogleSignIn => 'Google ile Devam Et';

  @override
  String get authForgotPassword => 'Şifremi Unuttum?';

  @override
  String get authNoAccount => 'Hesabın yok mu?';

  @override
  String get authHaveAccount => 'Zaten hesabın var mı?';

  @override
  String get authContinueAsGuest => 'Misafir Olarak Devam Et';

  @override
  String get authSignInToContinue => 'Devam etmek için giriş yap';

  @override
  String get authSignInForFavorites => 'Favorileri kaydetmek için giriş yap';

  @override
  String get authSignInForHistory => 'Geçmişi görmek için giriş yap';

  @override
  String get authCreateAccount => 'Hesap Oluştur';

  @override
  String get authOrContinueWith => 'veya şununla devam et';

  @override
  String get epgNowPlaying => 'Şu An Yayında';

  @override
  String get epgUpNext => 'Sıradaki';

  @override
  String epgEndsAt(String time) {
    return '$time\'da Bitiyor';
  }

  @override
  String get epgNoGuideAvailable => 'Program rehberi mevcut değil';

  @override
  String get epgTodaysSchedule => 'Bugünün Programı';

  @override
  String get epgNowBadge => 'CANLI';

  @override
  String get epgScheduleCollapsed => 'Programı Göster';

  @override
  String get epgScheduleExpanded => 'Programı Gizle';

  @override
  String get reportTitle => 'Yayın Sorununu Bildir';

  @override
  String get reportReasonOffline => 'Yayın çevrimdışı';

  @override
  String get reportReasonGeoBlocked => 'Bölgemde coğrafi engel var';

  @override
  String get reportReasonPoorQuality => 'Kötü video kalitesi';

  @override
  String get reportReasonWrongContent => 'Yanlış kanal içeriği';

  @override
  String get reportSubmit => 'Bildiri Gönder';

  @override
  String get reportCancel => 'İptal';

  @override
  String get reportThankYou => 'Bildiriminiz için teşekkürler!';

  @override
  String get onboardingWhereWatching => 'Nereden izliyorsunuz?';

  @override
  String get onboardingWhatEnjoy => 'Ne izlemeyi seviyorsunuz?';

  @override
  String get onboardingFreeOrSignin =>
      'Ücretsiz izleyin veya daha fazlası için giriş yapın';

  @override
  String get onboardingSkip => 'Atla';

  @override
  String get onboardingContinueBtn => 'Devam Et';

  @override
  String get onboardingSelectCountry => 'Ülkenizi seçin';

  @override
  String get onboardingSelectCategories => 'İlgi alanlarınızı seçin';

  @override
  String get errorsSomethingWrong => 'Bir şeyler yanlış gitti';

  @override
  String get errorsStreamUnavailable => 'Bu yayın şu anda kullanılamıyor';

  @override
  String get errorsNoInternet => 'İnternet bağlantısı yok';

  @override
  String get errorsTryAgain => 'Lütfen tekrar deneyin';

  @override
  String get errorsNotFound => 'Sayfa bulunamadı';

  @override
  String get errorsGoHome => 'Ana Sayfaya Git';

  @override
  String get errorsServerError =>
      'Sunucu hatası. Lütfen daha sonra tekrar deneyin.';

  @override
  String get commonLoading => 'Yükleniyor...';

  @override
  String get commonError => 'Hata';

  @override
  String get commonRetry => 'Yeniden Dene';

  @override
  String get commonClose => 'Kapat';

  @override
  String get commonCancel => 'İptal';

  @override
  String get commonSave => 'Kaydet';

  @override
  String get commonDone => 'Tamam';

  @override
  String get commonBack => 'Geri';

  @override
  String get commonOk => 'Tamam';

  @override
  String get commonShare => 'Paylaş';

  @override
  String get commonReport => 'Bildir';

  @override
  String get commonFavorite => 'Favori';

  @override
  String get commonUnfavorite => 'Favoriden Çıkar';

  @override
  String get commonProBadge => 'PRO';

  @override
  String get commonLiveBadge => 'CANLI';

  @override
  String get commonHdBadge => 'HD';

  @override
  String get commonSdBadge => 'SD';

  @override
  String get commonMore => 'Daha Fazla';

  @override
  String get commonLess => 'Daha Az';

  @override
  String get commonSeeAll => 'Tümünü Gör';
}

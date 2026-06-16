// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get navHome => 'Beranda';

  @override
  String get navLiveTv => 'TV Langsung';

  @override
  String get navSearch => 'Cari';

  @override
  String get navFavorites => 'Favorit';

  @override
  String get navHistory => 'Riwayat';

  @override
  String get navProfile => 'Profil';

  @override
  String get navSignIn => 'Masuk';

  @override
  String get navSignOut => 'Keluar';

  @override
  String get navSettings => 'Pengaturan';

  @override
  String get homeLiveNow => 'Siaran Langsung';

  @override
  String get homeNews => 'Berita';

  @override
  String get homeSports => 'Olahraga';

  @override
  String get homeEntertainment => 'Hiburan';

  @override
  String get homeMusic => 'Musik';

  @override
  String get homeMovies => 'Film';

  @override
  String get homeSeeAll => 'Lihat Semua';

  @override
  String homeChannelsInCountry(String country) {
    return 'Saluran dari $country';
  }

  @override
  String get homeWatchNow => 'Tonton Sekarang';

  @override
  String get homeTrendingGlobally => 'Trending Global';

  @override
  String get homeFeatured => 'Unggulan';

  @override
  String get liveAllChannels => 'Semua Saluran';

  @override
  String get liveFilter => 'Filter';

  @override
  String get liveSort => 'Urutkan';

  @override
  String get liveSearchPlaceholder => 'Cari saluran...';

  @override
  String liveShowingCount(int count) {
    return 'Menampilkan $count saluran';
  }

  @override
  String get liveNoResults => 'Tidak ada saluran ditemukan';

  @override
  String get liveLiveOnly => 'Siaran Langsung Saja';

  @override
  String get liveAllCountries => 'Semua Negara';

  @override
  String get liveAllCategories => 'Semua Kategori';

  @override
  String get liveAllLanguages => 'Semua Bahasa';

  @override
  String get liveSortAz => 'A hingga Z';

  @override
  String get liveSortPopular => 'Paling Populer';

  @override
  String get liveSortCountry => 'Berdasarkan Negara';

  @override
  String get liveLoadMore => 'Muat Lebih Banyak';

  @override
  String liveChannelCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count saluran',
      one: '1 saluran',
      zero: 'Tidak ada saluran',
    );
    return '$_temp0';
  }

  @override
  String get channelWatchNow => 'Tonton Sekarang';

  @override
  String get channelAddFavorite => 'Tambahkan ke Favorit';

  @override
  String get channelRemoveFavorite => 'Hapus dari Favorit';

  @override
  String get channelReportStream => 'Laporkan Siaran';

  @override
  String channelMoreFromCountry(String country) {
    return 'Lebih banyak dari $country';
  }

  @override
  String get channelStreamUnavailable => 'Siaran Tidak Tersedia';

  @override
  String get channelTryAnotherQuality => 'Coba Kualitas Lain';

  @override
  String get channelRetry => 'Coba Lagi';

  @override
  String get channelNowPlaying => 'Sedang Diputar';

  @override
  String get channelUpNext => 'Berikutnya';

  @override
  String channelEndsAt(String time) {
    return 'Berakhir pada $time';
  }

  @override
  String get channelOfficialWebsite => 'Situs Resmi';

  @override
  String get channelQualityAuto => 'Otomatis';

  @override
  String get channelQualityHd => 'HD';

  @override
  String get channelQualitySd => 'SD';

  @override
  String get playerPlay => 'Putar';

  @override
  String get playerPause => 'Jeda';

  @override
  String get playerFullscreen => 'Layar Penuh';

  @override
  String get playerExitFullscreen => 'Keluar Layar Penuh';

  @override
  String get playerMute => 'Bisukan';

  @override
  String get playerUnmute => 'Aktifkan Suara';

  @override
  String get playerQuality => 'Kualitas';

  @override
  String get playerLiveLabel => 'LANGSUNG';

  @override
  String get playerLoading => 'Memuat siaran...';

  @override
  String get playerErrorTitle => 'Kesalahan Pemutaran';

  @override
  String get playerErrorMessage =>
      'Siaran ini tidak dapat dimuat. Coba kualitas lain atau periksa kembali nanti.';

  @override
  String get searchPlaceholder => 'Cari saluran...';

  @override
  String searchResultsFor(String query) {
    return 'Hasil untuk \"$query\"';
  }

  @override
  String get searchNoResultsTitle => 'Tidak Ada Hasil';

  @override
  String get searchNoResultsSubtitle =>
      'Coba kata kunci berbeda atau telusuri berdasarkan kategori';

  @override
  String get searchRecentSearches => 'Pencarian Terbaru';

  @override
  String get searchClearRecent => 'Hapus';

  @override
  String get authSignIn => 'Masuk';

  @override
  String get authSignUp => 'Daftar';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Kata Sandi';

  @override
  String get authConfirmPassword => 'Konfirmasi Kata Sandi';

  @override
  String get authGoogleSignIn => 'Lanjutkan dengan Google';

  @override
  String get authForgotPassword => 'Lupa Kata Sandi?';

  @override
  String get authNoAccount => 'Belum punya akun?';

  @override
  String get authHaveAccount => 'Sudah punya akun?';

  @override
  String get authContinueAsGuest => 'Lanjutkan sebagai Tamu';

  @override
  String get authSignInToContinue => 'Masuk untuk melanjutkan';

  @override
  String get authSignInForFavorites => 'Masuk untuk menyimpan favorit';

  @override
  String get authSignInForHistory => 'Masuk untuk melihat riwayat';

  @override
  String get authCreateAccount => 'Buat Akun';

  @override
  String get authOrContinueWith => 'atau lanjutkan dengan';

  @override
  String get epgNowPlaying => 'Sedang Diputar';

  @override
  String get epgUpNext => 'Berikutnya';

  @override
  String epgEndsAt(String time) {
    return 'Berakhir $time';
  }

  @override
  String get epgNoGuideAvailable => 'Panduan program tidak tersedia';

  @override
  String get epgTodaysSchedule => 'Jadwal Hari Ini';

  @override
  String get epgNowBadge => 'LANGSUNG';

  @override
  String get epgScheduleCollapsed => 'Tampilkan Jadwal';

  @override
  String get epgScheduleExpanded => 'Sembunyikan Jadwal';

  @override
  String get reportTitle => 'Laporkan Masalah Siaran';

  @override
  String get reportReasonOffline => 'Siaran sedang offline';

  @override
  String get reportReasonGeoBlocked => 'Diblokir di wilayah saya';

  @override
  String get reportReasonPoorQuality => 'Kualitas video buruk';

  @override
  String get reportReasonWrongContent => 'Konten saluran salah';

  @override
  String get reportSubmit => 'Kirim Laporan';

  @override
  String get reportCancel => 'Batal';

  @override
  String get reportThankYou => 'Terima kasih atas laporan Anda!';

  @override
  String get onboardingWhereWatching => 'Dari mana Anda menonton?';

  @override
  String get onboardingWhatEnjoy => 'Apa yang Anda sukai?';

  @override
  String get onboardingFreeOrSignin =>
      'Tonton gratis atau masuk untuk lebih banyak';

  @override
  String get onboardingSkip => 'Lewati';

  @override
  String get onboardingContinueBtn => 'Lanjutkan';

  @override
  String get onboardingSelectCountry => 'Pilih negara Anda';

  @override
  String get onboardingSelectCategories => 'Pilih minat Anda';

  @override
  String get errorsSomethingWrong => 'Terjadi kesalahan';

  @override
  String get errorsStreamUnavailable => 'Siaran ini sedang tidak tersedia';

  @override
  String get errorsNoInternet => 'Tidak ada koneksi internet';

  @override
  String get errorsTryAgain => 'Silakan coba lagi';

  @override
  String get errorsNotFound => 'Halaman tidak ditemukan';

  @override
  String get errorsGoHome => 'Ke Beranda';

  @override
  String get errorsServerError => 'Kesalahan server. Silakan coba lagi nanti.';

  @override
  String get commonLoading => 'Memuat...';

  @override
  String get commonError => 'Kesalahan';

  @override
  String get commonRetry => 'Coba Lagi';

  @override
  String get commonClose => 'Tutup';

  @override
  String get commonCancel => 'Batal';

  @override
  String get commonSave => 'Simpan';

  @override
  String get commonDone => 'Selesai';

  @override
  String get commonBack => 'Kembali';

  @override
  String get commonOk => 'OK';

  @override
  String get commonShare => 'Bagikan';

  @override
  String get commonReport => 'Laporkan';

  @override
  String get commonFavorite => 'Favorit';

  @override
  String get commonUnfavorite => 'Hapus Favorit';

  @override
  String get commonProBadge => 'PRO';

  @override
  String get commonLiveBadge => 'LANGSUNG';

  @override
  String get commonHdBadge => 'HD';

  @override
  String get commonSdBadge => 'SD';

  @override
  String get commonMore => 'Lebih';

  @override
  String get commonLess => 'Kurang';

  @override
  String get commonSeeAll => 'Lihat Semua';
}

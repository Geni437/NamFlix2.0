// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get navHome => 'Startseite';

  @override
  String get navLiveTv => 'Live-TV';

  @override
  String get navSearch => 'Suchen';

  @override
  String get navFavorites => 'Favoriten';

  @override
  String get navHistory => 'Verlauf';

  @override
  String get navProfile => 'Profil';

  @override
  String get navSignIn => 'Anmelden';

  @override
  String get navSignOut => 'Abmelden';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get homeLiveNow => 'Jetzt live';

  @override
  String get homeNews => 'Nachrichten';

  @override
  String get homeSports => 'Sport';

  @override
  String get homeEntertainment => 'Unterhaltung';

  @override
  String get homeMusic => 'Musik';

  @override
  String get homeMovies => 'Filme';

  @override
  String get homeSeeAll => 'Alle anzeigen';

  @override
  String homeChannelsInCountry(String country) {
    return 'Sender aus $country';
  }

  @override
  String get homeWatchNow => 'Jetzt ansehen';

  @override
  String get homeTrendingGlobally => 'Weltweit im Trend';

  @override
  String get homeFeatured => 'Empfohlen';

  @override
  String get liveAllChannels => 'Alle Sender';

  @override
  String get liveFilter => 'Filtern';

  @override
  String get liveSort => 'Sortieren';

  @override
  String get liveSearchPlaceholder => 'Sender suchen...';

  @override
  String liveShowingCount(int count) {
    return '$count Sender werden angezeigt';
  }

  @override
  String get liveNoResults => 'Keine Sender gefunden';

  @override
  String get liveLiveOnly => 'Nur live';

  @override
  String get liveAllCountries => 'Alle Länder';

  @override
  String get liveAllCategories => 'Alle Kategorien';

  @override
  String get liveAllLanguages => 'Alle Sprachen';

  @override
  String get liveSortAz => 'A bis Z';

  @override
  String get liveSortPopular => 'Beliebteste';

  @override
  String get liveSortCountry => 'Nach Land';

  @override
  String get liveLoadMore => 'Mehr laden';

  @override
  String liveChannelCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Sender',
      one: '1 Sender',
      zero: 'Keine Sender',
    );
    return '$_temp0';
  }

  @override
  String get channelWatchNow => 'Jetzt ansehen';

  @override
  String get channelAddFavorite => 'Zu Favoriten hinzufügen';

  @override
  String get channelRemoveFavorite => 'Aus Favoriten entfernen';

  @override
  String get channelReportStream => 'Stream melden';

  @override
  String channelMoreFromCountry(String country) {
    return 'Mehr aus $country';
  }

  @override
  String get channelStreamUnavailable => 'Stream nicht verfügbar';

  @override
  String get channelTryAnotherQuality => 'Andere Qualität versuchen';

  @override
  String get channelRetry => 'Erneut versuchen';

  @override
  String get channelNowPlaying => 'Jetzt läuft';

  @override
  String get channelUpNext => 'Als Nächstes';

  @override
  String channelEndsAt(String time) {
    return 'Endet um $time';
  }

  @override
  String get channelOfficialWebsite => 'Offizielle Website';

  @override
  String get channelQualityAuto => 'Auto';

  @override
  String get channelQualityHd => 'HD';

  @override
  String get channelQualitySd => 'SD';

  @override
  String get playerPlay => 'Abspielen';

  @override
  String get playerPause => 'Pausieren';

  @override
  String get playerFullscreen => 'Vollbild';

  @override
  String get playerExitFullscreen => 'Vollbild verlassen';

  @override
  String get playerMute => 'Stummschalten';

  @override
  String get playerUnmute => 'Ton einschalten';

  @override
  String get playerQuality => 'Qualität';

  @override
  String get playerLiveLabel => 'LIVE';

  @override
  String get playerLoading => 'Stream wird geladen...';

  @override
  String get playerErrorTitle => 'Wiedergabefehler';

  @override
  String get playerErrorMessage =>
      'Dieser Stream konnte nicht geladen werden. Versuche eine andere Qualität oder komme später zurück.';

  @override
  String get searchPlaceholder => 'Sender suchen...';

  @override
  String searchResultsFor(String query) {
    return 'Ergebnisse für \"$query\"';
  }

  @override
  String get searchNoResultsTitle => 'Keine Ergebnisse gefunden';

  @override
  String get searchNoResultsSubtitle =>
      'Versuche einen anderen Suchbegriff oder browse nach Kategorie';

  @override
  String get searchRecentSearches => 'Letzte Suchen';

  @override
  String get searchClearRecent => 'Löschen';

  @override
  String get authSignIn => 'Anmelden';

  @override
  String get authSignUp => 'Registrieren';

  @override
  String get authEmail => 'E-Mail';

  @override
  String get authPassword => 'Passwort';

  @override
  String get authConfirmPassword => 'Passwort bestätigen';

  @override
  String get authGoogleSignIn => 'Mit Google fortfahren';

  @override
  String get authForgotPassword => 'Passwort vergessen?';

  @override
  String get authNoAccount => 'Noch kein Konto?';

  @override
  String get authHaveAccount => 'Bereits ein Konto?';

  @override
  String get authContinueAsGuest => 'Als Gast fortfahren';

  @override
  String get authSignInToContinue => 'Melde dich an, um fortzufahren';

  @override
  String get authSignInForFavorites =>
      'Melde dich an, um Favoriten zu speichern';

  @override
  String get authSignInForHistory =>
      'Melde dich an, um deinen Verlauf zu sehen';

  @override
  String get authCreateAccount => 'Konto erstellen';

  @override
  String get authOrContinueWith => 'oder fortfahren mit';

  @override
  String get epgNowPlaying => 'Jetzt läuft';

  @override
  String get epgUpNext => 'Als Nächstes';

  @override
  String epgEndsAt(String time) {
    return 'Endet um $time';
  }

  @override
  String get epgNoGuideAvailable => 'Programmführer nicht verfügbar';

  @override
  String get epgTodaysSchedule => 'Heutiges Programm';

  @override
  String get epgNowBadge => 'LIVE';

  @override
  String get epgScheduleCollapsed => 'Programm anzeigen';

  @override
  String get epgScheduleExpanded => 'Programm ausblenden';

  @override
  String get reportTitle => 'Stream-Problem melden';

  @override
  String get reportReasonOffline => 'Stream ist offline';

  @override
  String get reportReasonGeoBlocked => 'In meiner Region gesperrt';

  @override
  String get reportReasonPoorQuality => 'Schlechte Videoqualität';

  @override
  String get reportReasonWrongContent => 'Falscher Kanalinhalt';

  @override
  String get reportSubmit => 'Meldung senden';

  @override
  String get reportCancel => 'Abbrechen';

  @override
  String get reportThankYou => 'Danke für deine Meldung!';

  @override
  String get onboardingWhereWatching => 'Von wo schaust du?';

  @override
  String get onboardingWhatEnjoy => 'Was schaust du gerne?';

  @override
  String get onboardingFreeOrSignin =>
      'Kostenlos schauen oder anmelden für mehr';

  @override
  String get onboardingSkip => 'Überspringen';

  @override
  String get onboardingContinueBtn => 'Weiter';

  @override
  String get onboardingSelectCountry => 'Wähle dein Land';

  @override
  String get onboardingSelectCategories => 'Wähle deine Interessen';

  @override
  String get errorsSomethingWrong => 'Etwas ist schiefgelaufen';

  @override
  String get errorsStreamUnavailable =>
      'Dieser Stream ist derzeit nicht verfügbar';

  @override
  String get errorsNoInternet => 'Keine Internetverbindung';

  @override
  String get errorsTryAgain => 'Bitte versuche es erneut';

  @override
  String get errorsNotFound => 'Seite nicht gefunden';

  @override
  String get errorsGoHome => 'Zur Startseite';

  @override
  String get errorsServerError =>
      'Serverfehler. Bitte versuche es später erneut.';

  @override
  String get commonLoading => 'Lädt...';

  @override
  String get commonError => 'Fehler';

  @override
  String get commonRetry => 'Erneut versuchen';

  @override
  String get commonClose => 'Schließen';

  @override
  String get commonCancel => 'Abbrechen';

  @override
  String get commonSave => 'Speichern';

  @override
  String get commonDone => 'Fertig';

  @override
  String get commonBack => 'Zurück';

  @override
  String get commonOk => 'OK';

  @override
  String get commonShare => 'Teilen';

  @override
  String get commonReport => 'Melden';

  @override
  String get commonFavorite => 'Favorit';

  @override
  String get commonUnfavorite => 'Favorit entfernen';

  @override
  String get commonProBadge => 'PRO';

  @override
  String get commonLiveBadge => 'LIVE';

  @override
  String get commonHdBadge => 'HD';

  @override
  String get commonSdBadge => 'SD';

  @override
  String get commonMore => 'Mehr';

  @override
  String get commonLess => 'Weniger';

  @override
  String get commonSeeAll => 'Alle anzeigen';
}

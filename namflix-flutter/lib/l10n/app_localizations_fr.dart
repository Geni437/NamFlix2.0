// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get navHome => 'Accueil';

  @override
  String get navLiveTv => 'TV en direct';

  @override
  String get navSearch => 'Rechercher';

  @override
  String get navFavorites => 'Favoris';

  @override
  String get navHistory => 'Historique';

  @override
  String get navProfile => 'Profil';

  @override
  String get navSignIn => 'Connexion';

  @override
  String get navSignOut => 'Déconnexion';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get homeLiveNow => 'En direct maintenant';

  @override
  String get homeNews => 'Actualités';

  @override
  String get homeSports => 'Sports';

  @override
  String get homeEntertainment => 'Divertissement';

  @override
  String get homeMusic => 'Musique';

  @override
  String get homeMovies => 'Films';

  @override
  String get homeSeeAll => 'Voir tout';

  @override
  String homeChannelsInCountry(String country) {
    return 'Chaînes de $country';
  }

  @override
  String get homeWatchNow => 'Regarder';

  @override
  String get homeTrendingGlobally => 'Tendances mondiales';

  @override
  String get homeFeatured => 'À la une';

  @override
  String get liveAllChannels => 'Toutes les chaînes';

  @override
  String get liveFilter => 'Filtrer';

  @override
  String get liveSort => 'Trier';

  @override
  String get liveSearchPlaceholder => 'Rechercher des chaînes...';

  @override
  String liveShowingCount(int count) {
    return '$count chaînes affichées';
  }

  @override
  String get liveNoResults => 'Aucune chaîne trouvée';

  @override
  String get liveLiveOnly => 'En direct uniquement';

  @override
  String get liveAllCountries => 'Tous les pays';

  @override
  String get liveAllCategories => 'Toutes les catégories';

  @override
  String get liveAllLanguages => 'Toutes les langues';

  @override
  String get liveSortAz => 'A à Z';

  @override
  String get liveSortPopular => 'Plus populaires';

  @override
  String get liveSortCountry => 'Par pays';

  @override
  String get liveLoadMore => 'Charger plus';

  @override
  String liveChannelCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chaînes',
      one: '1 chaîne',
      zero: 'Aucune chaîne',
    );
    return '$_temp0';
  }

  @override
  String get channelWatchNow => 'Regarder';

  @override
  String get channelAddFavorite => 'Ajouter aux favoris';

  @override
  String get channelRemoveFavorite => 'Retirer des favoris';

  @override
  String get channelReportStream => 'Signaler le flux';

  @override
  String channelMoreFromCountry(String country) {
    return 'Plus de $country';
  }

  @override
  String get channelStreamUnavailable => 'Flux indisponible';

  @override
  String get channelTryAnotherQuality => 'Essayer une autre qualité';

  @override
  String get channelRetry => 'Réessayer';

  @override
  String get channelNowPlaying => 'En cours';

  @override
  String get channelUpNext => 'Ensuite';

  @override
  String channelEndsAt(String time) {
    return 'Fin à $time';
  }

  @override
  String get channelOfficialWebsite => 'Site officiel';

  @override
  String get channelQualityAuto => 'Auto';

  @override
  String get channelQualityHd => 'HD';

  @override
  String get channelQualitySd => 'SD';

  @override
  String get playerPlay => 'Lecture';

  @override
  String get playerPause => 'Pause';

  @override
  String get playerFullscreen => 'Plein écran';

  @override
  String get playerExitFullscreen => 'Quitter le plein écran';

  @override
  String get playerMute => 'Couper le son';

  @override
  String get playerUnmute => 'Activer le son';

  @override
  String get playerQuality => 'Qualité';

  @override
  String get playerLiveLabel => 'EN DIRECT';

  @override
  String get playerLoading => 'Chargement du flux...';

  @override
  String get playerErrorTitle => 'Erreur de lecture';

  @override
  String get playerErrorMessage =>
      'Ce flux n\'a pas pu être chargé. Essayez une autre qualité ou revenez plus tard.';

  @override
  String get searchPlaceholder => 'Rechercher des chaînes...';

  @override
  String searchResultsFor(String query) {
    return 'Résultats pour \"$query\"';
  }

  @override
  String get searchNoResultsTitle => 'Aucun résultat';

  @override
  String get searchNoResultsSubtitle =>
      'Essayez un autre terme ou parcourez par catégorie';

  @override
  String get searchRecentSearches => 'Recherches récentes';

  @override
  String get searchClearRecent => 'Effacer';

  @override
  String get authSignIn => 'Connexion';

  @override
  String get authSignUp => 'Inscription';

  @override
  String get authEmail => 'E-mail';

  @override
  String get authPassword => 'Mot de passe';

  @override
  String get authConfirmPassword => 'Confirmer le mot de passe';

  @override
  String get authGoogleSignIn => 'Continuer avec Google';

  @override
  String get authForgotPassword => 'Mot de passe oublié ?';

  @override
  String get authNoAccount => 'Pas de compte ?';

  @override
  String get authHaveAccount => 'Déjà un compte ?';

  @override
  String get authContinueAsGuest => 'Continuer en tant qu\'invité';

  @override
  String get authSignInToContinue => 'Connectez-vous pour continuer';

  @override
  String get authSignInForFavorites =>
      'Connectez-vous pour sauvegarder vos favoris';

  @override
  String get authSignInForHistory =>
      'Connectez-vous pour voir votre historique';

  @override
  String get authCreateAccount => 'Créer un compte';

  @override
  String get authOrContinueWith => 'ou continuer avec';

  @override
  String get epgNowPlaying => 'En cours';

  @override
  String get epgUpNext => 'Ensuite';

  @override
  String epgEndsAt(String time) {
    return 'Fin à $time';
  }

  @override
  String get epgNoGuideAvailable => 'Guide des programmes non disponible';

  @override
  String get epgTodaysSchedule => 'Programme du jour';

  @override
  String get epgNowBadge => 'DIRECT';

  @override
  String get epgScheduleCollapsed => 'Afficher le programme';

  @override
  String get epgScheduleExpanded => 'Masquer le programme';

  @override
  String get reportTitle => 'Signaler un problème';

  @override
  String get reportReasonOffline => 'Le flux est hors ligne';

  @override
  String get reportReasonGeoBlocked => 'Bloqué dans ma région';

  @override
  String get reportReasonPoorQuality => 'Mauvaise qualité vidéo';

  @override
  String get reportReasonWrongContent => 'Contenu de chaîne incorrect';

  @override
  String get reportSubmit => 'Envoyer';

  @override
  String get reportCancel => 'Annuler';

  @override
  String get reportThankYou => 'Merci pour votre signalement !';

  @override
  String get onboardingWhereWatching => 'D\'où regardez-vous ?';

  @override
  String get onboardingWhatEnjoy => 'Qu\'aimez-vous regarder ?';

  @override
  String get onboardingFreeOrSignin =>
      'Regardez gratuitement ou connectez-vous pour plus';

  @override
  String get onboardingSkip => 'Ignorer';

  @override
  String get onboardingContinueBtn => 'Continuer';

  @override
  String get onboardingSelectCountry => 'Sélectionnez votre pays';

  @override
  String get onboardingSelectCategories => 'Sélectionnez vos intérêts';

  @override
  String get errorsSomethingWrong => 'Une erreur s\'est produite';

  @override
  String get errorsStreamUnavailable => 'Ce flux est actuellement indisponible';

  @override
  String get errorsNoInternet => 'Pas de connexion internet';

  @override
  String get errorsTryAgain => 'Veuillez réessayer';

  @override
  String get errorsNotFound => 'Page introuvable';

  @override
  String get errorsGoHome => 'Aller à l\'accueil';

  @override
  String get errorsServerError =>
      'Erreur serveur. Veuillez réessayer plus tard.';

  @override
  String get commonLoading => 'Chargement...';

  @override
  String get commonError => 'Erreur';

  @override
  String get commonRetry => 'Réessayer';

  @override
  String get commonClose => 'Fermer';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonSave => 'Enregistrer';

  @override
  String get commonDone => 'Terminé';

  @override
  String get commonBack => 'Retour';

  @override
  String get commonOk => 'OK';

  @override
  String get commonShare => 'Partager';

  @override
  String get commonReport => 'Signaler';

  @override
  String get commonFavorite => 'Favori';

  @override
  String get commonUnfavorite => 'Retirer des favoris';

  @override
  String get commonProBadge => 'PRO';

  @override
  String get commonLiveBadge => 'DIRECT';

  @override
  String get commonHdBadge => 'HD';

  @override
  String get commonSdBadge => 'SD';

  @override
  String get commonMore => 'Plus';

  @override
  String get commonLess => 'Moins';

  @override
  String get commonSeeAll => 'Voir tout';
}

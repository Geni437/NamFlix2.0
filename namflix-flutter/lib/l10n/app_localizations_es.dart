// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get navHome => 'Inicio';

  @override
  String get navLiveTv => 'TV en Vivo';

  @override
  String get navSearch => 'Buscar';

  @override
  String get navFavorites => 'Favoritos';

  @override
  String get navHistory => 'Historial';

  @override
  String get navProfile => 'Perfil';

  @override
  String get navSignIn => 'Iniciar sesión';

  @override
  String get navSignOut => 'Cerrar sesión';

  @override
  String get navSettings => 'Configuración';

  @override
  String get homeLiveNow => 'En Vivo Ahora';

  @override
  String get homeNews => 'Noticias';

  @override
  String get homeSports => 'Deportes';

  @override
  String get homeEntertainment => 'Entretenimiento';

  @override
  String get homeMusic => 'Música';

  @override
  String get homeMovies => 'Películas';

  @override
  String get homeSeeAll => 'Ver todo';

  @override
  String homeChannelsInCountry(String country) {
    return 'Canales de $country';
  }

  @override
  String get homeWatchNow => 'Ver ahora';

  @override
  String get homeTrendingGlobally => 'Tendencias mundiales';

  @override
  String get homeFeatured => 'Destacado';

  @override
  String get liveAllChannels => 'Todos los canales';

  @override
  String get liveFilter => 'Filtrar';

  @override
  String get liveSort => 'Ordenar';

  @override
  String get liveSearchPlaceholder => 'Buscar canales...';

  @override
  String liveShowingCount(int count) {
    return 'Mostrando $count canales';
  }

  @override
  String get liveNoResults => 'No se encontraron canales';

  @override
  String get liveLiveOnly => 'Solo en vivo';

  @override
  String get liveAllCountries => 'Todos los países';

  @override
  String get liveAllCategories => 'Todas las categorías';

  @override
  String get liveAllLanguages => 'Todos los idiomas';

  @override
  String get liveSortAz => 'A a Z';

  @override
  String get liveSortPopular => 'Más populares';

  @override
  String get liveSortCountry => 'Por país';

  @override
  String get liveLoadMore => 'Cargar más';

  @override
  String liveChannelCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count canales',
      one: '1 canal',
      zero: 'Sin canales',
    );
    return '$_temp0';
  }

  @override
  String get channelWatchNow => 'Ver ahora';

  @override
  String get channelAddFavorite => 'Añadir a favoritos';

  @override
  String get channelRemoveFavorite => 'Quitar de favoritos';

  @override
  String get channelReportStream => 'Reportar transmisión';

  @override
  String channelMoreFromCountry(String country) {
    return 'Más de $country';
  }

  @override
  String get channelStreamUnavailable => 'Transmisión no disponible';

  @override
  String get channelTryAnotherQuality => 'Probar otra calidad';

  @override
  String get channelRetry => 'Reintentar';

  @override
  String get channelNowPlaying => 'Reproduciendo ahora';

  @override
  String get channelUpNext => 'A continuación';

  @override
  String channelEndsAt(String time) {
    return 'Termina a las $time';
  }

  @override
  String get channelOfficialWebsite => 'Sitio web oficial';

  @override
  String get channelQualityAuto => 'Auto';

  @override
  String get channelQualityHd => 'HD';

  @override
  String get channelQualitySd => 'SD';

  @override
  String get playerPlay => 'Reproducir';

  @override
  String get playerPause => 'Pausar';

  @override
  String get playerFullscreen => 'Pantalla completa';

  @override
  String get playerExitFullscreen => 'Salir de pantalla completa';

  @override
  String get playerMute => 'Silenciar';

  @override
  String get playerUnmute => 'Activar sonido';

  @override
  String get playerQuality => 'Calidad';

  @override
  String get playerLiveLabel => 'EN VIVO';

  @override
  String get playerLoading => 'Cargando transmisión...';

  @override
  String get playerErrorTitle => 'Error de reproducción';

  @override
  String get playerErrorMessage =>
      'Esta transmisión no pudo cargarse. Prueba otra calidad o inténtalo más tarde.';

  @override
  String get searchPlaceholder => 'Buscar canales...';

  @override
  String searchResultsFor(String query) {
    return 'Resultados para \"$query\"';
  }

  @override
  String get searchNoResultsTitle => 'Sin resultados';

  @override
  String get searchNoResultsSubtitle =>
      'Prueba un término diferente o explora por categoría';

  @override
  String get searchRecentSearches => 'Búsquedas recientes';

  @override
  String get searchClearRecent => 'Borrar';

  @override
  String get authSignIn => 'Iniciar sesión';

  @override
  String get authSignUp => 'Registrarse';

  @override
  String get authEmail => 'Correo electrónico';

  @override
  String get authPassword => 'Contraseña';

  @override
  String get authConfirmPassword => 'Confirmar contraseña';

  @override
  String get authGoogleSignIn => 'Continuar con Google';

  @override
  String get authForgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get authNoAccount => '¿No tienes cuenta?';

  @override
  String get authHaveAccount => '¿Ya tienes cuenta?';

  @override
  String get authContinueAsGuest => 'Continuar como invitado';

  @override
  String get authSignInToContinue => 'Inicia sesión para continuar';

  @override
  String get authSignInForFavorites => 'Inicia sesión para guardar favoritos';

  @override
  String get authSignInForHistory => 'Inicia sesión para ver tu historial';

  @override
  String get authCreateAccount => 'Crear cuenta';

  @override
  String get authOrContinueWith => 'o continuar con';

  @override
  String get epgNowPlaying => 'Reproduciendo ahora';

  @override
  String get epgUpNext => 'A continuación';

  @override
  String epgEndsAt(String time) {
    return 'Termina a las $time';
  }

  @override
  String get epgNoGuideAvailable => 'Guía de programas no disponible';

  @override
  String get epgTodaysSchedule => 'Programación de hoy';

  @override
  String get epgNowBadge => 'EN VIVO';

  @override
  String get epgScheduleCollapsed => 'Ver programación';

  @override
  String get epgScheduleExpanded => 'Ocultar programación';

  @override
  String get reportTitle => 'Reportar problema de transmisión';

  @override
  String get reportReasonOffline => 'La transmisión está fuera de línea';

  @override
  String get reportReasonGeoBlocked => 'Bloqueado en mi región';

  @override
  String get reportReasonPoorQuality => 'Mala calidad de video';

  @override
  String get reportReasonWrongContent => 'Contenido de canal incorrecto';

  @override
  String get reportSubmit => 'Enviar reporte';

  @override
  String get reportCancel => 'Cancelar';

  @override
  String get reportThankYou => '¡Gracias por tu reporte!';

  @override
  String get onboardingWhereWatching => '¿Desde dónde estás viendo?';

  @override
  String get onboardingWhatEnjoy => '¿Qué te gusta ver?';

  @override
  String get onboardingFreeOrSignin => 'Mira gratis o inicia sesión para más';

  @override
  String get onboardingSkip => 'Omitir';

  @override
  String get onboardingContinueBtn => 'Continuar';

  @override
  String get onboardingSelectCountry => 'Selecciona tu país';

  @override
  String get onboardingSelectCategories => 'Selecciona tus intereses';

  @override
  String get errorsSomethingWrong => 'Algo salió mal';

  @override
  String get errorsStreamUnavailable =>
      'Esta transmisión no está disponible actualmente';

  @override
  String get errorsNoInternet => 'Sin conexión a internet';

  @override
  String get errorsTryAgain => 'Por favor inténtalo de nuevo';

  @override
  String get errorsNotFound => 'Página no encontrada';

  @override
  String get errorsGoHome => 'Ir al inicio';

  @override
  String get errorsServerError =>
      'Error del servidor. Por favor inténtalo más tarde.';

  @override
  String get commonLoading => 'Cargando...';

  @override
  String get commonError => 'Error';

  @override
  String get commonRetry => 'Reintentar';

  @override
  String get commonClose => 'Cerrar';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonSave => 'Guardar';

  @override
  String get commonDone => 'Listo';

  @override
  String get commonBack => 'Atrás';

  @override
  String get commonOk => 'OK';

  @override
  String get commonShare => 'Compartir';

  @override
  String get commonReport => 'Reportar';

  @override
  String get commonFavorite => 'Favorito';

  @override
  String get commonUnfavorite => 'Quitar favorito';

  @override
  String get commonProBadge => 'PRO';

  @override
  String get commonLiveBadge => 'EN VIVO';

  @override
  String get commonHdBadge => 'HD';

  @override
  String get commonSdBadge => 'SD';

  @override
  String get commonMore => 'Más';

  @override
  String get commonLess => 'Menos';

  @override
  String get commonSeeAll => 'Ver todo';
}

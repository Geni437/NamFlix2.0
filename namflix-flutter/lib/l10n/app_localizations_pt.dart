// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get navHome => 'Início';

  @override
  String get navLiveTv => 'TV ao Vivo';

  @override
  String get navSearch => 'Pesquisar';

  @override
  String get navFavorites => 'Favoritos';

  @override
  String get navHistory => 'Histórico';

  @override
  String get navProfile => 'Perfil';

  @override
  String get navSignIn => 'Entrar';

  @override
  String get navSignOut => 'Sair';

  @override
  String get navSettings => 'Configurações';

  @override
  String get homeLiveNow => 'Ao Vivo Agora';

  @override
  String get homeNews => 'Notícias';

  @override
  String get homeSports => 'Esportes';

  @override
  String get homeEntertainment => 'Entretenimento';

  @override
  String get homeMusic => 'Música';

  @override
  String get homeMovies => 'Filmes';

  @override
  String get homeSeeAll => 'Ver tudo';

  @override
  String homeChannelsInCountry(String country) {
    return 'Canais de $country';
  }

  @override
  String get homeWatchNow => 'Assistir agora';

  @override
  String get homeTrendingGlobally => 'Em alta globalmente';

  @override
  String get homeFeatured => 'Destaque';

  @override
  String get liveAllChannels => 'Todos os canais';

  @override
  String get liveFilter => 'Filtrar';

  @override
  String get liveSort => 'Ordenar';

  @override
  String get liveSearchPlaceholder => 'Pesquisar canais...';

  @override
  String liveShowingCount(int count) {
    return 'Exibindo $count canais';
  }

  @override
  String get liveNoResults => 'Nenhum canal encontrado';

  @override
  String get liveLiveOnly => 'Somente ao vivo';

  @override
  String get liveAllCountries => 'Todos os países';

  @override
  String get liveAllCategories => 'Todas as categorias';

  @override
  String get liveAllLanguages => 'Todos os idiomas';

  @override
  String get liveSortAz => 'A a Z';

  @override
  String get liveSortPopular => 'Mais populares';

  @override
  String get liveSortCountry => 'Por país';

  @override
  String get liveLoadMore => 'Carregar mais';

  @override
  String liveChannelCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count canais',
      one: '1 canal',
      zero: 'Nenhum canal',
    );
    return '$_temp0';
  }

  @override
  String get channelWatchNow => 'Assistir agora';

  @override
  String get channelAddFavorite => 'Adicionar aos favoritos';

  @override
  String get channelRemoveFavorite => 'Remover dos favoritos';

  @override
  String get channelReportStream => 'Reportar transmissão';

  @override
  String channelMoreFromCountry(String country) {
    return 'Mais de $country';
  }

  @override
  String get channelStreamUnavailable => 'Transmissão indisponível';

  @override
  String get channelTryAnotherQuality => 'Tentar outra qualidade';

  @override
  String get channelRetry => 'Tentar novamente';

  @override
  String get channelNowPlaying => 'Reproduzindo agora';

  @override
  String get channelUpNext => 'A seguir';

  @override
  String channelEndsAt(String time) {
    return 'Termina às $time';
  }

  @override
  String get channelOfficialWebsite => 'Site oficial';

  @override
  String get channelQualityAuto => 'Auto';

  @override
  String get channelQualityHd => 'HD';

  @override
  String get channelQualitySd => 'SD';

  @override
  String get playerPlay => 'Reproduzir';

  @override
  String get playerPause => 'Pausar';

  @override
  String get playerFullscreen => 'Tela cheia';

  @override
  String get playerExitFullscreen => 'Sair da tela cheia';

  @override
  String get playerMute => 'Silenciar';

  @override
  String get playerUnmute => 'Ativar som';

  @override
  String get playerQuality => 'Qualidade';

  @override
  String get playerLiveLabel => 'AO VIVO';

  @override
  String get playerLoading => 'Carregando transmissão...';

  @override
  String get playerErrorTitle => 'Erro de reprodução';

  @override
  String get playerErrorMessage =>
      'Esta transmissão não pôde ser carregada. Tente outra qualidade ou volte mais tarde.';

  @override
  String get searchPlaceholder => 'Pesquisar canais...';

  @override
  String searchResultsFor(String query) {
    return 'Resultados para \"$query\"';
  }

  @override
  String get searchNoResultsTitle => 'Nenhum resultado encontrado';

  @override
  String get searchNoResultsSubtitle =>
      'Tente um termo diferente ou navegue por categoria';

  @override
  String get searchRecentSearches => 'Pesquisas recentes';

  @override
  String get searchClearRecent => 'Limpar';

  @override
  String get authSignIn => 'Entrar';

  @override
  String get authSignUp => 'Cadastrar';

  @override
  String get authEmail => 'E-mail';

  @override
  String get authPassword => 'Senha';

  @override
  String get authConfirmPassword => 'Confirmar senha';

  @override
  String get authGoogleSignIn => 'Continuar com Google';

  @override
  String get authForgotPassword => 'Esqueceu a senha?';

  @override
  String get authNoAccount => 'Não tem conta?';

  @override
  String get authHaveAccount => 'Já tem conta?';

  @override
  String get authContinueAsGuest => 'Continuar como convidado';

  @override
  String get authSignInToContinue => 'Entre para continuar';

  @override
  String get authSignInForFavorites => 'Entre para salvar favoritos';

  @override
  String get authSignInForHistory => 'Entre para ver seu histórico';

  @override
  String get authCreateAccount => 'Criar conta';

  @override
  String get authOrContinueWith => 'ou continuar com';

  @override
  String get epgNowPlaying => 'Reproduzindo agora';

  @override
  String get epgUpNext => 'A seguir';

  @override
  String epgEndsAt(String time) {
    return 'Termina às $time';
  }

  @override
  String get epgNoGuideAvailable => 'Guia de programação não disponível';

  @override
  String get epgTodaysSchedule => 'Programação de hoje';

  @override
  String get epgNowBadge => 'AO VIVO';

  @override
  String get epgScheduleCollapsed => 'Ver programação';

  @override
  String get epgScheduleExpanded => 'Ocultar programação';

  @override
  String get reportTitle => 'Reportar problema na transmissão';

  @override
  String get reportReasonOffline => 'Transmissão está offline';

  @override
  String get reportReasonGeoBlocked => 'Bloqueado na minha região';

  @override
  String get reportReasonPoorQuality => 'Qualidade de vídeo ruim';

  @override
  String get reportReasonWrongContent => 'Conteúdo do canal errado';

  @override
  String get reportSubmit => 'Enviar reporte';

  @override
  String get reportCancel => 'Cancelar';

  @override
  String get reportThankYou => 'Obrigado pelo seu reporte!';

  @override
  String get onboardingWhereWatching => 'De onde você está assistindo?';

  @override
  String get onboardingWhatEnjoy => 'O que você gosta de assistir?';

  @override
  String get onboardingFreeOrSignin => 'Assista grátis ou entre para mais';

  @override
  String get onboardingSkip => 'Pular';

  @override
  String get onboardingContinueBtn => 'Continuar';

  @override
  String get onboardingSelectCountry => 'Selecione seu país';

  @override
  String get onboardingSelectCategories => 'Selecione seus interesses';

  @override
  String get errorsSomethingWrong => 'Algo deu errado';

  @override
  String get errorsStreamUnavailable =>
      'Esta transmissão está indisponível no momento';

  @override
  String get errorsNoInternet => 'Sem conexão com a internet';

  @override
  String get errorsTryAgain => 'Por favor tente novamente';

  @override
  String get errorsNotFound => 'Página não encontrada';

  @override
  String get errorsGoHome => 'Ir para o início';

  @override
  String get errorsServerError =>
      'Erro no servidor. Por favor tente mais tarde.';

  @override
  String get commonLoading => 'Carregando...';

  @override
  String get commonError => 'Erro';

  @override
  String get commonRetry => 'Tentar novamente';

  @override
  String get commonClose => 'Fechar';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonSave => 'Salvar';

  @override
  String get commonDone => 'Concluído';

  @override
  String get commonBack => 'Voltar';

  @override
  String get commonOk => 'OK';

  @override
  String get commonShare => 'Compartilhar';

  @override
  String get commonReport => 'Reportar';

  @override
  String get commonFavorite => 'Favorito';

  @override
  String get commonUnfavorite => 'Desfavoritar';

  @override
  String get commonProBadge => 'PRO';

  @override
  String get commonLiveBadge => 'AO VIVO';

  @override
  String get commonHdBadge => 'HD';

  @override
  String get commonSdBadge => 'SD';

  @override
  String get commonMore => 'Mais';

  @override
  String get commonLess => 'Menos';

  @override
  String get commonSeeAll => 'Ver tudo';
}

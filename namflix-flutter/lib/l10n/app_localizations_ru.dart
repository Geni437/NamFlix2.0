// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get navHome => 'Главная';

  @override
  String get navLiveTv => 'Прямой эфир';

  @override
  String get navSearch => 'Поиск';

  @override
  String get navFavorites => 'Избранное';

  @override
  String get navHistory => 'История';

  @override
  String get navProfile => 'Профиль';

  @override
  String get navSignIn => 'Войти';

  @override
  String get navSignOut => 'Выйти';

  @override
  String get navSettings => 'Настройки';

  @override
  String get homeLiveNow => 'В прямом эфире';

  @override
  String get homeNews => 'Новости';

  @override
  String get homeSports => 'Спорт';

  @override
  String get homeEntertainment => 'Развлечения';

  @override
  String get homeMusic => 'Музыка';

  @override
  String get homeMovies => 'Кино';

  @override
  String get homeSeeAll => 'Показать все';

  @override
  String homeChannelsInCountry(String country) {
    return 'Каналы из $country';
  }

  @override
  String get homeWatchNow => 'Смотреть';

  @override
  String get homeTrendingGlobally => 'В тренде по всему миру';

  @override
  String get homeFeatured => 'Рекомендуемое';

  @override
  String get liveAllChannels => 'Все каналы';

  @override
  String get liveFilter => 'Фильтр';

  @override
  String get liveSort => 'Сортировка';

  @override
  String get liveSearchPlaceholder => 'Поиск каналов...';

  @override
  String liveShowingCount(int count) {
    return 'Показано $count каналов';
  }

  @override
  String get liveNoResults => 'Каналы не найдены';

  @override
  String get liveLiveOnly => 'Только прямой эфир';

  @override
  String get liveAllCountries => 'Все страны';

  @override
  String get liveAllCategories => 'Все категории';

  @override
  String get liveAllLanguages => 'Все языки';

  @override
  String get liveSortAz => 'А до Я';

  @override
  String get liveSortPopular => 'Самые популярные';

  @override
  String get liveSortCountry => 'По стране';

  @override
  String get liveLoadMore => 'Загрузить ещё';

  @override
  String liveChannelCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count канала',
      many: '$count каналов',
      few: '$count канала',
      one: '1 канал',
      zero: 'Нет каналов',
    );
    return '$_temp0';
  }

  @override
  String get channelWatchNow => 'Смотреть';

  @override
  String get channelAddFavorite => 'Добавить в избранное';

  @override
  String get channelRemoveFavorite => 'Удалить из избранного';

  @override
  String get channelReportStream => 'Пожаловаться на трансляцию';

  @override
  String channelMoreFromCountry(String country) {
    return 'Ещё из $country';
  }

  @override
  String get channelStreamUnavailable => 'Трансляция недоступна';

  @override
  String get channelTryAnotherQuality => 'Попробовать другое качество';

  @override
  String get channelRetry => 'Повторить';

  @override
  String get channelNowPlaying => 'Сейчас в эфире';

  @override
  String get channelUpNext => 'Следующее';

  @override
  String channelEndsAt(String time) {
    return 'Конец в $time';
  }

  @override
  String get channelOfficialWebsite => 'Официальный сайт';

  @override
  String get channelQualityAuto => 'Авто';

  @override
  String get channelQualityHd => 'HD';

  @override
  String get channelQualitySd => 'SD';

  @override
  String get playerPlay => 'Воспроизвести';

  @override
  String get playerPause => 'Пауза';

  @override
  String get playerFullscreen => 'Полный экран';

  @override
  String get playerExitFullscreen => 'Выйти из полного экрана';

  @override
  String get playerMute => 'Выключить звук';

  @override
  String get playerUnmute => 'Включить звук';

  @override
  String get playerQuality => 'Качество';

  @override
  String get playerLiveLabel => 'ЭФИР';

  @override
  String get playerLoading => 'Загрузка трансляции...';

  @override
  String get playerErrorTitle => 'Ошибка воспроизведения';

  @override
  String get playerErrorMessage =>
      'Эту трансляцию не удалось загрузить. Попробуйте другое качество или вернитесь позже.';

  @override
  String get searchPlaceholder => 'Поиск каналов...';

  @override
  String searchResultsFor(String query) {
    return 'Результаты для \"$query\"';
  }

  @override
  String get searchNoResultsTitle => 'Ничего не найдено';

  @override
  String get searchNoResultsSubtitle =>
      'Попробуйте другой запрос или просмотрите по категории';

  @override
  String get searchRecentSearches => 'Недавние поиски';

  @override
  String get searchClearRecent => 'Очистить';

  @override
  String get authSignIn => 'Войти';

  @override
  String get authSignUp => 'Зарегистрироваться';

  @override
  String get authEmail => 'Электронная почта';

  @override
  String get authPassword => 'Пароль';

  @override
  String get authConfirmPassword => 'Подтвердите пароль';

  @override
  String get authGoogleSignIn => 'Продолжить с Google';

  @override
  String get authForgotPassword => 'Забыли пароль?';

  @override
  String get authNoAccount => 'Нет аккаунта?';

  @override
  String get authHaveAccount => 'Уже есть аккаунт?';

  @override
  String get authContinueAsGuest => 'Продолжить как гость';

  @override
  String get authSignInToContinue => 'Войдите, чтобы продолжить';

  @override
  String get authSignInForFavorites => 'Войдите, чтобы сохранить избранное';

  @override
  String get authSignInForHistory => 'Войдите, чтобы просмотреть историю';

  @override
  String get authCreateAccount => 'Создать аккаунт';

  @override
  String get authOrContinueWith => 'или продолжить с';

  @override
  String get epgNowPlaying => 'Сейчас в эфире';

  @override
  String get epgUpNext => 'Следующее';

  @override
  String epgEndsAt(String time) {
    return 'Конец в $time';
  }

  @override
  String get epgNoGuideAvailable => 'Программа передач недоступна';

  @override
  String get epgTodaysSchedule => 'Программа на сегодня';

  @override
  String get epgNowBadge => 'ЭФИР';

  @override
  String get epgScheduleCollapsed => 'Показать программу';

  @override
  String get epgScheduleExpanded => 'Скрыть программу';

  @override
  String get reportTitle => 'Пожаловаться на трансляцию';

  @override
  String get reportReasonOffline => 'Трансляция недоступна';

  @override
  String get reportReasonGeoBlocked => 'Заблокировано в моём регионе';

  @override
  String get reportReasonPoorQuality => 'Плохое качество видео';

  @override
  String get reportReasonWrongContent => 'Неправильный контент канала';

  @override
  String get reportSubmit => 'Отправить жалобу';

  @override
  String get reportCancel => 'Отмена';

  @override
  String get reportThankYou => 'Спасибо за вашу жалобу!';

  @override
  String get onboardingWhereWatching => 'Откуда вы смотрите?';

  @override
  String get onboardingWhatEnjoy => 'Что вы любите смотреть?';

  @override
  String get onboardingFreeOrSignin =>
      'Смотрите бесплатно или войдите для большего';

  @override
  String get onboardingSkip => 'Пропустить';

  @override
  String get onboardingContinueBtn => 'Продолжить';

  @override
  String get onboardingSelectCountry => 'Выберите страну';

  @override
  String get onboardingSelectCategories => 'Выберите интересы';

  @override
  String get errorsSomethingWrong => 'Что-то пошло не так';

  @override
  String get errorsStreamUnavailable =>
      'Эта трансляция в данный момент недоступна';

  @override
  String get errorsNoInternet => 'Нет подключения к интернету';

  @override
  String get errorsTryAgain => 'Пожалуйста, попробуйте ещё раз';

  @override
  String get errorsNotFound => 'Страница не найдена';

  @override
  String get errorsGoHome => 'На главную';

  @override
  String get errorsServerError => 'Ошибка сервера. Попробуйте позже.';

  @override
  String get commonLoading => 'Загрузка...';

  @override
  String get commonError => 'Ошибка';

  @override
  String get commonRetry => 'Повторить';

  @override
  String get commonClose => 'Закрыть';

  @override
  String get commonCancel => 'Отмена';

  @override
  String get commonSave => 'Сохранить';

  @override
  String get commonDone => 'Готово';

  @override
  String get commonBack => 'Назад';

  @override
  String get commonOk => 'OK';

  @override
  String get commonShare => 'Поделиться';

  @override
  String get commonReport => 'Пожаловаться';

  @override
  String get commonFavorite => 'Избранное';

  @override
  String get commonUnfavorite => 'Убрать из избранного';

  @override
  String get commonProBadge => 'PRO';

  @override
  String get commonLiveBadge => 'ЭФИР';

  @override
  String get commonHdBadge => 'HD';

  @override
  String get commonSdBadge => 'SD';

  @override
  String get commonMore => 'Ещё';

  @override
  String get commonLess => 'Меньше';

  @override
  String get commonSeeAll => 'Показать все';
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:app_links/app_links.dart';
import 'core/constants/app_constants.dart';
import 'core/network/dio_client.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/remote_channel_datasource.dart';
import 'data/datasources/local_channel_datasource.dart';
import 'data/datasources/remote_user_datasource.dart';
import 'data/repositories/channel_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/auth/auth_event.dart';
import 'presentation/blocs/channel/channel_bloc.dart';
import 'presentation/blocs/search/search_bloc.dart';
import 'presentation/blocs/favorites/favorites_bloc.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/onboarding_screen.dart';
import 'presentation/screens/auth_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/live_screen.dart';
import 'presentation/screens/channel_detail_screen.dart';
import 'presentation/screens/player_screen.dart';
import 'presentation/screens/search_screen.dart';
import 'presentation/screens/favorites_screen.dart';
import 'presentation/screens/profile_screen.dart';
import 'l10n/app_localizations.dart';

// Module-level notifier so any widget tree can trigger locale changes.
final localeNotifier = ValueNotifier<Locale>(const Locale('en'));

class NamFlixApp extends StatefulWidget {
  const NamFlixApp({super.key});

  @override
  State<NamFlixApp> createState() => _NamFlixAppState();
}

class _NamFlixAppState extends State<NamFlixApp> {
  late final GoRouter _router;
  late final AuthBloc _authBloc;
  late final ChannelBloc _channelBloc;
  late final SearchBloc _searchBloc;
  late final FavoritesBloc _favoritesBloc;

  @override
  void initState() {
    super.initState();

    // Restore persisted locale
    final settingsBox = Hive.box<dynamic>(AppConstants.boxSettings);
    final langCode = settingsBox.get('ui_language', defaultValue: 'en') as String;
    localeNotifier.value = Locale(langCode);

    // Wire up dependencies
    final dio = DioClient.instance;
    final channelCacheBox = Hive.box<String>(AppConstants.boxChannelsCache);
    final categoriesCacheBox = Hive.box<String>(AppConstants.boxCategoriesCache);
    final countriesCacheBox = Hive.box<String>(AppConstants.boxCountriesCache);

    final remoteChannelDs = RemoteChannelDataSource(dio);
    final localChannelDs  = LocalChannelDataSource(channelCacheBox, categoriesCacheBox, countriesCacheBox);
    final remoteUserDs    = RemoteUserDataSource(dio);

    final channelRepo  = ChannelRepositoryImpl(remoteChannelDs, localChannelDs);
    final userRepo     = UserRepositoryImpl(remoteUserDs);

    _authBloc      = AuthBloc()..add(const CheckSession());
    _channelBloc   = ChannelBloc(channelRepo);
    _searchBloc    = SearchBloc(channelRepo);
    _favoritesBloc = FavoritesBloc(userRepo);

    _router = _buildRouter();
    _initDeepLinks();
  }

  void _initDeepLinks() {
    final appLinks = AppLinks();
    appLinks.uriLinkStream.listen((uri) {
      _router.go('/${uri.host}${uri.path}${uri.hasQuery ? '?${uri.query}' : ''}');
    });
  }

  GoRouter _buildRouter() {
    return GoRouter(
      initialLocation: '/splash',
      routes: [
        GoRoute(path: '/splash',      builder: (c, s) => const SplashScreen()),
        GoRoute(path: '/onboarding',  builder: (c, s) => const OnboardingScreen()),
        GoRoute(path: '/auth',        builder: (c, s) => const AuthScreen()),
        GoRoute(path: '/home',        builder: (c, s) => const HomeScreen()),
        GoRoute(path: '/live',        builder: (c, s) => LiveScreen(
          initialCountry:  s.uri.queryParameters['country'],
          initialCategory: s.uri.queryParameters['category'],
        )),
        GoRoute(path: '/channel/:id', builder: (c, s) => ChannelDetailScreen(channelId: s.pathParameters['id']!)),
        GoRoute(path: '/player/:id',  builder: (c, s) => PlayerScreen(channelId: s.pathParameters['id']!)),
        GoRoute(path: '/search',      builder: (c, s) => SearchScreen(initialQuery: s.uri.queryParameters['q'])),
        GoRoute(path: '/favorites',   builder: (c, s) => const FavoritesScreen()),
        GoRoute(path: '/profile',     builder: (c, s) => const ProfileScreen()),
      ],
    );
  }

  @override
  void dispose() {
    _authBloc.close();
    _channelBloc.close();
    _searchBloc.close();
    _favoritesBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        BlocProvider.value(value: _channelBloc),
        BlocProvider.value(value: _searchBloc),
        BlocProvider.value(value: _favoritesBloc),
      ],
      child: ValueListenableBuilder<Locale>(
        valueListenable: localeNotifier,
        builder: (context, locale, _) {
          return MaterialApp.router(
            title: 'NamFlix',
            theme: AppTheme.dark,
            routerConfig: _router,
            debugShowCheckedModeBanner: false,
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }
}

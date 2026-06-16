import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/constants/app_constants.dart';
import 'core/supabase/supabase_client.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait + landscape (allow both)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Dark status bar
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  // Hive
  await Hive.initFlutter();
  await Hive.openBox<dynamic>(AppConstants.boxSettings);
  await Hive.openBox<dynamic>(AppConstants.boxUserPrefs);
  await Hive.openBox<String>(AppConstants.boxChannelsCache);
  await Hive.openBox<String>(AppConstants.boxCategoriesCache);
  await Hive.openBox<String>(AppConstants.boxCountriesCache);
  await Hive.openBox<String>(AppConstants.boxRecentSearches);

  // Supabase
  await SupabaseClientHelper.initialize();

  runApp(const NamFlixApp());
}

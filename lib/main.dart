import 'package:ala_darbak_user/core/translations/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ala_darbk_user_app.dart';
import 'core/config/style/app_status_bar.dart';
import 'core/dependency_injection/di.dart';
import 'core/heplers/shared_preferences_helper.dart';
import 'core/observer/bloc_observe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await InjectionContainer.init();
  await EasyLocalization.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  AppStatusBar.setStatusBarStyle();

  // Load saved locale from SharedPreferences
  final sharedPrefs = sl<SharedPreferencesHelper>();
  final savedLocale = sharedPrefs.getData(key: 'locale');
  final startLocale =
      savedLocale != null ? Locale(savedLocale) : const Locale('ar');

  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: const [Locale('en'), Locale('ar')],
      startLocale: startLocale,
      fallbackLocale: const Locale('ar'),
      assetLoader: const CodegenLoader(),
      child: const AlaDarbkUserApp(),
    ),
  );
}

import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ala_darbk_user_app.dart';
import 'core/config/localization/localization.dart';
import 'core/config/style/app_status_bar.dart';
import 'core/dependency_injection/di.dart';
import 'core/observer/bloc_observe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();

  await Future.wait([
    Firebase.initializeApp(),
    AppLocalization.init(),
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]),
  ]);

  InjectionContainer.init();
  AppStatusBar.setStatusBarStyle();

  runApp(const AlaDarbkUserApp());
}

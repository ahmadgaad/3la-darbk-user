import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'blocobserve.dart';
import 'config/localization/localization.dart';
import 'config/style/app_status_bar.dart';
import 'db_injection.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  await AppLocalization.init();
  DpInjection.init();
  AppStatusBar.setStatusBarStyle();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then(
      (value) => runApp(const MyApp()));
}

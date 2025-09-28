import 'dart:async';

import 'package:flutter/material.dart';

import '../config/routes/app_routes.dart';
import '../config/style/app_status_bar.dart';
import '../dependency_injection/di.dart';
import '../data/local/shared_preferences_service.dart';
import '../utils/notification/firebase_notification.dart';
import 'logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    AppStatusBar.hide();
    _loading();
  }

  _loading() {
    // FirebaseNotifications.init();
    Timer(const Duration(seconds: 3), () {
       if (sl<SharedPreferencesService>().token != null) {
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoute.home, (_) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, AppRoute.auth, (_) => false);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    AppStatusBar.show();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Logo()),
    );
  }
}

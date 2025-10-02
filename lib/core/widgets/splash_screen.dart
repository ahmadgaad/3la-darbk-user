import 'dart:async';

import 'package:ala_darbak_user/core/config/router/app_routes.dart';
import 'package:flutter/material.dart';

import '../config/style/app_status_bar.dart';
import '../dependency_injection/di.dart';
import '../heplers/shared_preferences_helper.dart';
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
      if (sl<SharedPreferencesHelper>().token != null) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.home,
          (_) => false,
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.auth,
          (_) => false,
        );
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
    return const Scaffold(body: Center(child: Logo()));
  }
}

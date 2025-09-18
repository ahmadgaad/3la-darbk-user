import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:oktoast/oktoast.dart';
import 'config/routes/app_routes.dart';
import 'config/style/app_color.dart';
import 'config/style/app_theme.dart';
import 'core/manager/app_cubit.dart';
import 'core/screens/splash_screen.dart';
import 'db_injection.dart';
import 'features/order/presentation/manager/order_cubit/cubit.dart';
import 'features/profile/presentation/manager/profile_cubit/cubit.dart';
import 'features/setttings_info/presentation/manager/cubit.dart';
import 'features/trips/presentation/manager/cities/cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      ensureScreenSize: true,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) => OKToast(
        child: LocalizedApp(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => AppCubit(),
              ),
              BlocProvider(
                create: (context) => OrderCubit(sl()),
              ),
              BlocProvider(
                create: (context) => ProfileCubit(sl()),
                lazy: false,
              ),
              BlocProvider(
                create: (context) => SettingsInfoCubit(sl())..getSettingInfo(),
                lazy: false,
              ),
            ],
            child: MaterialApp(
              title: 'علي دربك',
              debugShowCheckedModeBanner: false,
              theme: appTheme,
              themeMode: ThemeMode.light,
              color: AppColors.backGround,
              home: const SplashScreen(),
              navigatorKey: AppRoute.navigatorKey,
              onGenerateRoute: AppRoute.generateRoute,
              builder: LocalizeAndTranslate.directionBuilder,
              locale: context.locale,
              localizationsDelegates: context.delegates,
              supportedLocales: context.supportedLocales,
            ),
          ),
        ),
      ),
    );
  }
}

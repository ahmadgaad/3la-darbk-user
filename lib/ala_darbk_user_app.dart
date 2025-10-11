import 'package:ala_darbak_user/core/config/router/app_routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';

import 'core/config/style/app_color.dart';
import 'core/config/style/app_theme.dart';
import 'core/controller/app_cubit.dart';
import 'core/dependency_injection/di.dart';
import 'core/widgets/splash_screen.dart';
import 'features/order/presentation/view_model/order_cubit/cubit.dart';
import 'features/profile/presentation/manager/profile_cubit/cubit.dart';
import 'features/settings/presentation/manager/cubit.dart';

class AlaDarbkUserApp extends StatelessWidget {
  const AlaDarbkUserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      ensureScreenSize: true,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return OKToast(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => AppCubit()),
              BlocProvider(create: (context) => OrderCubit(sl())),
              BlocProvider(create: (context) => sl<ProfileCubit>()),
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
              navigatorKey: AppRouter.navigatorKey,
              onGenerateRoute: AppRouter.generateRoute,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
            ),
          ),
        );
      },
    );
  }
}

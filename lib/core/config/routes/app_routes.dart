import '../../../features/notifications/presentation/pages/notifications_screen.dart';
import '../../../features/setttings_info/presentation/pages/policy_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dependency_injection/di.dart';
import '../../../features/auth/presentation/pages/auth_screen.dart';
import '../../../features/auth/presentation/pages/forget_password_screen.dart';
import '../../../features/categories/presentation/manager/cubit.dart';
import '../../../features/notifications/presentation/manager/notifications_cubit/cubit.dart';
import '../../../features/order/presentation/manager/order_map_cubit/cubit.dart';
import '../../../features/orders/presentation/manager/cubit.dart';
import '../../../features/orders/presentation/pages/history_orders_screen.dart';
import '../../../features/home/presentation/pages/home_screen.dart';
import '../../../features/categories/presentation/pages/select_category_screen.dart';
import '../../../features/order/presentation/screens/new_order_screen.dart';
import '../../../features/order/presentation/screens/order_details_screen.dart';
import '../../../features/order/presentation/screens/order_edit_screen.dart';
import '../../../features/order/presentation/screens/order_location_pickup_screen.dart';
import '../../../features/profile/presentation/pages/change_password_screen.dart';
import '../../../features/profile/presentation/pages/edit_profile_screen.dart';
import '../../../features/setttings_info/presentation/pages/about_us_screen.dart';
import '../../../features/setttings_info/presentation/pages/terms_condtions_screen.dart';
import '../../../features/trips/presentation/manager/cities/cubit.dart';
import '../../../features/trips/presentation/manager/trips/cubit.dart';

class AppRoute {
  static const String auth = "/auth";
  static const String home = "/home";
  static const String notifications = "/notifications";
  static const String forgePassword = "/forget_password";
  static const String changePassword = "/changePassword";
  static const String editProfile = "/editProfile";
  static const String orderCategories = "/order_categroies";
  static const String newOrder = "/new_order";
  static const String pickLocation = "/pick_location";
  static const String orderDetails = "/order_details";
  static const String orderEdit = "/order_edit";
  static const String historyOrders = "/history_orders";
  static const String aboutUs = "/about_us";
  static const String termsAndCondtions = "/terms_and_condtions";
  static const String policy = "/policy";

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    try {
      var args = settings.arguments;

      switch (settings.name) {
        case auth:
          return _animateRouteBuilder(const AuthScreen(), x: 0, y: 1);
        case forgePassword:
          return _animateRouteBuilder(const ForgetPasswordScreen(), x: 1, y: 0);
        case home:
          return _animateRouteBuilder(
            MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => OrdersCubit(sl())),
                BlocProvider(create: (context) => NotificationsCubit(sl())),
                  BlocProvider(
          create: (context) => TripsCubit(sl()),
        ),
        BlocProvider(
          create: (context) => CitiesCubit(sl()),
        ),
              ],
              child: const HomeScreen(),
            ),
            x: 0,
            y: 1,
          );
        case orderCategories:
          return _animateRouteBuilder(
            BlocProvider(
              create: (context) => CategoryCubit(sl()),
              child: const SelectCategoryScreen(),
            ),
            x: -1,
            y: 0,
          );
        case newOrder:
          return _animateRouteBuilder(const NewOrderScreen(), x: -1, y: 0);
        case pickLocation:
          return _animateRouteBuilder(BlocProvider(
      create: (BuildContext context) => OrderMapCubit(sl()),child: const OrderLocationPickupScreen()), x: -1, y: 0);
        case orderDetails:
          if (args == null) return _errorRoute();
          return _animateRouteBuilder(
            OrderDetailsScreen(orderId: args as int),
            x: -1,
            y: 0,
          );
        case orderEdit:
          return _animateRouteBuilder(const OrderEditScreen(), x: -1, y: 0);
        case historyOrders:
          return _animateRouteBuilder(
            BlocProvider.value(
              value: args as OrdersCubit,
              child: const HistoryOrdersScreen(),
            ),
            x: 1,
            y: 0,
          );
        case changePassword:
          return _animateRouteBuilder(
            const ChangePasswordScreen(),
            x: -1,
            y: 0,
          );
        case editProfile:
          return _animateRouteBuilder(const EditProfileScreen(), x: -1, y: 0);
        case notifications:
        if(args == null) return _errorRoute();
          return _animateRouteBuilder(
            BlocProvider.value(
              value: args as NotificationsCubit,
              child: const NotificationsScreen(),
            ),
            x: -1,
            y: 0,
          );
        case aboutUs:
          return _animateRouteBuilder(const AboutUsScreen(), x: -1, y: 0);
        case termsAndCondtions:
          return _animateRouteBuilder(
            const TermsCondtionsScreen(),
            x: -1,
            y: 0,
          );
        case policy:
          return _animateRouteBuilder(const PolicyScreen(), x: -1, y: 0);
        default:
          return MaterialPageRoute(builder: (_) => const AuthScreen());
      }
    } catch (e) {
      return _errorRoute();
    }
  }

  static BuildContext? get currentContext => navigatorKey.currentContext;

  static Future pushNamedAndRemoveUntil(
    String routeName, {
    Object? arguments,
  }) async {
    return await navigatorKey.currentState?.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  static Future pushNamed(String routeName, {Object? arguments}) async {
    return await navigatorKey.currentState?.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  static pop<T>([T? result]) {
    return navigatorKey.currentState?.pop(result);
  }

  static bool get canPop => navigatorKey.currentState?.canPop() ?? false;

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text('خطأ')),
          body: const Center(
            child: Text('نعتذر حدث خطأ , الرجاء اعادة المحاولة'),
          ),
        );
      },
    );
  }

  static _animateRouteBuilder(Widget to, {double x = 1, double y = 0}) =>
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => to,
        opaque: false,
        transitionDuration: const Duration(milliseconds: 250),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        transitionsBuilder: (context, animation, animationTime, child) {
          final tween = Tween<Offset>(
            begin: Offset(x, y),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.ease));
          final tween2 = Tween<double>(begin: 0, end: 1);
          return FadeTransition(
            opacity: animation.drive(tween2),
            child: SlideTransition(
              position: animation.drive(tween),
              child: child,
            ),
          );
        },
      );
}

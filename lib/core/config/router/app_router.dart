part of 'app_routes.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    var args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.auth:
        return _animateRouteBuilder(
          MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<RegisterCubit>()),
              BlocProvider(create: (context) => sl<LoginCubit>()),
            ],
            child: const AuthView(),
          ),
          x: 0,
          y: 1,
        );
      case AppRoutes.forgePassword:
        return _animateRouteBuilder(const ForgetPasswordScreen(), x: 1, y: 0);
      case AppRoutes.home:
        return _animateRouteBuilder(
          MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => ShipmentsCubit(sl())),
              BlocProvider(create: (context) => NotificationsCubit(sl())),
              BlocProvider(create: (context) => TripsCubit(sl())),
              BlocProvider(create: (context) => CitiesCubit(sl())),
            ],
            child: const HomeScreen(),
          ),
          x: 0,
          y: 1,
        );
      case AppRoutes.orderCategories:
        return _animateRouteBuilder(
          BlocProvider(
            create: (context) => CategoryCubit(sl()),
            child: const SelectCategoryScreen(),
          ),
          x: -1,
          y: 0,
        );
      case AppRoutes.newOrder:
        return _animateRouteBuilder(const CreateOrderScreen(), x: -1, y: 0);
      case AppRoutes.pickLocation:
        return _animateRouteBuilder(
          Builder(
            builder: (context) {
              final orderCubit = context.read<OrderCubit>();
              final trip = orderCubit.state.trip;
              final String? latStr = trip?.latitude;
              final String? lngStr = trip?.longitude;
              final lat = latStr == null ? null : double.tryParse(latStr);
              final lng = lngStr == null ? null : double.tryParse(lngStr);

              return BlocProvider(
                create: (BuildContext context) {
                  final mapCubit = OrderMapCubit(sl());
                  // Always call init: with driver coords if from trip, else user location
                  final LatLng? driverLatLng =
                      (lat != null && lng != null) ? LatLng(lat, lng) : null;
                  // Fire and forget; widget reads initialCameraPosition synchronously next build
                  mapCubit.init(driverLatLng);
                  return mapCubit;
                },
                child: const OrderLocationPickupScreen(),
              );
            },
          ),
          x: -1,
          y: 0,
        );
      case AppRoutes.orderDetails:
        // if (args == null) return _errorRoute();
        return _animateRouteBuilder(
          OrderDetailsScreen(orderId: args as int),
          x: -1,
          y: 0,
        );
      case AppRoutes.orderEdit:
        return _animateRouteBuilder(const OrderEditScreen(), x: -1, y: 0);
      case AppRoutes.historyOrders:
        return _animateRouteBuilder(
          BlocProvider.value(
            value: args as ShipmentsCubit,
            child: const HistoryOrdersScreen(),
          ),
          x: 1,
          y: 0,
        );
      case AppRoutes.changePassword:
        return _animateRouteBuilder(const ChangePasswordScreen(), x: -1, y: 0);
      case AppRoutes.editProfile:
        return _animateRouteBuilder(const EditProfileScreen(), x: -1, y: 0);
      case AppRoutes.notifications:
        // if (args == null) return _errorRoute();
        return _animateRouteBuilder(
          BlocProvider.value(
            value: args as NotificationsCubit,
            child: const NotificationsScreen(),
          ),
          x: -1,
          y: 0,
        );
      case AppRoutes.aboutUs:
        return _animateRouteBuilder(const AboutUsScreen(), x: -1, y: 0);
      case AppRoutes.termsAndCondtions:
        return _animateRouteBuilder(const TermsCondtionsScreen(), x: -1, y: 0);
      case AppRoutes.policy:
        return _animateRouteBuilder(const PolicyScreen(), x: -1, y: 0);
      default:
        return MaterialPageRoute(builder: (_) => const AuthView());
    }
  }

  static BuildContext? get currentContext => navigatorKey.currentContext;

  static bool get canPop => navigatorKey.currentState?.canPop() ?? false;

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

import 'package:ala_darbak_user/features/auth/presentation/view_model/login_cubit/cubit.dart';
import 'package:ala_darbak_user/features/auth/presentation/view_model/register_cubit/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../features/auth/presentation/views/auth_view.dart';
import '../../../features/auth/presentation/views/forget_password_view.dart';
import '../../../features/categories/presentation/manager/cubit.dart';
import '../../../features/categories/presentation/pages/select_category_screen.dart';
import '../../../features/home/view/home_screen.dart';
import '../../../features/notifications/presentation/view/notifications_screen.dart';
import '../../../features/notifications/presentation/view_model/notifications_cubit.dart';
import '../../../features/order/presentation/view/create_order_screen.dart';
import '../../../features/order/presentation/view/order_details_screen.dart';
import '../../../features/order/presentation/view/order_edit_screen.dart';
import '../../../features/order/presentation/view/order_location_pickup_screen.dart';
import '../../../features/order/presentation/view_model/order_cubit/cubit.dart';
import '../../../features/order/presentation/view_model/order_map_cubit/cubit.dart';
import '../../../features/profile/presentation/view/screens/change_password_screen.dart';
import '../../../features/profile/presentation/view/screens/edit_profile_screen.dart';
import '../../../features/settings/presentation/pages/about_us_screen.dart';
import '../../../features/settings/presentation/pages/policy_screen.dart';
import '../../../features/settings/presentation/pages/terms_condtions_screen.dart';
import '../../../features/shipments/presentation/view/history_orders_screen.dart';
import '../../../features/shipments/presentation/view_model/shipments_cubit.dart';
import '../../../features/trips/presentation/view_model/cities/cubit.dart';
import '../../../features/trips/presentation/view_model/trips/trips_cubit.dart';
import '../../dependency_injection/di.dart';

part 'app_router.dart';

class AppRoutes {
  static const String auth = "/auth";
  static const String home = "/home";
  static const String notifications = "/notifications";
  static const String forgePassword = "/forget-password";
  static const String changePassword = "/changePassword";
  static const String editProfile = "/editProfile";
  static const String orderCategories = "/order-categroies";
  static const String newOrder = "/new-order";
  static const String pickLocation = "/pick-location";
  static const String orderDetails = "/order-details";
  static const String orderEdit = "/order-edit";
  static const String historyOrders = "/history-orders";
  static const String aboutUs = "/about-us";
  static const String termsAndCondtions = "/terms-and-condtions";
  static const String policy = "/policy";
}

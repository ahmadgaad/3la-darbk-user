import 'package:ala_darbak_user/core/config/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/app_strings.dart';
import '../../notifications/presentation/manager/notifications_cubit/cubit.dart';
import '../../notifications/presentation/manager/notifications_cubit/state.dart';

class CustomHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomHomeAppBar({
    super.key,
    required GlobalKey<ScaffoldState> scaffoldKey,
  }) : _scaffoldKey = scaffoldKey;

  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          _scaffoldKey.currentState!.openDrawer();
        },
        icon: const Icon(Icons.menu),
      ),
      title: Row(
        spacing: 20.w,
        children: [
          IconButton(
            icon: BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                return Badge.count(
                  count: state.notifications.where((x) => x.isRead == 0).length,
                  child: const Icon(Icons.notifications),
                );
              },
            ),
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.notifications,
                arguments: context.read<NotificationsCubit>(),
              );
            },
          ),
          const Text(AppStrings.home),
        ],
      ),
      bottom: const TabBar(
        tabs: [Tab(text: AppStrings.myOrders), Tab(text: AppStrings.trips)],
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + kTextTabBarHeight);
}

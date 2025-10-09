import 'package:ala_darbak_user/core/config/router/app_routes.dart';
import 'package:ala_darbak_user/core/extensions/navigation.dart';
import 'package:ala_darbak_user/core/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../notifications/presentation/view_model/notification_states.dart';
import '../../notifications/presentation/view_model/notifications_cubit.dart';

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
                  isLabelVisible: state.notifications.isNotEmpty,
                  count: state.notifications.where((x) => x.isRead == 0).length,
                  child: const Icon(Icons.notifications),
                );
              },
            ),
            onPressed: () {
              context.pushNamed(
                AppRoutes.notifications,
                arguments: context.read<NotificationsCubit>(),
              );
            },
          ),
          Text(LocaleKeys.home.tr()),
        ],
      ),
      bottom: TabBar(
        tabs: [
          Tab(text: LocaleKeys.my_orders.tr()),
          Tab(text: LocaleKeys.trips.tr()),
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + kTextTabBarHeight);
}

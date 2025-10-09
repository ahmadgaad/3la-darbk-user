import 'package:ala_darbak_user/core/translations/locale_keys.g.dart';
import 'package:ala_darbak_user/features/notifications/presentation/view/components/notification_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../view_model/notification_states.dart';
import '../view_model/notifications_cubit.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationsCubit>().getNotifications();
    context.read<NotificationsCubit>().readNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(LocaleKeys.notifications.tr()),
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        buildWhen:
            (previous, current) =>
                current.status == NotificationStatus.loading ||
                current.status == NotificationStatus.success ||
                current.status == NotificationStatus.failure,
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              await context.read<NotificationsCubit>().getNotifications(
                forceRefresh: true,
              );
            },
            child: switch (state.status) {
              NotificationStatus.initial || NotificationStatus.loading =>
                const Center(child: CircularProgressIndicator.adaptive()),
              NotificationStatus.failure => Center(
                child: Text(state.errorMessage),
              ),
              NotificationStatus.success =>
                state.notifications.isEmpty
                    ? const Center(
                      child: Text(
                        'لا توجد إشعارات',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                    : ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 20.h,
                      ),
                      itemBuilder:
                          (context, index) => NotificationItem(
                            notifications: state.notifications[index],
                          ),
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: state.notifications.length,
                    ),
              NotificationStatus.readSuccess => const SizedBox.shrink(),
              NotificationStatus.readFailure => const SizedBox.shrink(),
            },
          );
        },
      ),
    );
  }
}

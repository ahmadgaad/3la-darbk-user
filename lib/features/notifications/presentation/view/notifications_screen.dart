import 'package:ala_darbak_user/core/translations/locale_keys.g.dart';
import 'package:ala_darbak_user/features/notifications/presentation/view/components/notification_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

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
              // const Center(child: CircularProgressIndicator.adaptive()),
              ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                itemBuilder:
                    (context, index) => const NotificationItemShimmer(),
                separatorBuilder: (_, __) => 20.verticalSpace,
                itemCount: 6,
              ),
              NotificationStatus.failure => Center(
                child: Text(state.errorMessage),
              ),
              NotificationStatus.success =>
                state.notifications.isEmpty
                    ? Center(
                      child: Text(
                        LocaleKeys.there_no_notificatation.tr(),
                        style: const TextStyle(
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

class NotificationItemShimmer extends StatelessWidget {
  const NotificationItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        spacing: 8.h,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 150.w,
              height: 16.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: double.infinity,
              height: 14.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              width: 80.w,
              height: 12.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

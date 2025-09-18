import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';

import '../../repositories/model/notifications_model.dart';


class NotificationItem extends StatelessWidget {
  final NotificationsModel? notifications;
  const NotificationItem({super.key, this.notifications});

  @override
  Widget build(BuildContext context) {
    return  Column(
      spacing: 8.h,
      children: [
        if(notifications?.title!=null)
        Align(
            alignment: Alignment.topRight,
            child: Text(notifications?.title??"",style:  const TextStyle(fontWeight: FontWeight.bold),)),
        if(notifications?.body!=null)
        Align(
            alignment: Alignment.topRight,
            child: Text(notifications?.body??"")),
        Align(
            alignment: Alignment.bottomLeft,
            child: Text(Jiffy.parse((notifications?.createdAt??"")).yMd)),
      ],
    );
  }
}

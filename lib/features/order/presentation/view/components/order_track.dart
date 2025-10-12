import 'package:ala_darbak_user/core/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/config/style/app_color.dart';
import '../../../../../core/config/style/app_text_styles.dart';

class OrderTrack extends StatelessWidget {
  final int status;
  const OrderTrack({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return status >= 4
        ? Container(
          color: AppColors.primary,
          padding: EdgeInsets.symmetric(vertical: 15.w),
          child: Center(
            child: Text(
              status == 5
                  ? LocaleKeys.canceled.tr()
                  : LocaleKeys.not_approved.tr(),
              style: AppTextStyle.font18white600,
            ),
          ),
        )
        : Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Stack(
            children: [
              _lineBuilder(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _statusBuilder(status >= 0, LocaleKeys.order_sent.tr()),
                  _statusBuilder(status >= 1, LocaleKeys.order_accepted.tr()),
                  _statusBuilder(status >= 2, LocaleKeys.order_picked.tr()),
                  _statusBuilder(status >= 3, LocaleKeys.order_delivered.tr()),
                ],
              ),
            ],
          ),
        );
  }

  Widget _statusBuilder(bool isSelecet, String text) => Column(
    spacing: 10.w,
    children: [
      Container(
        width: 25.w,
        height: 25.w,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.desSelected, width: 2),
          shape: BoxShape.circle,
          color: AppColors.backGround,
        ),
        child: Center(
          child: Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: isSelecet ? AppColors.primary : Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
      Text(text, style: AppTextStyle.font14black600),
    ],
  );
  Widget _lineBuilder() => Container(
    height: 2,
    margin: EdgeInsets.only(top: 12.5.w, left: 25.w, right: 25.w),
    color: AppColors.desSelected,
  );
}

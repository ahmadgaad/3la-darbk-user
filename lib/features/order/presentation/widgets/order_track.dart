import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/style/app_color.dart';
import '../../../../config/style/app_text_styles.dart';
import '../../../../core/utils/app_utils/app_strings.dart';

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
                status == 5 ? AppStrings.canceled : AppStrings.notApproved,
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
                    _statusBuilder(status >= 0, AppStrings.orderSent),
                    _statusBuilder(status >= 1, AppStrings.orderAccepted),
                    _statusBuilder(status >= 2, AppStrings.orderPicked),
                    _statusBuilder(status >= 3, AppStrings.orderDelivered),
                  ],
                ),
              ],
            )
            //  Column(
            //   spacing: 15.h,
            //   children: [
            //     Padding(
            //       padding:  EdgeInsets.symmetric(horizontal: 18.w),
            //       child: Row(
            //         children: [
            //           _dotBuilder(status>=0),
            //           Flexible(child: _lineBuilder()),
            //           _dotBuilder(status>=1),
            //           Flexible(child: _lineBuilder()),
            //           _dotBuilder(status>=2),
            //           Flexible(child: _lineBuilder()),
            //           _dotBuilder(status>=3),
            //         ],
            //       ),
            //     ),
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         _textBuild(AppStrings.orderSent),
            //         _textBuild(AppStrings.orderAccepted),
            //         _textBuild(AppStrings.orderPicked),
            //         _textBuild(AppStrings.orderDelivered),
            //       ],
            //     )
            //   ],
            // ),
            );
  }

  Widget _statusBuilder(
    bool isSelecet,
    String text,
  ) =>
      Column(
        spacing: 10.w,
        children: [
          Container(
            width: 25.w,
            height: 25.w,
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.desSelected, width: 2),
                shape: BoxShape.circle,
                color: AppColors.backGround),
            child: Center(
              child: Container(
                  width: 15.w,
                  height: 15.w,
                  decoration: BoxDecoration(
                    color: isSelecet ? AppColors.primary : Colors.transparent,
                    shape: BoxShape.circle,
                  )),
            ),
          ),
          Text(
            text,
            style: AppTextStyle.font14black600,
          ),
        ],
      );
  Widget _lineBuilder() => Container(
        height: 2,
        margin: EdgeInsets.only(top: 12.5.w, left: 25.w, right: 25.w),
        color: AppColors.desSelected,
      );
}

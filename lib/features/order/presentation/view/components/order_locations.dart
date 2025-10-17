import 'package:ala_darbak_user/core/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/config/style/app_color.dart';
import '../../../../../core/config/style/app_text_styles.dart';
import '../../../../../core/heplers/location_helper.dart';
import '../../../data/model/order_location_model.dart';

class OrderLocations extends StatelessWidget {
  final OrderLocationModel? orderLocationModel;

  const OrderLocations({super.key, this.orderLocationModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final orderLocationModel = this.orderLocationModel;
        if (orderLocationModel != null) {
          LocationHelper.launchDirections(
            fromLocation: orderLocationModel.pickupLocation!,
            toLocation: orderLocationModel.destinationLocation!,
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: 10.w,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(FontAwesomeIcons.locationDot),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 7.5.h),
                  width: 2,
                  height: 50.w,
                  color: AppColors.desSelected,
                ),
                const Icon(Icons.gps_not_fixed),
              ],
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 40.w,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    minTileHeight: 0,
                    minVerticalPadding: 0,
                    title: Text(
                      LocaleKeys.pickup_location.tr(),
                      style: AppTextStyle.font12desSelected600,
                    ),
                    subtitle: Text(
                      orderLocationModel?.pickupAddress ??
                          LocaleKeys.select_pickup_location.tr(),
                      style: AppTextStyle.font14black600.copyWith(height: 2),
                      maxLines: 1,
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    minTileHeight: 0,
                    minVerticalPadding: 0,
                    title: Text(
                      LocaleKeys.delivery_location.tr(),
                      style: AppTextStyle.font12desSelected600,
                    ),
                    subtitle: Text(
                      orderLocationModel?.destinationAddress ??
                          LocaleKeys.select_destination_location.tr(),
                      style: AppTextStyle.font14black600.copyWith(height: 2),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

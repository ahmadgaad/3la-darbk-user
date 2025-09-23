import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/config/style/app_color.dart';
import '../../../../core/config/style/app_text_styles.dart';
import '../../../../core/utils/app_utils/app_strings.dart';
import '../../../../core/utils/heplers/map_utils.dart';
import '../../../map/repositories/models/order_location_model.dart';

class OrderLocations extends StatelessWidget {
  final OrderLocationModel? orderLocationModel;

  const OrderLocations({super.key, this.orderLocationModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final orderLocationModel = this.orderLocationModel;
        if (orderLocationModel != null) {
          MapUtils.launchDirections(
              fromLocation: orderLocationModel.pickupLocation!,
              toLocation: orderLocationModel.destinationLocation!);
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
                const Icon(Icons.gps_not_fixed)
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
                      AppStrings.pickupLocation,
                      style: AppTextStyle.font12desSelected600,
                    ),
                    subtitle: Text(
                      orderLocationModel?.pickupAddress ??
                          AppStrings.selectPickupLocation,
                      style: AppTextStyle.font14black600.copyWith(height: 2),
                      maxLines: 1,
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    minTileHeight: 0,
                    minVerticalPadding: 0,
                    title: Text(
                      AppStrings.deliveryLocation,
                      style: AppTextStyle.font12desSelected600,
                    ),
                    subtitle: Text(
                      orderLocationModel?.destinationAddress ??
                          AppStrings.selectDestinationLocation,
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

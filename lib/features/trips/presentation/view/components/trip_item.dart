import 'package:ala_darbak_user/core/config/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/config/style/app_color.dart';
import '../../../../../core/config/style/app_text_styles.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../order/presentation/view_model/order_cubit/cubit.dart';
import '../../../data/model/trip_model.dart';

class TripItem extends StatelessWidget {
  final TripModel? trip;
  const TripItem({super.key, this.trip});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.desSelected, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.startCity,
                  style: AppTextStyle.font12desSelected600,
                ),
                7.5.verticalSpaceFromWidth,
                Text(
                  trip?.cityFrom?.name ?? "",
                  style: AppTextStyle.font14black600,
                  maxLines: 2,
                ),
                40.verticalSpaceFromWidth,
                Text(
                  AppStrings.destenationCity,
                  style: AppTextStyle.font12desSelected600,
                ),
                7.5.verticalSpaceFromWidth,
                Text(
                  trip?.cityTo?.name ?? "",
                  style: AppTextStyle.font14black600,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          Column(
            spacing: 15.h,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${AppStrings.tripNumber} #${trip?.numTrip ?? ""}',
                style: AppTextStyle.font14black600,
              ),
              Text(
                '${trip?.date ?? ""} ${trip?.time ?? ""}',
                style: AppTextStyle.font14black600,
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<OrderCubit>().reset();
                  context.read<OrderCubit>().setTrip(trip);
                  Navigator.of(context).pushNamed(AppRoutes.orderCategories);
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size.fromHeight(40.w),
                ),
                child: const Text(AppStrings.addOrder),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

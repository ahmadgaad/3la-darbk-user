import 'package:ala_darbak_user/core/config/router/app_routes.dart';
import 'package:ala_darbak_user/core/enum/shipment_status.dart';
import 'package:ala_darbak_user/core/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/config/style/app_color.dart';
import '../../../../../core/config/style/app_text_styles.dart';
import '../../../../order/data/model/order_model.dart';
import '../../../../order/presentation/view_model/order_cubit/order_cubit.dart';

class ShipmentCard extends StatelessWidget {
  final OrderModel orderModel;
  const ShipmentCard({super.key, required this.orderModel});

  @override
  Widget build(BuildContext context) {
    final status = ShipmentStatusX.fromInt(orderModel.status ?? 0);

    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.desSelected, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.w),
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
                    height: 55.w,
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
                      LocaleKeys.pickup_location.tr(),
                      style: AppTextStyle.font12desSelected600,
                    ),
                    7.5.verticalSpaceFromWidth,
                    Text(
                      orderModel.pickupAddress ?? "",
                      style: AppTextStyle.font14black600.copyWith(height: 1.3),
                      maxLines: 1,
                    ),
                    40.verticalSpaceFromWidth,
                    Text(
                      LocaleKeys.delivery_location.tr(),
                      style: AppTextStyle.font12desSelected600,
                    ),
                    7.5.verticalSpaceFromWidth,
                    Text(
                      orderModel.deliveryAddress ?? "",
                      style: AppTextStyle.font14black600.copyWith(height: 1.3),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              Column(
                spacing: 5.w,
                children: [
                  Text(
                    '${LocaleKeys.order_number.tr()} #${orderModel.numOrder}',
                    style: AppTextStyle.font14black600,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<OrderCubit>().setOrderModel(orderModel);
                      Navigator.pushNamed(
                        context,
                        AppRoutes.orderDetails,
                        arguments: orderModel.id ?? 1,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size.fromHeight(40.h),
                    ),
                    child: Text(LocaleKeys.details.tr()),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: status.color,
            borderRadius: const BorderRadiusDirectional.only(
              topEnd: Radius.circular(10),
              bottomStart: Radius.circular(10),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.w),
          child: Text(status.label, style: AppTextStyle.font12white600),
        ),
      ],
    );
  }
}

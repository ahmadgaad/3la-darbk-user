import 'package:ala_darbak_user/features/order/presentation/view/components/order_location_pickup_components/destination_location_list_tile.dart';
import 'package:ala_darbak_user/features/order/presentation/view/components/order_location_pickup_components/pickup_location_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/config/style/app_color.dart';
import '../../../view_model/order_cubit/order_cubit.dart';
import '../../../view_model/order_cubit/order_states.dart';
import '../../../view_model/order_map_cubit/cubit.dart';

class OrderLocationSelector extends StatelessWidget {
  const OrderLocationSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final orderMapCubit = OrderMapCubit.get(context);
    return BlocBuilder<OrderCubit, OrderStates>(
      builder: (context, state) {
        final orderCubit = context.read<OrderCubit>();
        final orderLocationModel = state.orderLocationModel;
        return Container(
          decoration: BoxDecoration(
            color: AppColors.backGround,
            border: Border.all(color: AppColors.desSelected, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10.w,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(FontAwesomeIcons.locationDot),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5.w),
                    width: 2,
                    height: 62.w,
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
                    PickUpLocationListTile(
                      orderLocationModel: orderLocationModel,
                      orderCubit: orderCubit,
                      orderMapCubit: orderMapCubit,
                    ),
                    DestinationLocationListTile(
                      orderLocationModel: orderLocationModel,
                      orderCubit: orderCubit,
                      orderMapCubit: orderMapCubit,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

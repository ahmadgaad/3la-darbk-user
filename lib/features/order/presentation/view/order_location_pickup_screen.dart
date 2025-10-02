import 'package:ala_darbak_user/features/order/presentation/view/components/order_location_pickup_components/order_confirmation_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../map/presentation/view/components/order_map.dart';
import '../view_model/order_cubit/cubit.dart';
import '../view_model/order_cubit/state.dart';
import 'components/order_location_pickup_components/order_locations_selector.dart';

class OrderLocationPickupScreen extends StatelessWidget {
  const OrderLocationPickupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.choosePickupAndDelivery),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          const OrderGoogleMap(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: const OrderLocationSelector(),
          ),
        ],
      ),

      bottomSheet: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          return state.orderLocationModel.destinationLocation != null &&
                  state.orderLocationModel.pickupLocation != null
              ? DraggableScrollableSheet(
                expand: false,
                initialChildSize: .4,
                minChildSize: 0.15,
                maxChildSize: .4,
                builder:
                    (_, scrollController) =>
                        OrderConfirmationSheet(state, scrollController),
              )
              : const SizedBox.shrink();
        },
      ),
    );
  }
}

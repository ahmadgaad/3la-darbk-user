import 'package:ala_darbak_user/core/translations/locale_keys.g.dart';
import 'package:ala_darbak_user/features/order/presentation/view/components/order_location_pickup_components/order_confirmation_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../map/presentation/view/components/order_map.dart';
import '../view_model/order_cubit/order_cubit.dart';
import '../view_model/order_cubit/order_states.dart';
import 'components/order_location_pickup_components/order_locations_selector.dart';

class OrderLocationPickupScreen extends StatelessWidget {
  const OrderLocationPickupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.choose_pickup_and_delivery.tr()),
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

      bottomSheet: BlocBuilder<OrderCubit, OrderStates>(
        builder: (context, state) {
          final location = state.orderLocationModel;
          return Visibility(
            visible:
                location.destinationLocation != null &&
                location.pickupLocation != null,
            replacement: const SizedBox.shrink(),
            child: DraggableScrollableSheet(
              expand: false,
              initialChildSize: .4,
              minChildSize: 0.15,
              maxChildSize: .4,
              builder: (_, scrollController) {
                return OrderConfirmationSheet(state, scrollController);
              },
            ),
          );
        },
      ),
    );
  }
}

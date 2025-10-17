import 'package:ala_darbak_user/core/config/router/app_routes.dart';
import 'package:ala_darbak_user/core/translations/locale_keys.g.dart';
import 'package:ala_darbak_user/features/shipments/presentation/view/components/shipment_card_shimmer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../order/presentation/view_model/order_cubit/cubit.dart';
import '../../../order/presentation/view_model/order_cubit/state.dart';
import '../view_model/shipments_cubit.dart';
import '../view_model/shipments_states.dart';
import 'components/shipment_card.dart';

class ActiveShipmentsView extends StatefulWidget {
  const ActiveShipmentsView({super.key});

  @override
  State<ActiveShipmentsView> createState() => _ActiveShipmentsViewState();
}

class _ActiveShipmentsViewState extends State<ActiveShipmentsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<OrderCubit, OrderState>(
        listener: (context, orderState) {
          // Refresh shipments when a new order is created
          if (orderState.orderCreated == true) {
            context.read<ShipmentsCubit>().getActiveShipments();
            // Reset the flag to prevent multiple refreshes
            context.read<OrderCubit>().resetOrderCreatedFlag();
          }
        },
        child: BlocBuilder<ShipmentsCubit, ShipmentsState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                await context.read<ShipmentsCubit>().getActiveShipments();
              },
              child: switch (state.status) {
                ShipmentsStatus.initial ||
                ShipmentsStatus.loading => ListView.separated(
                  padding: EdgeInsets.only(
                    left: 20.w,
                    right: 20.w,
                    top: 24.h,
                    bottom: 115,
                  ),
                  itemBuilder: (context, index) => const ShipmentCardShimmer(),
                  separatorBuilder:
                      (context, index) => 15.verticalSpaceFromWidth,
                  itemCount: 10,
                ),
                // const Center(child: CircularProgressIndicator.adaptive()),
                ShipmentsStatus.error => Center(
                  child: Text(state.errorMessage ?? ""),
                ),
                ShipmentsStatus.success =>
                  state.activeShipments.isEmpty
                      ? Center(
                        child: Text(
                          LocaleKeys.no_orders.tr(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                      : ListView.separated(
                        padding: EdgeInsets.only(
                          left: 20.w,
                          right: 20.w,
                          top: 24.h,
                          bottom: 115,
                        ),
                        itemBuilder:
                            (context, index) => ShipmentCard(
                              orderModel: state.activeShipments[index],
                            ),
                        separatorBuilder:
                            (context, index) => 15.verticalSpaceFromWidth,
                        itemCount: state.activeShipments.length,
                      ),
              },
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SizedBox(
          width: double.infinity,
          height: 50.w,
          child: FloatingActionButton.extended(
            onPressed: () {
              context.read<OrderCubit>().reset();
              Navigator.of(context).pushNamed(AppRoutes.orderCategories);
            },
            icon: const Icon(Icons.add),
            label: Text(LocaleKeys.add_order.tr()),
          ),
        ),
      ),
    );
  }
}

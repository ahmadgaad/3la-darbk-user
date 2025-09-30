import 'package:ala_darbak_user/core/config/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../order/presentation/manager/order_cubit/cubit.dart';
import '../view_model/shipments_cubit.dart';
import '../view_model/shipments_states.dart';
import 'components/order_item.dart';

class ActiveShipmentsView extends StatelessWidget {
  const ActiveShipmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ShipmentsCubit, ShipmentsStates>(
        builder: (context, state) {
          final activeShipments = state.activeOrders;
          return RefreshIndicator(
            onRefresh: () async {
              await context.read<ShipmentsCubit>().getActiveShipments();
            },
            child:
                state.activeOrders.isEmpty
                    ? const Center(
                      child: Text(
                        AppStrings.noOrders,
                        style: TextStyle(
                          fontSize: 16,
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
                          (BuildContext context, int index) =>
                              OrderItem(orderModel: state.activeOrders[index]),
                      separatorBuilder:
                          (BuildContext context, int index) =>
                              15.verticalSpaceFromWidth,
                      itemCount: activeShipments.length,
                    ),
          );
        },
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
            label: const Text(AppStrings.addOrder),
          ),
        ),
      ),
    );
  }
}

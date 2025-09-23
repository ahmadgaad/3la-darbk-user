import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/routes/app_routes.dart';
import '../../../../core/utils/app_utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../order/presentation/manager/order_cubit/cubit.dart';
import '../manager/cubit.dart';
import '../manager/state.dart';
import '../widgets/order_item.dart';

class ActiveOrdersView extends StatelessWidget {
  const ActiveOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          final activeOrders = state.activeOrders;
          return RefreshIndicator(
            onRefresh: () async {
              return await context.read<OrdersCubit>().getActiveOrders();
            },
            child: state.activeOrders.isEmpty
                ?  ListView(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 24.h, bottom: 115),
                  children: [
                    const Center(child: Text(AppStrings.noOrders)),
                  ],
                )
                : ListView.separated(
                    padding: EdgeInsets.only(
                        left: 20.w, right: 20.w, top: 24.h, bottom: 115),
                    itemBuilder: (BuildContext context, int index) => OrderItem(
                      orderModel: state.activeOrders[index],
                    ),
                    separatorBuilder: (BuildContext context, int index) =>
                        15.verticalSpaceFromWidth,
                    itemCount: activeOrders.length,
                  ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
        ),
        child: SizedBox(
          width: double.infinity,
          height: 50.w,
          child: FloatingActionButton.extended(
            onPressed: () {
              context.read<OrderCubit>().reset();
              Navigator.of(context).pushNamed(AppRoute.orderCategories);
            },
            icon: const Icon(Icons.add),
            label: const Text(AppStrings.addOrder),
          ),
        ),
      ),
    );
  }
}

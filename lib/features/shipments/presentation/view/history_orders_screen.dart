import 'package:ala_darbak_user/core/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/style/app_theme.dart';
import '../view_model/shipments_cubit.dart';
import '../view_model/shipments_states.dart';
import 'components/order_item.dart';

class HistoryOrdersScreen extends StatefulWidget {
  const HistoryOrdersScreen({super.key});

  @override
  State<HistoryOrdersScreen> createState() => _HistoryOrdersScreenState();
}

class _HistoryOrdersScreenState extends State<HistoryOrdersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ShipmentsCubit>().getHistoryOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: homeTheme,
      child: Scaffold(
        appBar: AppBar(title: Text(LocaleKeys.orders_history.tr())),
        body: BlocBuilder<ShipmentsCubit, ShipmentsState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                return await context.read<ShipmentsCubit>().getHistoryOrders();
              },
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 24.h,
                    ),
                    sliver: SliverList.separated(
                      itemBuilder:
                          (context, index) => OrderItem(
                            orderModel: state.shipmentsHistory[index],
                          ),
                      separatorBuilder:
                          (context, index) => 15.verticalSpaceFromWidth,
                      itemCount: state.shipmentsHistory.length,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

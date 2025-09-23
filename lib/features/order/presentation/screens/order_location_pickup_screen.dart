import '../../../setttings_info/presentation/manager/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/config/style/app_color.dart';
import '../../../../core/config/style/app_text_styles.dart';
import '../../../../core/utils/app_utils/app_strings.dart';
import '../../../../core/utils/heplers/map_utils.dart';
import '../../../map/presentation/widgets/order_map.dart';
import '../manager/order_cubit/cubit.dart';
import '../manager/order_cubit/state.dart';
import '../components/order_pick_locations.dart';

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
            child: const OrderPickLocations(),
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
                  builder: (BuildContext context,
                          ScrollController scrollController) =>
                      _orderConfirmation(context, state, scrollController),
                )
              : const SizedBox();
        },
       
      ),
    );
  }

  Widget _orderConfirmation(BuildContext context, OrderState state,
          ScrollController scrollController) {
            final cubit = context.read<SettingsInfoCubit>();
            final averageOrderPrice=cubit.state.settingsInfo?.averageOrderPrice;
            final averageTripPrice=cubit.state.settingsInfo?.averageTripPrice;
              return SingleChildScrollView(
                  controller: scrollController,
                  padding:
            EdgeInsets.only(left: 16.w, right: 16.w, top: 10.w, bottom: 10.w),
                  child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 20.w,
          children: [
            Center(
              child: Container(
                width: 50.w,
                height: 3,
                decoration: const BoxDecoration(color: AppColors.black),
              ),
            ),
            Text(
              AppStrings.orderPrice,
              style: AppTextStyle.font16black600,
              textAlign: TextAlign.center,
            ),
            RichText(
              text: TextSpan(
                text: state.trip!=null?averageTripPrice.toString():averageOrderPrice.toString(),
                style: AppTextStyle.font24primary600,
                children: <TextSpan>[
                  TextSpan(
                      text: ' ${AppStrings.sar}',
                      style: AppTextStyle.font14black500),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            Row(
              spacing: 15.w,
              children: [
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary),
                      onPressed: () {
                        if (state.loading) return;
                        context.read<OrderCubit>().createOrder(context);
                      },
                      child: state.loading
                          ? const Center(
                              child: CircularProgressIndicator(
                              color: AppColors.white,
                            ))
                          : const Text(AppStrings.confirmOrderAndSearch)),
                ),
                IconButton(
                    onPressed: () {
                      MapUtils.launchDirections(
                        fromLocation: state.orderLocationModel.pickupLocation!,
                        toLocation:
                            state.orderLocationModel.destinationLocation!,
                      );
                    },
                    icon: const Icon(
                      FontAwesomeIcons.mapLocationDot,
                      color: AppColors.primary,
                      size: 35,
                    )),
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(AppStrings.cancel)),
          ],
                  ),
                );
            }
}

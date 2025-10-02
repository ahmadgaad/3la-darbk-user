import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/config/style/app_color.dart';
import '../../../../../../core/config/style/app_text_styles.dart';
import '../../../../../../core/utils/app_strings.dart';
import '../../../../../map/presentation/view/location_selection_screen.dart';
import '../../../view_model/order_cubit/cubit.dart';
import '../../../view_model/order_cubit/state.dart';
import '../../../view_model/order_map_cubit/cubit.dart';

class OrderLocationSelector extends StatelessWidget {
  const OrderLocationSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final orderMapCubit = OrderMapCubit.get(context);
    return BlocBuilder<OrderCubit, OrderState>(
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
                    ListTile(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => LocationSelectionScreen(
                                  initialLocation:
                                      orderLocationModel.pickupLocation,
                                  isDestination: false,
                                ),
                          ),
                        );
                        if (result != null) {
                          orderCubit.setOrderlocation(
                            orderLocationModel: orderLocationModel.copyWith(
                              pickupLocation: result['location'],
                              pickupAddress: result['address'],
                            ),
                          );
                          orderMapCubit.setMarkersAndPolylines(
                            orderLocationModel.copyWith(
                              pickupLocation: result['location'],
                              pickupAddress: result['address'],
                            ),
                          );
                        }
                      },
                      contentPadding: EdgeInsets.zero,
                      minTileHeight: 0,
                      minVerticalPadding: 0,
                      title: Text(
                        AppStrings.pickupLocation,
                        style: AppTextStyle.font12desSelected600,
                      ),
                      subtitle: Text(
                        orderLocationModel.pickupAddress ??
                            AppStrings.selectPickupLocation,
                        style: AppTextStyle.font14black600.copyWith(height: 2),
                        maxLines: 1,
                      ),
                    ),
                    ListTile(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => LocationSelectionScreen(
                                  initialLocation:
                                      orderLocationModel.destinationLocation ??
                                      orderLocationModel.pickupLocation,
                                  isDestination: true,
                                ),
                          ),
                        );
                        if (result != null) {
                          orderCubit.setOrderlocation(
                            orderLocationModel: orderLocationModel.copyWith(
                              destinationLocation: result['location'],
                              destinationAddress: result['address'],
                            ),
                          );
                          orderMapCubit.setMarkersAndPolylines(
                            orderLocationModel.copyWith(
                              destinationLocation: result['location'],
                              destinationAddress: result['address'],
                            ),
                          );
                        }
                      },
                      contentPadding: EdgeInsets.zero,
                      minTileHeight: 0,
                      minVerticalPadding: 0,
                      title: Text(
                        AppStrings.deliveryLocation,
                        style: AppTextStyle.font12desSelected600,
                      ),
                      subtitle: Text(
                        orderLocationModel.destinationAddress ??
                            AppStrings.selectDestinationLocation,
                        style: AppTextStyle.font14black600.copyWith(height: 2),
                        maxLines: 1,
                      ),
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

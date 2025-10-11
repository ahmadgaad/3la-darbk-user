import 'package:ala_darbak_user/core/translations/locale_keys.g.dart';
import 'package:ala_darbak_user/features/map/data/models/order_location_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/config/style/app_text_styles.dart';
import '../../../../../map/presentation/view/location_selection_screen.dart';
import '../../../view_model/order_cubit/cubit.dart';
import '../../../view_model/order_map_cubit/cubit.dart';

class PickUpLocationListTile extends StatelessWidget {
  const PickUpLocationListTile({
    super.key,
    required this.orderLocationModel,
    required this.orderCubit,
    required this.orderMapCubit,
  });

  final OrderLocationModel orderLocationModel;
  final OrderCubit orderCubit;
  final OrderMapCubit orderMapCubit;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => LocationSelectionScreen(
                  initialLocation: orderLocationModel.pickupLocation,
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
        LocaleKeys.pickup_location.tr(),
        style: AppTextStyle.font12desSelected600,
      ),
      subtitle: Text(
        orderLocationModel.pickupAddress ??
            LocaleKeys.select_pickup_location.tr(),
        style: AppTextStyle.font14black600.copyWith(height: 2),
        maxLines: 1,
      ),
    );
  }
}

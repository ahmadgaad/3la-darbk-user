import 'package:ala_darbak_user/core/translations/locale_keys.g.dart';
import 'package:ala_darbak_user/features/order/data/model/order_location_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../../core/config/style/app_text_styles.dart';
import '../../../../../map/presentation/view/location_selection_screen.dart';
import '../../../view_model/order_cubit/order_cubit.dart';
import '../../../view_model/order_map_cubit/cubit.dart';

class DestinationLocationListTile extends StatelessWidget {
  const DestinationLocationListTile({
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
        final trip = orderCubit.state.trip;
        final String? latStr = trip?.latitude;
        final String? lngStr = trip?.longitude;
        final double? lat = latStr == null ? null : double.tryParse(latStr);
        final double? lng = lngStr == null ? null : double.tryParse(lngStr);
        final LatLng? driverLatLng =
            lat != null && lng != null ? LatLng(lat, lng) : null;
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => LocationSelectionScreen(
                  initialLocation:
                      orderLocationModel.destinationLocation ??
                      orderLocationModel.pickupLocation ??
                      driverLatLng,
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
        LocaleKeys.delivery_location.tr(),
        style: AppTextStyle.font12desSelected600,
      ),
      subtitle: Text(
        orderLocationModel.destinationAddress ??
            LocaleKeys.select_destination_location.tr(),
        style: AppTextStyle.font14black600.copyWith(height: 2),
        maxLines: 1,
      ),
    );
  }
}

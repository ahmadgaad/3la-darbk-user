import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../core/config/style/app_color.dart';
import '../../view_model/map_cubit.dart';
import '../../view_model/map_states.dart';

class PickLocationMap extends StatelessWidget {
  const PickLocationMap({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PickLocationCubit, PickLocationState>(
      builder: (context, state) {
        final pickLocationCubit = PickLocationCubit.get(context);
        return Stack(
          alignment: Alignment.center,
          children: [
            GoogleMap(
              initialCameraPosition: pickLocationCubit.initialCameraPosition,
              onMapCreated: pickLocationCubit.onMapCreate,
              onCameraIdle: () async {
                pickLocationCubit.getAddress();
              },
              onCameraMove: pickLocationCubit.onCameraMove,
              myLocationEnabled: true,
              mapType: MapType.normal, // Use MapType.none for minimal rendering
              trafficEnabled: false,
              buildingsEnabled: false,
              indoorViewEnabled: false,
              // padding: EdgeInsets.only(bottom: 140.h),
              minMaxZoomPreference: const MinMaxZoomPreference(5, 20),
              cameraTargetBounds: CameraTargetBounds(
                LatLngBounds(
                  southwest: const LatLng(16.3475, 34.4959), // SW boundary
                  northeast: const LatLng(32.1540, 55.6667), // NE boundary
                ),
              ),
              zoomGesturesEnabled: true,
              scrollGesturesEnabled: true,
              rotateGesturesEnabled: true,
              tiltGesturesEnabled: true,
              compassEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              gestureRecognizers:
                  <Factory<OneSequenceGestureRecognizer>>{}.toSet(),
              // gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{}..add(
              //     Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())),
            ),
            const Icon(
              FontAwesomeIcons.locationDot,
              size: 35,
              color: AppColors.primary,
            ),
          ],
        );
      },
    );
  }
}

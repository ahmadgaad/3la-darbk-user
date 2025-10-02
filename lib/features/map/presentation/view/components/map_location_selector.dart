import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../core/config/style/app_color.dart';
import '../../view_model/map_cubit.dart';
import '../../view_model/map_states.dart';

class MapLocationSelectorWidget extends StatelessWidget {
  const MapLocationSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, MapStates>(
      // buildWhen: (_, current) => current.address != null,
      builder: (context, state) {
        final pickLocationCubit = context.read<MapCubit>();
        return Stack(
          alignment: Alignment.center,
          children: [
            GoogleMap(
              initialCameraPosition: pickLocationCubit.initialCameraPosition,
              onMapCreated: pickLocationCubit.onMapCreate,
              onCameraIdle: () async {
                await pickLocationCubit.getAddress(
                  position: pickLocationCubit.currentPosition,
                );
              },
              onCameraMove: (position) {
                pickLocationCubit.currentPosition = position.target;
              },
              myLocationEnabled: true,
              mapType: MapType.normal,
              trafficEnabled: false,
              buildingsEnabled: false,
              indoorViewEnabled: false,
              minMaxZoomPreference: const MinMaxZoomPreference(5, 20),
              // cameraTargetBounds: CameraTargetBounds(
              //   LatLngBounds(
              //     southwest: const LatLng(16.3475, 34.4959), // SW boundary
              //     northeast: const LatLng(32.1540, 55.6667), // NE boundary
              //   ),
              // ),
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

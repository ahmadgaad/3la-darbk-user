import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../../../../core/config/style/app_color.dart';
import '../../view_model/map_cubit.dart';
import '../../view_model/map_states.dart';

class MapLocationSelectorWidget extends StatelessWidget {
  const MapLocationSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, MapStates>(
      buildWhen:
          (previous, current) =>
              previous.initializingLocation != current.initializingLocation,
      builder: (context, state) {
        final cubit = context.read<MapCubit>();
        return LoadingOverlay(
          isLoading: state.initializingLocation,
          child: Stack(
            alignment: Alignment.center,
            children: [
              GoogleMap(
                initialCameraPosition: cubit.initialCameraPosition,
                onMapCreated: cubit.onMapCreate,
                onCameraIdle: () async {
                  await cubit.getAddress(position: cubit.currentLatLng);
                },
                onCameraMove: (position) {
                  cubit.currentLatLng = position.target;
                },
                myLocationEnabled: true,
                mapType: MapType.normal,
                trafficEnabled: false,
                buildingsEnabled: false,
                indoorViewEnabled: false,
                minMaxZoomPreference: const MinMaxZoomPreference(5, 20),
                zoomGesturesEnabled: true,
                scrollGesturesEnabled: true,
                rotateGesturesEnabled: true,
                tiltGesturesEnabled: true,
                compassEnabled: false,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                gestureRecognizers:
                    <Factory<OneSequenceGestureRecognizer>>{}.toSet(),
              ),
              const Icon(
                FontAwesomeIcons.locationDot,
                size: 35,
                color: AppColors.primary,
              ),
            ],
          ),
        );
      },
    );
  }
}

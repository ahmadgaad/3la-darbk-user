import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../order/presentation/manager/order_map_cubit/cubit.dart';
import '../../../order/presentation/manager/order_map_cubit/state.dart';

class OrderGoogleMap extends StatelessWidget {
  const OrderGoogleMap({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderMapCubit,OrderMapState>(
      builder: (context,state) {
        final cubit=OrderMapCubit.get(context);
        return GoogleMap(
          markers: Set<Marker>.of(state.markers.values),
          polylines: Set<Polyline>.of(state.polyline.values),
          initialCameraPosition:cubit.initialCameraPosition,
          onMapCreated: cubit.onMapCreate,
          myLocationEnabled: true,
          mapType: MapType.normal, // Use MapType.none for minimal rendering
          trafficEnabled: false,
          buildingsEnabled: false,
          indoorViewEnabled: false,
          padding: const EdgeInsets.only(bottom: 140,),
          minMaxZoomPreference: const MinMaxZoomPreference(5, 20),
          
          cameraTargetBounds: CameraTargetBounds(   LatLngBounds(
            southwest: const LatLng(16.3475, 34.4959), // SW boundary
            northeast: const LatLng(32.1540, 55.6667), // NE boundary
          ),),
                    zoomGesturesEnabled: true,
          scrollGesturesEnabled: true,
          rotateGesturesEnabled: true,
          tiltGesturesEnabled: true,
          compassEnabled: false,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{}.toSet(),
          // gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{}..add(
          //     Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())),
        );
      }
    );
  }
}

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../core/heplers/map_utils.dart';
import '../../../../map/data/repository/map_repo.dart';
import '../../../../map/data/models/order_location_model.dart';
import 'state.dart';

class OrderMapCubit extends Cubit<OrderMapState> {
  final MapRepo _mapRepo;
  OrderMapCubit(this._mapRepo)
    : super(OrderMapState(polyline: {}, markers: {}));

  static OrderMapCubit get(BuildContext context) =>
      context.read<OrderMapCubit>();

  Completer<GoogleMapController> controller = Completer<GoogleMapController>();
  LatLng currentPosition = const LatLng(23.8859, 45.0792);
  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(23.8859, 45.0792), // Center of Saudi Arabia
    zoom: 5,
  );
  init([LatLng? location]) {
    if (location != null) {
      initialCameraPosition = CameraPosition(
        target: location, // Center of Saudi Arabia
        zoom: 15,
      );
    }
  }

  onMapCreate(GoogleMapController controller) {
    this.controller = Completer<GoogleMapController>();
    this.controller.complete(controller);
  }

  double distance = 0;
  void setMarkersAndPolylines(OrderLocationModel orderLocationModel) {
    if (orderLocationModel.pickupLocation != null) {
      setPickUpMarker(location: orderLocationModel.pickupLocation!);
    }
    if (orderLocationModel.destinationLocation != null) {
      setDestenationMarker(location: orderLocationModel.destinationLocation!);
    }
    _setPickUpToDestinationPolyline();
  }

  setPickUpMarker({required LatLng location}) {
    initialCameraPosition = CameraPosition(
      target: location, // Center of Saudi Arabia
      zoom: 15,
    );
    const markerId = MarkerId("pickup");
    final markers = state.markers;
    final marker = markers[markerId];
    if (marker == null) {
      markers[markerId] = Marker(
        markerId: markerId,
        position: location,
        onTap: () {
          // _moveCamera(location);
        },
      );
    } else {
      markers[markerId] = marker.copyWith(positionParam: location);
    }
    emit(state.copyWith(markers: markers));
  }

  setDestenationMarker({required LatLng location}) {
    const markerId = MarkerId("destination");
    final markers = state.markers;

    final marker = markers[markerId];
    if (marker == null) {
      markers[markerId] = Marker(
        markerId: markerId,
        position: location,
        onTap: () {
          // _moveCamera(location);
        },
      );
    } else {
      markers[markerId] = marker.copyWith(positionParam: location);
    }
    emit(state.copyWith(markers: markers));
  }

  _moveCamera(position) {
    MapUtils.moveCamera(controller: controller, target: position, zoom: 15);
  }

  _setPickUpToDestinationPolyline() async {
    const polylineId = PolylineId('pickUpToDestination');
    final markers = state.markers;
    final polyline = state.polyline;

    final pickUpMarker = markers[const MarkerId('pickup')];
    final destinationMarker = markers[const MarkerId('destination')];
    if (destinationMarker == null && pickUpMarker != null) {
      _moveCamera(pickUpMarker.position);
    }
    if (pickUpMarker != null && destinationMarker != null) {
      final origin = pickUpMarker.position;
      final destination = destinationMarker.position;

      final route = await _mapRepo.getRoute(origin, destination);
      if (route != null) {
        distance = route.totalDistanceValue / 1000;
        polyline[polylineId] = await MapUtils.createPolyline(
          polylineId: polylineId,
          points:
              route.polylinePoints
                  .map((e) => LatLng(e.latitude, e.longitude))
                  .toList(),
        );
      } else {
        polyline.remove(polylineId);
        distance = MapUtils.calculateDistance(
          fromLocation: origin,
          toLocation: destination,
        );
      }
      emit(state.copyWith(polyline: polyline));
      MapUtils.cameraMoveBounds(
        bounds: route?.bounds,
        fromLocation: origin,
        toLocation: destination,
        controller: controller,
      );
    }
  }
}

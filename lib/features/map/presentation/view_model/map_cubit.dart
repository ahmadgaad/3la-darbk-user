import 'dart:async';

import 'package:ala_darbak_user/core/widgets/app_toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/heplers/location_helper.dart';
import '../../data/models/suggestion_model.dart';
import '../../data/repository/map_repo.dart';
import '../view/components/search_google_map.dart';
import 'map_states.dart';

class MapCubit extends Cubit<MapStates> {
  final MapRepository _mapRepository;

  MapCubit(this._mapRepository) : super(const MapStates());

  // static MapCubit get(context, {bool listen = false}) =>
  //     BlocProvider.of<MapCubit>(context, listen: listen);

  Completer<GoogleMapController> controller = Completer<GoogleMapController>();
  LatLng currentPosition = const LatLng(24.7136, 46.6753);

  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(24.7136, 46.6753),
    zoom: 15,
  );

  init([LatLng? location]) {
    if (location != null) {
      initialCameraPosition = CameraPosition(target: location, zoom: 15);
      currentPosition = location;
    }
  }

  onMapCreate(GoogleMapController controller) {
    this.controller = Completer<GoogleMapController>();
    this.controller.complete(controller);
  }

  /// Get current position of user and move camera to that position
  /// Show error message if location is not available
  Future<void> getCurrentPosition() async {
    try {
      final currentLocation = await LocationHelper.getCurrentPosition();
      currentPosition = LatLng(
        currentLocation.latitude,
        currentLocation.longitude,
      );
      await getAddress(position: currentPosition);
      await _moveCamera();
    } catch (e) {
      AppToaster.show("Could not get current location: $e");
    }
  }

  /// Moves the camera to the current position with a zoom level of 15
  /// Uses the LocationHelper to perform the camera movement
  Future<void> _moveCamera() async {
    await LocationHelper.moveCamera(
      controller: controller,
      target: currentPosition,
      zoom: 15,
    );
  }

  Future<void> getAddress({required LatLng position}) async {
    final result = await LocationHelper.getAddressFromLatLng(position);
    emit(state.copyWith(address: result));
  }

  searchPlace(context) async {
    final SuggestionModel? result = await showSearch(
      context: context,
      delegate: AddressSearch(currentPosition, _mapRepository),
    );
    if (result != null) {
      final place = await _mapRepository.getPlaceDetailFromId(result.placeId);
      final lat = place.result?.geometry?.location?.lat;
      final lng = place.result?.geometry?.location?.lng;
      if (lat != null && lng != null) {
        currentPosition = LatLng(lat, lng);
        _moveCamera();
        emit(state.copyWith(address: result.description));
      }
    }
  }
}

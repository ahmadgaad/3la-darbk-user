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
  // Use nullable controller instead of Completer
  GoogleMapController? _mapController;

  // Extract constant to avoid recreating
  static const LatLng _defaultRiyadhLocation = LatLng(24.7136, 46.6753);
  LatLng _currentLatLng = _defaultRiyadhLocation;

  // Getter for current location (replaces defaultLatLng)
  LatLng get currentLatLng => _currentLatLng;

  // Setter for current location (used by onCameraMove)
  set currentLatLng(LatLng value) => _currentLatLng = value;

  CameraPosition get initialCameraPosition =>
      CameraPosition(target: _currentLatLng, zoom: 15);

  Future<void> init([LatLng? location]) async {
    if (location != null) {
      _currentLatLng = location;
      emit(state.copyWith(initializingLocation: false));
      return;
    } else {
      // Get user's current location as initial position
      emit(state.copyWith(initializingLocation: true));
      try {
        final currentLocation = await LocationHelper.getCurrentPosition();
        _currentLatLng = LatLng(
          currentLocation.latitude,
          currentLocation.longitude,
        );

        await Future.wait([
          getAddress(position: _currentLatLng),
          if (_mapController != null) _moveCamera(),
        ]);
      } catch (e) {
        _currentLatLng = _defaultRiyadhLocation;
        // If we can't get current location, use default (Riyadh) as fallback
        AppToaster.show(
          "Could not get current location, using default location",
        );
      } finally {
        emit(state.copyWith(initializingLocation: false));
      }
    }
  }

  void onMapCreate(GoogleMapController mapController) {
    _mapController = mapController;
    if (_currentLatLng != _defaultRiyadhLocation) {
      _moveCamera();
    }
  }

  /// Get current position of user and move camera to that position
  /// Show error message if location is not available
  Future<void> getCurrentPosition() async {
    try {
      final currentLocation = await LocationHelper.getCurrentPosition();
      _currentLatLng = LatLng(
        currentLocation.latitude,
        currentLocation.longitude,
      );

      await Future.wait([getAddress(position: _currentLatLng), _moveCamera()]);
    } catch (e) {
      AppToaster.show("Could not get current location: $e");
    }
  }

  /// Moves the camera to the current position with a zoom level of 15
  /// Uses the LocationHelper to perform the camera movement
  Future<void> _moveCamera() async {
    if (_mapController == null) return;

    await _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _currentLatLng, zoom: 15),
      ),
    );
  }

  Future<void> getAddress({required LatLng position}) async {
    final result = await LocationHelper.getAddressFromLatLng(position);
    emit(state.copyWith(address: result));
  }

  Future<void> searchPlace(context) async {
    final SuggestionModel? result = await showSearch(
      context: context,
      delegate: AddressSearch(_currentLatLng, _mapRepository),
    );
    if (result != null) {
      final place = await _mapRepository.getPlaceDetailFromId(result.placeId);
      final lat = place.result?.geometry?.location?.lat;
      final lng = place.result?.geometry?.location?.lng;
      if (lat != null && lng != null) {
        _currentLatLng = LatLng(lat, lng);
        _moveCamera();
        emit(state.copyWith(address: result.description));
      }
    }
  }
}

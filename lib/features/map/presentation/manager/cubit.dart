import 'dart:async';

import 'package:ala_darbak_user/core/widgets/app_toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/utils/heplers/map_utils.dart';
import '../../repositories/map_repo.dart';
import '../../repositories/models/suggestion_model.dart';
import '../widgets/search_google_map.dart';
import 'state.dart';

class PickLocationCubit extends Cubit<PickLocationState> {
  final MapRepo _mapRepo;

  PickLocationCubit(this._mapRepo) : super(const PickLocationState());

  static PickLocationCubit get(context, {bool listen = false}) =>
      BlocProvider.of<PickLocationCubit>(context, listen: listen);

  Completer<GoogleMapController> controller = Completer<GoogleMapController>();
  LatLng currentPosition = const LatLng(24.7136, 46.6753);
  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(24.7136, 46.6753), // Center of Saudi Arabia
    zoom: 15,
  );
  init([LatLng? location]) {
    if (location != null) {
      initialCameraPosition = CameraPosition(
        target: location, // Center of Saudi Arabia
        zoom: 15,
      );
      currentPosition=location;
    }
  }

  onMapCreate(GoogleMapController controller) {
    this.controller = Completer<GoogleMapController>();
    this.controller.complete(controller);
  }

  getCurrentPosition() {
    MapUtils.getCurrentPosition().then((value) {
      final location = LatLng(value.latitude, value.longitude);
      // Saudi Arabia approximate boundaries
      if (value.latitude >= 16.3478 && value.latitude <= 32.1543 &&
        value.longitude >= 34.6206 && value.longitude <= 55.6666) {
      currentPosition = location;
      _moveCamera();
      } else {
      AppToaster.show("Location is not available in Saudi Arabia");
  
      }
    }).catchError((e) {});
  }

  _moveCamera() {
    MapUtils.moveCamera(
        controller: controller, target: currentPosition, zoom: 15);
  }

  onCameraMove(CameraPosition position) {
          currentPosition = position.target;
    
  }

  
  getAddress() async {
    emit(state.copyWith(loadingAddress: true));
    final result = await _mapRepo.getAddress(currentPosition);
    emit(state.copyWith(address: result, loadingAddress: false));
  }

  searchPlace(context) async {
    final SuggestionModel? result = await showSearch(
      context: context,
      delegate: AddressSearch(currentPosition, _mapRepo),
    );
    if (result != null) {
      final place = await _mapRepo.getPlaceDetailFromId(result.placeId);
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

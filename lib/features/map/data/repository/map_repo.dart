import 'dart:convert';
import 'dart:developer';

import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' show Client;

import '../../../../core/config/app_config.dart';
import '../../../../core/dependency_injection/di.dart';
import '../models/place_model.dart';
import '../models/route_model.dart';
import '../models/suggestion_model.dart';

abstract class MapRepo {
  Future<List<SuggestionModel>> fetchSuggestions(
    String input,
    String lang,
    lat,
    lng,
  );
  Future<RouteModel?> getRoute(LatLng origin, LatLng destination);
  Future<PlaceModel> getPlaceDetailFromId(String placeId);
  Future<String> getAddress(LatLng location);
}

class MapRepoImp implements MapRepo {
  final client = sl<Client>();
  static const String baseurl = 'https://maps.googleapis.com/maps/api';
  @override
  Future<String> getAddress(LatLng location) async {
    try {
      await setLocaleIdentifier("ar");
      final placeMarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );
      Placemark place = placeMarks[0];
      final String address =
          '${_addressJoin(place.street)}${_addressJoin(place.locality)}${_addressJoin(place.administrativeArea)}${_addressJoin(place.postalCode)} ${place.country ?? ""}';
      return address;
    } catch (e) {
      log(e.toString());
      return "";
    }
  }

  String _addressJoin(String? v) {
    final bool valid = v != null && v.isNotEmpty;
    return "${v ?? ""}${valid ? ", " : ""}";
  }

  @override
  Future<List<SuggestionModel>> fetchSuggestions(
    String input,
    String lang,
    lat,
    lng,
  ) async {
    final request =
        '$baseurl/place/autocomplete/json?input=$input&radius=50000&location=$lat,$lng&language=$lang&components=country:sa&key=${AppConfig.mapKey}';

    final response = await client.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);

      if (result['status'] == 'OK') {
        return result['predictions']
            .map<SuggestionModel>(
              (p) => SuggestionModel(p['place_id'], p['description']),
            )
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  @override
  Future<PlaceModel> getPlaceDetailFromId(String placeId) async {
    final request =
        '$baseurl/place/details/json?place_id=$placeId&key=${AppConfig.mapKey}';
    final response = await client.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return PlaceModel.fromJson(result);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  @override
  Future<RouteModel?> getRoute(LatLng origin, LatLng destination) async {
    final request =
        '$baseurl/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=${AppConfig.mapKey}';

    try {
      final response = await client.get(Uri.parse(request));

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        return RouteModel.fromJson(result);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}

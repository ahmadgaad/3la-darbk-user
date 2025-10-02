import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' show Client;

import '../../../../core/config/app_config.dart';
import '../../../../core/dependency_injection/di.dart';
import '../models/place_model.dart';
import '../models/route_model.dart';
import '../models/suggestion_model.dart';

abstract class MapRepository {
  Future<List<SuggestionModel>> fetchSuggestions(
    String input,
    String lang,
    lat,
    lng,
  );
  Future<RouteModel?> getRoute(LatLng origin, LatLng destination);
  Future<PlaceModel> getPlaceDetailFromId(String placeId);
}

class MapRepositoryImplementation implements MapRepository {
  final client = sl<Client>();
  static const String baseurl = 'https://maps.googleapis.com/maps/api';

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

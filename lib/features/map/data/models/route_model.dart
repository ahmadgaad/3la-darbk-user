// ignore_for_file: file_names, null_check_always_fails

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteModel {
  final LatLngBounds bounds;
  final List<PointLatLng> polylinePoints;
  final String totalDistanceText;
  final double totalDistanceValue;
  final String totalDurationText;
  final double totalDurationValue;

  const RouteModel({
    required this.bounds,
    required this.polylinePoints,
    required this.totalDistanceText,
    required this.totalDistanceValue,
    required this.totalDurationValue,
    required this.totalDurationText,
  });

  factory RouteModel.fromJson(Map<String, dynamic> map) {
    // Check if route is not available
    if ((map['routes'] as List).isEmpty) {
      return null!;
    }

    // Get route information
    final data = Map<String, dynamic>.from(map['routes'][0]);

    // Bounds
    final northeast = data['bounds']['northeast'];
    final southwest = data['bounds']['southwest'];
    final bounds = LatLngBounds(
      northeast: LatLng(northeast['lat'], northeast['lng']),
      southwest: LatLng(southwest['lat'], southwest['lng']),
    );

    // Distance & Duration
    String distanceText = '';
    String durationText = '';
    double distanceValue = 0.0;
    double durationValue = 0.0;
    if ((data['legs'] as List).isNotEmpty) {
      final leg = data['legs'][0];
      distanceText = leg['distance']['text'];
      durationText = leg['duration']['text'];
      //inMeters
      distanceValue = double.parse(leg['distance']['value'].toString());
      //inSeconds
      durationValue = double.parse(leg['duration']['value'].toString());
    }

    return RouteModel(
      bounds: bounds,
      polylinePoints:
          PolylinePoints().decodePolyline(data['overview_polyline']['points']),
      totalDistanceText: distanceText,
      totalDurationText: durationText,
      totalDistanceValue: distanceValue,
      totalDurationValue: durationValue,
    );
  }
}
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderLocationModel {
  final String? pickupAddress;
  final String? destinationAddress;
  final LatLng? pickupLocation;
  final LatLng? destinationLocation;
  final double? distance;
  const OrderLocationModel( {
    this.pickupAddress,
    this.destinationAddress,
    this.pickupLocation,
    this.destinationLocation,
    this.distance
  });
  OrderLocationModel copyWith({
    String? pickupAddress,
    String? destinationAddress,
    LatLng? pickupLocation,
    LatLng? destinationLocation,
    Map<MarkerId, Marker>? markers,
    double? distance,
    Map<PolylineId, Polyline>? polyline
  }) {
    return OrderLocationModel(
      pickupAddress: pickupAddress ?? this.pickupAddress,
      destinationAddress: destinationAddress ?? this.destinationAddress,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      destinationLocation: destinationLocation ?? this.destinationLocation,
      distance: distance ?? this.distance
    );
  }
}

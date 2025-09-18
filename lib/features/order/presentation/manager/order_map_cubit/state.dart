
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderMapState  {
  final Map<PolylineId, Polyline> polyline ;

  final Map<MarkerId, Marker> markers ;
   OrderMapState(
      {
        required this.polyline,
        required this.markers,
      });

  OrderMapState copyWith({
    Map<PolylineId, Polyline>? polyline,
    Map<MarkerId, Marker>? markers,
  }) => OrderMapState(
      polyline: polyline ?? this.polyline,
      markers: markers ?? this.markers
    );
    
}

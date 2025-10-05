import 'package:equatable/equatable.dart';

class MapStates extends Equatable {
  final bool loadingAddress;
  final bool initializingLocation;
  final bool gettingCurrentLocation;
  final String? address;

  const MapStates({
    this.address,
    this.loadingAddress = false,
    this.initializingLocation = false,
    this.gettingCurrentLocation = false,
  });

  MapStates copyWith({
    String? address,
    bool? loadingAddress,
    bool? initializingLocation,
    bool? gettingCurrentLocation,
  }) => MapStates(
    loadingAddress: loadingAddress ?? this.loadingAddress,
    address: address ?? this.address,
    initializingLocation: initializingLocation ?? this.initializingLocation,
    gettingCurrentLocation:
        gettingCurrentLocation ?? this.gettingCurrentLocation,
  );

  @override
  List<Object?> get props => [
    loadingAddress,
    address,
    initializingLocation,
    gettingCurrentLocation,
  ];
}

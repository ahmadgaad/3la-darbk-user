import 'package:equatable/equatable.dart';

import '../../../../order/data/model/order_model.dart';
import '../../../data/model/city_model.dart';
import '../../../data/model/trip_model.dart';

class TripsState extends Equatable {
  final CityModel? startCity;
  final CityModel? destenationCity;
  final List<TripModel> activeTrips;
  final List<OrderModel> orders;
  final bool loading;
  final bool error;

  const TripsState({
    this.orders = const [],
    this.activeTrips = const [],
    this.startCity,
    this.destenationCity,

    this.loading = false,
    this.error = false,
  });

  TripsState copyWith({
    CityModel? startCity,
    CityModel? destenationCity,
    List<TripModel>? activeTrips,
    List<OrderModel>? orders,
    String? date,
    bool? loading,
    bool? error,
  }) {
    return TripsState(
      activeTrips: activeTrips ?? this.activeTrips,
      orders: orders ?? this.orders,
      startCity: startCity,
      destenationCity: destenationCity,

      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    activeTrips,
    startCity,
    destenationCity,
    orders,
    loading,
    error,
  ];
}

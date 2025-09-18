
import 'package:equatable/equatable.dart';

import '../../../order/repositories/model/order_model.dart';


class OrdersState extends Equatable {
  final List<String> trips;
  final List<String> startCities;
  final List<String> destenationCities;
  final List<String> dates;
  final String? startCity;
  final String? destinationCity;
  final List<MapEntry<int, String>> statuses ;
  final String? date;
  final int? status;
  final bool loading;
  final String? error;
  final bool success;
  final List<OrderModel>historyOrders;
  final List<OrderModel>activeOrders;

  const OrdersState(
       {
    this.trips = const [],
    this.historyOrders = const [],
    this.activeOrders = const [],
    this.startCities = const [],
    this.destenationCities = const [],
    this.dates = const [],
    this.statuses = const [],
    this.startCity,
    this.destinationCity,
    this.status,
    this.date,
    this.loading = false,
    this.success = false,
    this.error,
  });

  OrdersState copyWith({
    List<String>? trips,
    List<String>? startCities,
    List<OrderModel>? historyOrders,
    List<OrderModel>? activeOrders,
    List<String>? destenationCities,
    List<String>? dates,
    List<MapEntry<int, String>>? statuses ,
    String? startCity,
    String? destinationCity,
    int? status,
    String? date,
    bool? loading,
    bool? success,
    String? error,
  }) {
    return OrdersState(
      trips: trips ?? this.trips,
       success: success ?? this.success,
      historyOrders: historyOrders ?? this.historyOrders,
      activeOrders: activeOrders ?? this.activeOrders,
      startCities: startCities ?? this.startCities,
      destenationCities: destenationCities ?? this.destenationCities,
      dates: dates ?? this.dates,
      statuses: statuses ?? this.statuses,
      startCity: startCity ,
      status: status,
      destinationCity: destinationCity ,
      date: date ,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }
  
  @override
  List<Object?> get props => [
    trips,
    historyOrders,
    success,
    startCities,
    destenationCities,
    dates,
    startCity,
    destinationCity,
    statuses,
    status,
    date,
    loading,
    activeOrders,
    error
  ];
}

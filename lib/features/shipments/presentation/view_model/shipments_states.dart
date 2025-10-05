import 'package:equatable/equatable.dart';

import '../../../order/data/model/order_model.dart';

enum ShipmentsStatus { initial, loading, success, error }

class ShipmentsState extends Equatable {
  final List<OrderModel> activeShipments;
  final List<OrderModel> shipmentsHistory;
  final ShipmentsStatus status;
  final String? errorMessage;

  const ShipmentsState({
    this.activeShipments = const [],
    this.shipmentsHistory = const [],
    this.status = ShipmentsStatus.initial,
    this.errorMessage,
  });

  ShipmentsState copyWith({
    List<OrderModel>? activeShipments,
    List<OrderModel>? shipmentsHistory,
    ShipmentsStatus? status,
    String? errorMessage,
  }) {
    return ShipmentsState(
      activeShipments: activeShipments ?? this.activeShipments,
      shipmentsHistory: shipmentsHistory ?? this.shipmentsHistory,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [activeShipments, shipmentsHistory, status, errorMessage];
}

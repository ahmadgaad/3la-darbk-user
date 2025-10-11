import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/shipments_repository.dart';
import 'shipments_states.dart';

class ShipmentsCubit extends Cubit<ShipmentsState> {
  final ShipmentsRepository _shipmentsRepository;

  ShipmentsCubit(this._shipmentsRepository)
    : super(const ShipmentsState(status: ShipmentsStatus.initial)) {
    getActiveShipments();
    getHistoryOrders();
  }

  /// Get Shipments History
  Future<void> getHistoryOrders() async {
    final result = await _shipmentsRepository.getHistoryOrders();
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: ShipmentsStatus.error,
            errorMessage: failure.message,
          ),
        );
      },
      (history) {
        emit(state.copyWith(shipmentsHistory: history));
      },
    );
  }

  /// Get Active Shipments
  Future<void> getActiveShipments() async {
    emit(state.copyWith(status: ShipmentsStatus.loading));
    await Future.delayed(const Duration(milliseconds: 500));
    final result = await _shipmentsRepository.getActiveShpiments();
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            errorMessage: failure.message,
            status: ShipmentsStatus.error,
          ),
        );
      },
      (shpiments) {
        emit(
          state.copyWith(
            status: ShipmentsStatus.success,
            activeShipments: shpiments,
          ),
        );
      },
    );
  }

  // Future<void> updateOrderFromOrders(OrderModel order) async {
  //   emit(
  //     state.copyWith(
  //       activeShipments:
  //           state.activeShipments
  //               .map((e) => e.id == order.id ? order : e)
  //               .toList(),
  //       shipmentsHistory:
  //           state.shipmentsHistory
  //               .map((e) => e.id == order.id ? order : e)
  //               .toList(),
  //     ),
  //   );
  // }
}

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../temp/app_temp.dart';
import '../../../order/repositories/model/order_model.dart';
import '../../data/shipments_repository.dart';
import 'shipments_states.dart';

class ShipmentsCubit extends Cubit<ShipmentsStates> {
  final ShipmentsRepository _shipmentsRepository;

  ShipmentsCubit(this._shipmentsRepository)
    : super(
        const ShipmentsStates(
          startCities: cities,
          destenationCities: cities,
          dates: dates,
          statuses: [
            MapEntry(0, AppStrings.pending),
            MapEntry(1, AppStrings.accepted),
            MapEntry(2, AppStrings.picked),
            MapEntry(3, AppStrings.delivered),
            MapEntry(4, AppStrings.notApproved),
            MapEntry(5, AppStrings.canceled),
          ],
        ),
      ) {
    getActiveShipments();
    getHistoryOrders();
  }

  applyFilter({
    String? startCity,
    String? destenationCity,
    String? date,
    int? status,
  }) {
    emit(
      state.copyWith(
        startCity: startCity ?? state.startCity,
        destinationCity: destenationCity ?? state.destinationCity,
        status: status ?? state.status,
        date: date ?? state.date,
      ),
    );
  }

  void removeFilters() {
    emit(
      state.copyWith(
        startCity: null,
        destinationCity: null,
        date: null,
        status: null,
      ),
    );
  }

  Future<void> getHistoryOrders() async {
    final result = await _shipmentsRepository.getHistoryOrders();
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            loading: false,
            error: failure.message,
            success: false,
          ),
        );
      },
      (orders) {
        emit(
          state.copyWith(loading: false, success: true, historyOrders: orders),
        );
      },
    );
  }

  Future<void> getActiveShipments() async {
    state.copyWith(loading: true, activeOrders: []);
    final result = await _shipmentsRepository.getActiveShpiments();
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            loading: false,
            error: failure.message,
            success: false,
          ),
        );
      },
      (shpiments) {
        emit(
          state.copyWith(
            loading: false,
            success: true,
            activeOrders: shpiments,
          ),
        );
      },
    );
  }

  updateOrderFromOrders(OrderModel order) async {
    emit(
      state.copyWith(
        activeOrders:
            state.activeOrders
                .map((e) => e.id == order.id ? order : e)
                .toList(),
        historyOrders:
            state.historyOrders
                .map((e) => e.id == order.id ? order : e)
                .toList(),
      ),
    );
  }
}

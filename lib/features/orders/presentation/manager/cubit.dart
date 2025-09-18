import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_utils/app_strings.dart';
import '../../../order/repositories/model/order_model.dart';
import '../../repositories/repositories.dart';
import 'state.dart';
import '../../../../temp/app_temp.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersRepository _ordersRepository;

  OrdersCubit(this._ordersRepository)
    : super(
        const OrdersState(
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
    getActiveOrders();
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

  removeFilters() {
    emit(
      state.copyWith(
        startCity: null,
        destinationCity: null,
        date: null,
        status: null,
      ),
    );
  }

  getHistoryOrders() async {
    final result = await _ordersRepository.getHistoryOrders();
    result.fold(
      (l) {
        emit(state.copyWith(loading: false, success: true, historyOrders: l));
      },
      (r) {
        emit(state.copyWith(loading: false, error: r.message, success: false));
      },
    );
  }

  getActiveOrders() async {
    final result = await _ordersRepository.getActiveOrders();
    result.fold(
      (l) {
        emit(state.copyWith(loading: false, success: true, activeOrders: l));
      },
      (r) {
        emit(state.copyWith(loading: false, error: r.message, success: false));
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

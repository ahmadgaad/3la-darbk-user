import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/city_model.dart';
import '../../../data/repositories.dart';
import 'trips_states.dart';

class TripsCubit extends Cubit<TripsState> {
  final TripsRepository _tripsRepository;
  TripsCubit(this._tripsRepository) : super(const TripsState()) {
    getActiveTrips();
  }

  void applyFilter({CityModel? startCity, CityModel? destenationCity}) {
    emit(
      state.copyWith(
        startCity: startCity ?? state.startCity,
        destenationCity: destenationCity ?? state.destenationCity,
      ),
    );
  }

  void removeFilters() {
    emit(state.copyWith());
  }

  Future<void> getActiveTrips() async {
    emit(state.copyWith(loading: true));
    await Future.delayed(const Duration(milliseconds: 500));
    final result = await _tripsRepository.getActiveTrips();
    result.fold(
      (trips) {
        emit(state.copyWith(activeTrips: trips, loading: false));
      },
      (error) {
        emit(state.copyWith(error: true, loading: false));
      },
    );
  }
}

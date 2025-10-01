import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/city_model.dart';
import '../../../data/repositories.dart';
import 'trips_states.dart';

class TripsCubit extends Cubit<TripsState> {
  final TripsRepository _tripsRepository;
  TripsCubit(this._tripsRepository) : super(const TripsState()) {
    getActiveTrips();
  }

  applyFilter({CityModel? startCity, CityModel? destenationCity}) {
    emit(
      state.copyWith(
        startCity: startCity ?? state.startCity,
        destenationCity: destenationCity ?? state.destenationCity,
      ),
    );
  }

  removeFilters() {
    emit(state.copyWith());
  }

  getActiveTrips() async {
    emit(state.copyWith(loading: true));
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

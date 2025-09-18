import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repositories/model/city_model.dart';
import '../../../repositories/repositories.dart';
import 'state.dart';

class TripsCubit extends Cubit<TripsState> {
  final TripsRepository _tripsRepository;
  TripsCubit(this._tripsRepository) : super(const TripsState()){
    getActiveTrips();
  }

  applyFilter({
    CityModel? startCity,
    CityModel? destenationCity,
    String? date,
  }) {
    emit(state.copyWith(
      startCity: startCity ?? state.startCity,
      destenationCity: destenationCity ?? state.destenationCity,
      date: date ?? state.date,
    ));
  }

  removeFilters() {
    emit(state.copyWith());
  }


  getActiveTrips() async {
    final result = await _tripsRepository.getActiveTrips();
    result.fold((trips) {
      emit(state.copyWith(activeTrips: trips, loading: false));
    }, (error) {
      emit(state.copyWith(error: true, loading: false));
    });
  }


}

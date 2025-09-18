import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repositories/repositories.dart';
import 'state.dart';

class CitiesCubit extends Cubit<CitiesState> {
  final TripsRepository _tripsRepository;
  CitiesCubit(this._tripsRepository) : super(const CitiesState()){
    getCities();
  }

  getCities() async {
    emit(state.copyWith(loading: true));
    final result = await _tripsRepository.getCities();
    result.fold((list) => emit(state.copyWith(loading: false, cities: list)),
        (list) => emit(state.copyWith(loading: false, error: true)));
  }
}

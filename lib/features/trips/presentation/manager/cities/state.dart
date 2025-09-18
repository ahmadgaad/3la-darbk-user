
import 'package:equatable/equatable.dart';

import '../../../repositories/model/city_model.dart';

class CitiesState extends Equatable {
  final List<CityModel> cities;
  final bool loading;
  final bool error;

  const CitiesState({
    this.cities=const [], 
    this.loading = false,
    this.error=false,
  });


  CitiesState copyWith({
    List<CityModel>? cities,
    bool? loading,
    bool? error,
  }) {
    return CitiesState(
      cities: cities ?? this.cities,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }
  
  @override
  List<Object?> get props => [
    cities,
    loading,
    error,
  ];
}

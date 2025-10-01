import 'package:dartz/dartz.dart';
import '../../../core/networking/exceptions.dart';
import '../../../core/networking/api_end_points.dart';
import '../../../core/networking/api_client.dart';
import 'model/city_model.dart';
import 'model/trip_model.dart';

abstract class TripsRepository {
  Future<Either<List<CityModel>, AppException>> getCities();
  Future<Either<List<TripModel>, AppException>> getActiveTrips();
  Future<Either<TripModel?, AppException>> getTrip({required int tripId});
}

class TripsRepositoryImpl implements TripsRepository {
  final ApiClient _apiClient;

  TripsRepositoryImpl(
    this._apiClient,
  );

  @override
  Future<Either<List<CityModel>, AppException>> getCities() async {
    try {
      final response = await _apiClient.get(endPoint: ApiEndPoints.cities);
      final list =
          response.data?.map<CityModel>((e) => CityModel.fromJson(e)).toList();
      return Left(list);
    } on AppException catch (e) {
      return Right(e);
    }
  }


  @override
  Future<Either<List<TripModel>, AppException>> getActiveTrips() async {
    try {
      final response = await _apiClient.get(endPoint: ApiEndPoints.activeTrips);
      final list =
          response.data?.map<TripModel>((e) => TripModel.fromJson(e)).toList();
      return Left(list);
    } on AppException catch (e) {
      return Right(e);
    }
  }

  @override
  Future<Either<TripModel?, AppException>> getTrip(
      {required int tripId}) async {
    try {
      final response =
          await _apiClient.get(endPoint: '${ApiEndPoints.trips}/$tripId');
      final tripModel = TripModel.fromJson(response.data);
      return Left(tripModel);
    } on AppException catch (e) {
      return Right(e);
    }
  }
}

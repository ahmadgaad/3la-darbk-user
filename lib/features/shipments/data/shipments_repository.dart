import 'package:dartz/dartz.dart';

import '../../../core/networking/api_client.dart';
import '../../../core/networking/api_end_points.dart';
import '../../../core/networking/exceptions.dart';
import '../../order/repositories/model/order_model.dart';

abstract class ShipmentsRepository {
  Future<Either<AppException, List<OrderModel>>> getHistoryOrders();
  Future<Either<AppException, List<OrderModel>>> getActiveShpiments();
}

class ShipmentsRepositoryImpl implements ShipmentsRepository {
  final ApiClient _apiClient;

  ShipmentsRepositoryImpl(this._apiClient);

  @override
  Future<Either<AppException, List<OrderModel>>> getHistoryOrders() async {
    try {
      final response = await _apiClient.get(endPoint: ApiEndPoints.orders);
      final list =
          response.data
              ?.map<OrderModel>((e) => OrderModel.fromJson(e))
              .toList();
      return Right(list);
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<AppException, List<OrderModel>>> getActiveShpiments() async {
    try {
      final response = await _apiClient.get(
        endPoint: ApiEndPoints.ordersActive,
      );
      final list =
          response.data
              ?.map<OrderModel>((e) => OrderModel.fromJson(e))
              .toList();
      return Right(list);
    } on AppException catch (e) {
      return Left(e);
    }
  }
}

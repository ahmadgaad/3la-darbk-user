import 'package:dartz/dartz.dart';
import '../../../core/networking/exceptions.dart';
import '../../../core/networking/api_end_points.dart';
import '../../../core/networking/api_client.dart';
import '../../order/repositories/model/order_model.dart';

abstract class OrdersRepository  {
  Future<Either<List<OrderModel>, AppException>> getHistoryOrders();
  Future<Either<List<OrderModel>, AppException>> getActiveOrders();
}

class OrdersRepositoryImpl implements OrdersRepository {
  final ApiClient _apiClient;


  OrdersRepositoryImpl(this._apiClient,);

  @override
  Future<Either<List<OrderModel>, AppException>> getHistoryOrders() async {
    try {
      final response = await _apiClient.get(endPoint: ApiEndPoints.orders);
      final list = response.data
          ?.map<OrderModel>((e) => OrderModel.fromJson(e))
          .toList();
      return Left(list);
    } on AppException catch (e) {
      return Right(e);
    }
  }
  
  @override
  Future<Either<List<OrderModel>, AppException>> getActiveOrders() async {
    try {
      final response = await _apiClient.get(endPoint: ApiEndPoints.ordersActive);
      final list = response.data
          ?.map<OrderModel>((e) => OrderModel.fromJson(e))
          .toList();
      return Left(list);
    } on AppException catch (e) {
      return Right(e);
    }
  }
}

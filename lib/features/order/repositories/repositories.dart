import 'package:dartz/dartz.dart';

import '../../../core/data/exceptions/exceptions.dart';
import '../../../core/data/remote/api_end_points.dart';
import '../../../core/data/remote/api_client.dart';
import 'model/order_model.dart';

abstract class OrderRepository {
  Future<Either<OrderModel?, AppException>> createOrder(OrderModel order);
  Future<Either<OrderModel?, AppException>> updateOrder(OrderModel order);
  Future<Either<OrderModel?, AppException>> cancelOrder(int orderId);
  Future<Either<OrderModel?, AppException>> raisePrice(OrderModel order);
  Future<Either<OrderModel?, AppException>> getOrder(int orderId);
  Future<Either<OrderModel?, AppException>> payOrder(int orderId);
}

class OrderRepositoryImpl implements OrderRepository {
  final ApiClient _apiClient;

  OrderRepositoryImpl(this._apiClient);

  @override
  Future<Either<OrderModel?, AppException>> createOrder(
    OrderModel order,
  ) async {
    try {
      final response = await _apiClient.post(
        endPoint: ApiEndPoints.orders,
        showErrorMessage: true,
        isFormData: true,
        data: order.toJson(),
      );
      return Left(OrderModel.fromJson(response.data));
    } on AppException catch (e) {
      return Right(e);
    }
  }

  @override
  Future<Either<OrderModel?, AppException>> getOrder(int orderId) async {
    try {
      final response = await _apiClient.get(
        endPoint: '${ApiEndPoints.orders}/$orderId',
        showErrorMessage: false,
      );
      return Left(OrderModel.fromJson(response.data));
    } on AppException catch (e) {
      return Right(e);
    }
  }

  @override
  Future<Either<OrderModel?, AppException>> updateOrder(
    OrderModel order,
  ) async {
    try {
      final response = await _apiClient.post(
        endPoint: '${ApiEndPoints.orderUpdate}/${order.id}',
        showErrorMessage: true,
        data: order.toJson(),
      );
      return Left(OrderModel.fromJson(response.data));
    } on AppException catch (e) {
      return Right(e);
    }
  }

  @override
  Future<Either<OrderModel?, AppException>> cancelOrder(int orderId) async {
    try {
      final response = await _apiClient.post(
        endPoint: '${ApiEndPoints.orderCancel}/$orderId',
      );
      return Left(OrderModel.fromJson(response.data));
    } on AppException catch (e) {
      return Right(e);
    }
  }

  @override
  Future<Either<OrderModel?, AppException>> raisePrice(OrderModel order) async {
    try {
      final response = await _apiClient.post(
        endPoint: '${ApiEndPoints.raisePrice}/${order.id}',
        showErrorMessage: true,
        data: order.toJson(),
      );
      return Left(OrderModel.fromJson(response.data));
    } on AppException catch (e) {
      return Right(e);
    }
  }

  @override
  Future<Either<OrderModel?, AppException>> payOrder(int orderId) async {
    try {
      final response = await _apiClient.post(
        endPoint: '${ApiEndPoints.payOrder}$orderId',
      );
      return Left(OrderModel.fromJson(response.data));
    } on AppException catch (e) {
      
      return Right(e);
    }
  }
}

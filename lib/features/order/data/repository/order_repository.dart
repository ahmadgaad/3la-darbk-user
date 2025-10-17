import 'package:ala_darbak_user/features/order/data/model/create_order_request_body.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/networking/api_client.dart';
import '../../../../core/networking/api_end_points.dart';
import '../../../../core/networking/exceptions.dart';
import '../model/order_model.dart';

abstract class OrderRepository {
  Future<Either<AppException, OrderModel>> createOrder({
    required CreateOrderRequestBody body,
  });
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
  Future<Either<AppException, OrderModel>> createOrder({
    required CreateOrderRequestBody body,
  }) async {
    try {
      // Use longer timeout for file uploads
      final options = Options(
        sendTimeout: const Duration(
          minutes: 5,
        ), // 5 minutes for large file uploads
        receiveTimeout: const Duration(
          minutes: 3,
        ), // 3 minutes to receive response
      );

      final response = await _apiClient.post(
        endPoint: ApiEndPoints.orders,
        showErrorMessage: true,
        isFormData: true,
        data: body.toJson(),
        options: options,
      );

      // Check if response.data exists and contains the expected structure
      if (response.data == null) {
        return Left(AppException('No data received from server'));
      }

      // Handle different response structures
      Map<String, dynamic> orderData;
      if (response.data is Map<String, dynamic>) {
        // If response.data is already the order data
        orderData = response.data as Map<String, dynamic>;
      } else if (response.data['data'] != null) {
        // If response.data contains a 'data' field with the order
        orderData = response.data['data'] as Map<String, dynamic>;
      } else {
        return Left(AppException('Invalid response format from server'));
      }

      return Right(OrderModel.fromJson(orderData));
    } on AppException catch (e) {
      return Left(e);
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

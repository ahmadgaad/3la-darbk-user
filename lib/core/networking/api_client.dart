import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'api_response_model.dart';
import 'exceptions.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({required Dio dio}) : _dio = dio;

  /// Helper function to set headers
  void setHeaders({bool isFormData = false}) {
    _dio.options.headers = {
      'Content-Type': isFormData ? 'multipart/form-data' : 'application/json',
      'Accept': 'application/json',
      //TODO change language dynamically
      // 'Accect-Language': 'ar',
    };
  }

  /// GET request
  Future<ApiResponseModel> get({
    required String endPoint,
    Map<String, dynamic>? query,
    Map<String, dynamic> data = const {},
    bool showErrorMessage = true,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      setHeaders(isFormData: false);
      final response = await _dio.get(
        endPoint,
        queryParameters: query,
        onReceiveProgress: onReceiveProgress,
      );
      return ApiResponseModel.fromJson(response.data);
    } on DioException catch (error) {
      throw handleDioExceptions(error, showErrorMessage);
    } on SocketException {
      throw AppException('No Internet connection');
    } on FormatException catch (e) {
      throw AppException("Invalid format: ${e.message}");
    } catch (e) {
      throw AppException("Unexpected error: ${e.toString()}");
    }
  }

  /// POST request
  Future<ApiResponseModel> post({
    required String endPoint,
    bool showErrorMessage = true,
    Map<String, dynamic> data = const {},
    bool isFormData = false,
    Map<String, dynamic>? query,
    ProgressCallback? onSendProgress,
    Options? options,
  }) async {
    try {
      setHeaders(isFormData: isFormData);

      final response = await _dio.post(
        endPoint,
        data: isFormData ? FormData.fromMap(data) : jsonEncode(data),
        queryParameters: query,
        onSendProgress: onSendProgress,
        options: options,
      );

      return ApiResponseModel.fromJson(response.data);
    } on DioException catch (error) {
      // _logger.e("POST request failed: $error");
      throw handleDioExceptions(error, showErrorMessage);
    } on SocketException {
      throw AppException('No Internet connection');
    } on FormatException catch (e) {
      throw AppException("Invalid format: ${e.message}");
    } catch (e) {
      throw AppException("Unexpected error: ${e.toString()}");
    }
  }

  /// DELETE request
  Future<ApiResponseModel> delete({
    required String endPoint,
    bool showErrorMessage = true,
    Map<String, dynamic> data = const {},
    bool isFormData = false,
    Map<String, dynamic>? query,
  }) async {
    try {
      setHeaders(isFormData: isFormData);

      final response = await _dio.delete(
        endPoint,
        data: isFormData ? FormData.fromMap(data) : jsonEncode(data),
        queryParameters: query,
      );

      return ApiResponseModel.fromJson(response.data);
    } on DioException catch (error) {
      // _logger.e("POST request failed: $error");
      throw handleDioExceptions(error, showErrorMessage);
    } on SocketException {
      throw AppException('No Internet connection');
    } on FormatException catch (e) {
      throw AppException("Invalid format: ${e.message}");
    } catch (e) {
      throw AppException("Unexpected error: ${e.toString()}");
    }
  }
}

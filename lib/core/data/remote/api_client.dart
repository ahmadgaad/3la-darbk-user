import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import '../exceptions/exceptions.dart';
import '../model/response_model.dart';
import 'package:logger/logger.dart';

class ApiClient {
  final Dio _dio;
  final Logger _logger;

  ApiClient({required Dio dio, required Logger logger})
      : _dio = dio,
        _logger = logger;

  /// Helper function to set headers
   void setHeaders({bool isFormData = false}) {
    _dio.options.headers = {
      'Content-Type': isFormData ? 'multipart/form-data' : 'application/json',
      'Accept': 'application/json',
    };
  }

  /// GET request
   Future<ResponseModel> get({
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
      return ResponseModel.fromJson(response.data);
    } on DioException catch (error) {
      _logger.e("GET request failed: $error");
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
   Future<ResponseModel> post({
    required String endPoint,
    bool showErrorMessage = true,
    Map<String, dynamic> data = const {},
    bool isFormData = false,
    Map<String, dynamic>? query,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      setHeaders(isFormData: isFormData);

      final response = await _dio.post(
        endPoint,
        data: isFormData ? FormData.fromMap(data) : jsonEncode(data),
        queryParameters: query,
        onSendProgress: onSendProgress,
      );

      return ResponseModel.fromJson(response.data);
    } on DioException catch (error) {
      _logger.e("POST request failed: $error");
      throw handleDioExceptions(error, showErrorMessage);
    } on SocketException {
      throw AppException('No Internet connection');
    } on FormatException catch (e) {
      throw AppException("Invalid format: ${e.message}");
    } catch (e) {
      throw AppException("Unexpected error: ${e.toString()}");
    }
  }

   Future<ResponseModel> delete({
    required String endPoint,
    bool showErrorMessage = true,
    Map<String, dynamic> data = const {},
    bool isFormData = false,
    Map<String, dynamic>? query,
  }) async {
    try {
      setHeaders(isFormData: isFormData);

      final response = await _dio.delete(endPoint,
          data: isFormData ? FormData.fromMap(data) : jsonEncode(data),
          queryParameters: query);

      return ResponseModel.fromJson(response.data);
    } on DioException catch (error) {
      _logger.e("POST request failed: $error");
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

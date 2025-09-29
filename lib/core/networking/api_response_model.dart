import 'package:equatable/equatable.dart';

class ApiResponseModel extends Equatable {
  final dynamic data;
  final String? message;
  final String? token;
  final dynamic code;
  final String? status;
  final bool? success;

  const ApiResponseModel({
    this.data,
    this.code,
    this.message,
    this.success,
    this.status,
    this.token,
  });

  factory ApiResponseModel.fromJson(Map<String, dynamic> json) {
    return ApiResponseModel(
      data: json['data'],
      code: json['code'],
      token: json['token'],
      success: json["success"],
      status: json["status"],
      message: json["message"],
    );
  }

  @override
  List<Object?> get props => [data, message, success, status, token];
}

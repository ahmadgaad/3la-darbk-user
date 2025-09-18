import 'package:equatable/equatable.dart';

class ResponseModel extends Equatable {
  final dynamic data;
  final String? message;
  final String? token;
  final dynamic code;
  final String? status;
  final bool? success;

  const ResponseModel({
    this.data,
    this.code,
    this.message,
    this.success,
    this.status,
    this.token,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
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

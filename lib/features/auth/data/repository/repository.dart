import 'package:dartz/dartz.dart';

import '../../../../core/networking/exceptions.dart';
import '../../../../core/heplers/shared_preferences_service.dart';
import '../../../../core/networking/api_end_points.dart';
import '../../../../core/networking/api_client.dart';
import '../../../../core/utils/app_utils/app_strings.dart';
import '../../../../core/widgets/app_toaster.dart';
import '../models/user_model.dart';

abstract class AuthRepository {
  Future<Either<void, AppException>> register(UserModel userModel);
  Future<Either<void, AppException>> login(
      {required String mobile, required String password});
  Future<Either<String, AppException>> sendCode({required String mobile});
  Future<Either<bool, AppException>> checkUserExists({required String mobile});

  Future<Either<void, AppException>> forgetPassword(
      {required String mobile, required String password, required String code});

  Future<Either<void, AppException>> logout();
  Future<Either<UserModel, AppException>> getClientData();
  Future<Either<UserModel, AppException>> updateData(UserModel user);
}

class AuthRepositoryImpl implements AuthRepository {

  final ApiClient _apiClient;
  final SharedPreferencesService _sharedPreferences;

  AuthRepositoryImpl(this._apiClient, this._sharedPreferences);


  @override
  Future<Either<void, AppException>> forgetPassword(
      {required String mobile,
      required String password,
      required String code}) async {
    try {
      await _apiClient.post(
          endPoint: ApiEndPoints.forgetPassword,
          data: {"mobile": mobile, "new_password": password, "code": code});
      return const Left(null);
    } on AppException catch (e) {
      return Right(e);
    }
  }

  @override
  Future<Either<UserModel, AppException>> getClientData() async {
    try {
      final response = await _apiClient.get(endPoint: ApiEndPoints.clientData);
      final userModel = UserModel.fromJson(response.data ?? {});
      return Left(userModel);
    } on AppException catch (e) {
      return Right(e);
    }
  }

  @override
  Future<Either<void, AppException>> login(
      {required String mobile, required String password}) async {
    try {
      final response = await _apiClient.post(
          endPoint: ApiEndPoints.login,
          data: {"mobile": mobile, "password": password},
          showErrorMessage: false);
      await _sharedPreferences.setToken(response.token);
      return const Left(null);
    } on AppException catch (e) {
      if (e is ServerException && e.statusCode == 401) {
        AppToaster.show(AppStrings.invalidCredentials);
      }
      return Right(e);
    }
  }

  @override
  Future<Either<void, AppException>> logout() async {
    try {
      await _apiClient.post(endPoint: ApiEndPoints.logout);
      return const Left(null);
    } on AppException catch (e) {
      return Right(e);
    }
  }

  @override
  Future<Either<void, AppException>> register(UserModel userModel) async {
    try {
      final response = await _apiClient.post(
          endPoint: ApiEndPoints.register,
          data: userModel.toJson(),
          isFormData: true,
          showErrorMessage: false);
      await _sharedPreferences.setToken(response.token);
      return const Left(null);
    } on AppException catch (e) {
      if (e is ServerException && e.statusCode == 422) {
        AppToaster.show(AppStrings.userExist);
      }
      return Right(e);
    }
  }

  @override
  Future<Either<String, AppException>> sendCode(
      {required String mobile}) async {
    try {
      final response = await _apiClient.post(
          endPoint: ApiEndPoints.sendCode, data: {"mobile": mobile});
      return Left(response.code.toString());
    } on AppException catch (e) {
      return Right(e);
    }
  }

  @override
  Future<Either<bool, AppException>> checkUserExists(
      {required String mobile}) async {
    try {
      await _apiClient.post(
          endPoint: ApiEndPoints.checkUserExists,
          data: {"mobile": mobile},
          showErrorMessage: false);
      return const Left(true);
    } on AppException catch (e) {
      if (e is ServerException && e.statusCode == 404) return const Left(false);
      return Right(e);
    }
  }

  @override
  Future<Either<UserModel, AppException>> updateData(UserModel user) async {
    try {
      final response = await _apiClient.post(
          endPoint: ApiEndPoints.updateclient, data: user.toJson());
      final userModel = UserModel.fromJson(response.data ?? {});
      return Left(userModel);
    } on AppException catch (e) {
      return Right(e);
    }
  }
}

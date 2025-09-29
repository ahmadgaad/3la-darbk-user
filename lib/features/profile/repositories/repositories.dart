import '../../../core/utils/notification/firebase_notification.dart';
import 'package:dartz/dartz.dart';

import '../../../core/networking/exceptions.dart';
import '../../../core/heplers/shared_preferences_service.dart';
import '../../../core/networking/api_end_points.dart';
import '../../../core/networking/api_client.dart';
import '../../../core/utils/app_utils/app_strings.dart';
import '../../../core/widgets/app_toaster.dart';
import '../../auth/data/models/user_model.dart';

abstract class ProfileRepository {
  Future<Either<void, AppException>> changePassword(
      {required String oldPassword, required String password});
  Future<Either<void, AppException>> logout();
  Future<Either<void, AppException>> delete();
  Future<Either<UserModel, AppException>> getClientData();
  Future<Either<UserModel, AppException>> updateData(UserModel user);
}

class ProfileRepositoryImpl implements ProfileRepository {
  final ApiClient _apiClient;
  final SharedPreferencesService _sharedPreferences;

  ProfileRepositoryImpl(this._apiClient, this._sharedPreferences);

  @override
  Future<Either<void, AppException>> changePassword(
      {required String oldPassword, required String password}) async {
    try {
      await _apiClient.post(
          endPoint: ApiEndPoints.changePassword,
          showErrorMessage: false,
          data: {"old_password": oldPassword, "new_password": password});
      return const Left(null);
    } on AppException catch (e) {
       if(e is ServerException && e.statusCode == 400){
              AppToaster.show(AppStrings.oldPasswordUnvalid);
            }
      return Right(e);
    }
  }

  @override
  Future<Either<UserModel, AppException>> getClientData() async {
    try {
      final response = await _apiClient.get(endPoint: ApiEndPoints.clientData);
       await _apiClient.post(endPoint: ApiEndPoints.updateFcmToken,
          data: {"device_token": await FirebaseNotifications.token()});
     
      final userModel = UserModel.fromJson(response.data ?? {});
      return Left(userModel);
    } on AppException catch (e) {
      return Right(e);
    }
  }

  @override
  Future<Either<UserModel, AppException>> updateData(UserModel user) async {
    try {
      final response = await _apiClient.post(
          isFormData: true,
          endPoint: ApiEndPoints.updateclient,
          data: user.toJson());
      final userModel = UserModel.fromJson(response.data ?? {});
      return Left(userModel);
    } on AppException catch (e) {
      return Right(e);
    }
  }

  @override
  Future<Either<void, AppException>> logout() async {
    try {
      await _sharedPreferences.removeToken();
      return const Left(null);
    } on AppException catch (e) {
      return Right(e);
    }
  }

  @override
  Future<Either<void, AppException>> delete() async {
    try {
      await _apiClient.delete(endPoint: ApiEndPoints.clientData);
      await _sharedPreferences.removeToken();
      return const Left(null);
    } on AppException catch (e) {
      return Right(e);
    }
  }
}

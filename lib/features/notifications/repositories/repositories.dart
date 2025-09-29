import 'package:dartz/dartz.dart';

import '../../../core/networking/exceptions.dart';
import '../../../core/networking/api_end_points.dart';
import '../../../core/networking/api_client.dart';
import 'model/notifications_model.dart';

abstract class NotificationsRepo {

  Future<Either<List<NotificationsModel>, AppException>> getNotifications();
  Future<Either<void, AppException>> readNotifications();

}

class NotificationsRepoImpl implements NotificationsRepo {
  final ApiClient _apiClient;

  NotificationsRepoImpl(this._apiClient);



  @override
  Future<Either<List<NotificationsModel>, AppException>> getNotifications() async {
    try {
      final response = await _apiClient.get(
        endPoint: ApiEndPoints.getNotifications,
        showErrorMessage: false,
      );
      final list = response.data
          ?.map<NotificationsModel>((e) => NotificationsModel.fromJson(e))
          .toList();
      return Left(list);
    } on AppException catch (e) {
      return Right(e);
    }
  }
  
  @override
  Future<Either<void, AppException>> readNotifications()   async {
    try {
  await _apiClient.get(
        endPoint: ApiEndPoints.readNotification,
        showErrorMessage: false,
      );
      return const Left(null);
    } on AppException catch (e) {
      return Right(e);
    }
  }
  



}

import 'package:dartz/dartz.dart';

import '../../../../core/networking/api_client.dart';
import '../../../../core/networking/api_end_points.dart';
import '../../../../core/networking/exceptions.dart';
import '../model/notifications_model.dart';

abstract class NotificationsRepo {
  Future<Either<AppException, List<NotificationsModel>>> getNotifications();
  Future<Either<AppException, Unit>> readNotifications();
}

class NotificationsRepoImpl implements NotificationsRepo {
  final ApiClient _apiClient;

  NotificationsRepoImpl(this._apiClient);

  @override
  Future<Either<AppException, List<NotificationsModel>>>
  getNotifications() async {
    try {
      final response = await _apiClient.get(
        endPoint: ApiEndPoints.getNotifications,
        showErrorMessage: false,
      );
      final list =
          response.data
              ?.map<NotificationsModel>((e) => NotificationsModel.fromJson(e))
              .toList();
      return Right(list);
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<AppException, Unit>> readNotifications() async {
    try {
      await _apiClient.get(
        endPoint: ApiEndPoints.readNotification,
        showErrorMessage: false,
      );
      return const Right(unit);
    } on AppException catch (e) {
      return Left(e);
    }
  }
}

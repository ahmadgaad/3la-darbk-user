import 'package:dartz/dartz.dart';
import '../../../core/data/exceptions/exceptions.dart';
import '../../../core/data/remote/api_end_points.dart';
import '../../../core/data/remote/api_client.dart';
import 'models/settings_info_model.dart';

abstract class SettingsInfoRepository {
  Future<Either<SettingsInfoModel, AppException>> getSettingsInfo();
}

class SettingsInfoRepositoryImpl implements SettingsInfoRepository {
  final ApiClient _apiClient;

  SettingsInfoRepositoryImpl(this._apiClient);

  
  @override
  Future<Either<SettingsInfoModel, AppException>> getSettingsInfo() async {
    try {
      final response = await _apiClient.get(endPoint: ApiEndPoints.settingsInfo);
      final settingsInfoModel = SettingsInfoModel.fromJson(response.data);
      return Left(settingsInfoModel);
    } on AppException catch (e) {
      return Right(e);
    }
  }
}

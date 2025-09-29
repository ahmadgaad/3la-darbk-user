import 'package:dartz/dartz.dart';
import '../../../core/networking/exceptions.dart';
import '../../../core/networking/api_end_points.dart';
import '../../../core/networking/api_client.dart';
import 'models/category_model.dart';

abstract class CategoriesRepository {
  Future<Either<List<CategoryModel>, AppException>> getCategories();
}

class CategoriesRepositoryImpl implements CategoriesRepository {
  final ApiClient _apiClient;

  CategoriesRepositoryImpl(this._apiClient);

  @override
  Future<Either<List<CategoryModel>, AppException>> getCategories() async {
    try {
      final response = await _apiClient.get(endPoint: ApiEndPoints.categories);
      final list = response.data
          ?.map<CategoryModel>((e) => CategoryModel.fromJson(e))
          .toList();
      return Left(list);
    } on AppException catch (e) {
      return Right(e);
    }
  }
  
}

import 'package:dio/dio.dart';

import '../dependency_injection/di.dart';
import '../heplers/shared_preferences_helper.dart';
import 'api_end_points.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final listOfPaths = <String>[
      ApiEndPoints.login,
      ApiEndPoints.register,
      ApiEndPoints.sendCode,
      ApiEndPoints.forgetPassword,
      ApiEndPoints.categories,
      ApiEndPoints.cities,
      ApiEndPoints.settingsInfo,
    ];

    if (listOfPaths.contains(options.path.toString())) {
      return handler.next(options);
    }

    options.headers.addAll({
      'Authorization': "Bearer ${sl<SharedPreferencesHelper>().token}",
    });
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    return handler.next(err);
  }
}

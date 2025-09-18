import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/app_config.dart';
import 'core/data/local/shared_preferences_service.dart';
import 'core/data/remote/api_client.dart';
import 'core/data/remote/auth_interceptor.dart';
import 'features/auth/repositories/repositories.dart';
import 'features/categories/repositories/repositories.dart';
import 'features/map/repositories/map_repo.dart';
import 'features/notifications/repositories/repositories.dart';
import 'features/order/repositories/repositories.dart';
import 'features/orders/repositories/repositories.dart';
import 'features/profile/repositories/repositories.dart';
import 'package:http/http.dart' show Client;

import 'features/setttings_info/repositories/repositories.dart';
import 'features/trips/repositories/repositories.dart';

final sl = GetIt.instance;

class DpInjection {
  static void init() async{
    ///Services
    await _initSharedPref();
    _serviceInit();
    _apiClientInit();
    ///Repositories
    _authRepoInit();
    _historyOrderRepoInit();
    _profileRepoInit();
    _tripRepoInit();
    _mapRepoInit();
    _orderRepoInit();
    _notificationsRepo();

    _categoriesRepoInit();
    _setttingsInfoRepoInit();
  }
static Future<void> _initSharedPref() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferencesService>(
    SharedPreferencesService (sharedPreferences: sharedPreferences),
  );
}
  static _serviceInit() {
    sl.registerLazySingleton<Client>(() => Client());
   
  }
  static void _apiClientInit() {
       sl.registerSingleton<Dio>(Dio(
    BaseOptions(
      baseUrl:AppConfig.baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(milliseconds: 60 * 1000),
      sendTimeout: const Duration(milliseconds: 60 * 1000),
      receiveTimeout: const Duration(milliseconds: 60 * 1000),
    ),
  )..interceptors.addAll([
      AuthInterceptor(),
      LogInterceptor(
        request: false,
        responseHeader: false,
        error: false,
        requestBody: true,
        responseBody: true,
      ),
    ]));

  sl.registerSingleton<Logger>(Logger());

  sl.registerSingleton<ApiClient>(
    ApiClient(dio: sl(), logger: sl()),
  );
  }


  static _authRepoInit() {
    sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl(),sl()));
  }

  static _historyOrderRepoInit() {
    sl.registerLazySingleton<OrdersRepository>(() => OrdersRepositoryImpl(sl()));
  }



  static void _profileRepoInit() {
    sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(sl(),sl()));
  }

  static void _tripRepoInit() {
    sl.registerLazySingleton<TripsRepository>(() => TripsRepositoryImpl(sl()));
  }
  
  static void _mapRepoInit() {
    sl.registerLazySingleton<MapRepo>(() => MapRepoImp());

  }
  
  static void _orderRepoInit() {
    sl.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl(sl()));
  }
  
  static void _categoriesRepoInit() {
    sl.registerLazySingleton<CategoriesRepository>(() => CategoriesRepositoryImpl(sl()));
  }
   static void _notificationsRepo() {
    sl.registerLazySingleton<NotificationsRepo>(() => NotificationsRepoImpl(sl()));
  }
  
  static void _setttingsInfoRepoInit() {
    sl.registerLazySingleton<SettingsInfoRepository>(() => SettingsInfoRepositoryImpl(sl()));
  }
  
}

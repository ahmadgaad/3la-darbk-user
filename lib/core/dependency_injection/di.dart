import 'package:ala_darbak_user/features/auth/presentation/view_model/login_cubit/cubit.dart';
import 'package:ala_darbak_user/features/auth/presentation/view_model/register_cubit/register_cubit.dart';
import 'package:ala_darbak_user/features/profile/presentation/manager/profile_cubit/cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' show Client;
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/repository/repository.dart';
import '../../features/categories/repositories/repositories.dart';
import '../../features/map/repositories/map_repo.dart';
import '../../features/notifications/repositories/repositories.dart';
import '../../features/order/repositories/repositories.dart';
import '../../features/orders/repositories/repositories.dart';
import '../../features/profile/repositories/repositories.dart';
import '../../features/setttings_info/repositories/repositories.dart';
import '../../features/trips/repositories/repositories.dart';
import '../config/app_config.dart';
import '../heplers/shared_preferences_service.dart';
import '../networking/api_client.dart';
import '../networking/auth_interceptor.dart';

final sl = GetIt.instance;

class InjectionContainer {
  static Future<void> init() async {
    ///Services
    await _initSharedPref();
    _serviceInit();
    _apiClientInit();

    ///Repositories
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl(), sl()),
    );
    _historyOrderRepoInit();
    _profileRepoInit();
    _tripRepoInit();
    _mapRepoInit();
    _orderRepoInit();
    _notificationsRepo();

    _categoriesRepoInit();
    _setttingsInfoRepoInit();

    sl.registerFactory(() => ProfileCubit(sl<ProfileRepository>()));
    sl.registerFactory(() => RegisterCubit(sl<AuthRepository>()));
    sl.registerFactory(() => LoginCubit(sl<AuthRepository>()));
  }
















  static Future<void> _initSharedPref() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerSingleton<SharedPreferencesService>(
      SharedPreferencesService(sharedPreferences: sharedPreferences),
    );
  }

  static _serviceInit() {
    sl.registerLazySingleton<Client>(() => Client());
  }

  static void _apiClientInit() {
    sl.registerSingleton<Dio>(
      Dio(
          BaseOptions(
            baseUrl: AppConfig.baseUrl,
            receiveDataWhenStatusError: true,
            connectTimeout: const Duration(milliseconds: 60 * 1000),
            sendTimeout: const Duration(milliseconds: 60 * 1000),
            receiveTimeout: const Duration(milliseconds: 60 * 1000),
          ),
        )
        ..interceptors.addAll([
          AuthInterceptor(),
          PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
            responseBody: true,
            responseHeader: false,
            error: true,
            compact: true,
            maxWidth: 90,
          ),
        ]),
    );

    sl.registerSingleton<Logger>(Logger());

    sl.registerSingleton<ApiClient>(ApiClient(dio: sl(), logger: sl()));
  }

  static _historyOrderRepoInit() {
    sl.registerLazySingleton<OrdersRepository>(
      () => OrdersRepositoryImpl(sl()),
    );
  }

  static void _profileRepoInit() {
    sl.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(sl(), sl()),
    );
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
    sl.registerLazySingleton<CategoriesRepository>(
      () => CategoriesRepositoryImpl(sl()),
    );
  }

  static void _notificationsRepo() {
    sl.registerLazySingleton<NotificationsRepo>(
      () => NotificationsRepoImpl(sl()),
    );
  }

  static void _setttingsInfoRepoInit() {
    sl.registerLazySingleton<SettingsInfoRepository>(
      () => SettingsInfoRepositoryImpl(sl()),
    );
  }
}

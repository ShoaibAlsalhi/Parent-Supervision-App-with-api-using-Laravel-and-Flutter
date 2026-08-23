import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:parent_supervision/core/network/dio_client.dart';
import 'package:parent_supervision/core/utils/secure_storage_helper.dart';

import 'package:parent_supervision/data/datasources/auth_remote_data_source.dart';
import 'package:parent_supervision/data/repositories/auth_repository.dart';
import 'package:parent_supervision/presentation/cubits/auth/auth_cubit.dart';

import 'package:parent_supervision/data/datasources/device_remote_data_source.dart';
import 'package:parent_supervision/data/repositories/device_repository.dart';
import 'package:parent_supervision/presentation/cubits/device/device_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<SecureStorageHelper>(() => SecureStorageHelper(sl()));
  sl.registerLazySingleton<DioClient>(() => DioClient(sl(), sl()));

  // Auth
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository(sl(), sl()));
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl()));

  // Device
  sl.registerLazySingleton<DeviceRemoteDataSource>(() => DeviceRemoteDataSource(sl()));
  sl.registerLazySingleton<DeviceRepository>(() => DeviceRepository(sl(), sl()));
  sl.registerFactory<DeviceCubit>(() => DeviceCubit(sl()));

  //offline
  sl.registerLazySingleton<Box>(() => Hive.box('offline_box'));
}
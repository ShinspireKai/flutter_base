import 'package:flutter_base_project/core/network/dio_base.dart';
import 'package:flutter_base_project/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_base_project/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_base_project/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_base_project/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_base_project/features/auth/domain/usecases/check_login_status_usecase.dart';
import 'package:flutter_base_project/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_base_project/features/auth/domain/usecases/logout_usecase.dart';
import 'package:flutter_base_project/features/home/data/datasources/home_remote_datasource.dart';
import 'package:flutter_base_project/features/home/data/repositories/home_repository_impl.dart';
import 'package:flutter_base_project/features/home/domain/repositories/home_repository.dart';
import 'package:flutter_base_project/features/home/domain/usecases/get_user_profile_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Setup DI cho toàn bộ features
///
/// Nguyên tắc Dependency Inversion:
/// - Register theo interface (abstraction)
/// - Resolve implementation tại đây — không ở nơi khác
Future<void> setupFeaturesDI(GetIt sl) async {
  final sharedPreferences = await SharedPreferences.getInstance();

  // ═══════════════════════════════════════════════════════════════════════
  // Shared DioBase — dùng chung cho DataSources ở tầng data
  // (Khác với DioBase inject vào Model trong MVP — cái đó tạo per-presenter)
  // ═══════════════════════════════════════════════════════════════════════
  sl.registerLazySingleton<DioBase>(
    () => DioBase(
      onLoading: (_) {}, // DataSource không cần loading overlay (BLoC lo)
      onError: (_) {},   // Repository sẽ catch exception và map thành Failure
    ),
  );

  // ═══════════════════════════════════════════════════════════════════════
  // Auth Feature
  // ═══════════════════════════════════════════════════════════════════════

  // Data Sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl<DioBase>()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      localDataSource: sl<AuthLocalDataSource>(),
    ),
  );

  // Use Cases
  sl.registerFactory(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerFactory(() => LogoutUseCase(sl<AuthRepository>()));
  sl.registerFactory(() => CheckLoginStatusUseCase(sl<AuthRepository>()));

  // ═══════════════════════════════════════════════════════════════════════
  // Home Feature
  // ═══════════════════════════════════════════════════════════════════════

  // Data Sources
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      remoteDataSource: sl<HomeRemoteDataSource>(),
    ),
  );

  // Use Cases
  sl.registerFactory(() => GetUserProfileUseCase(sl<HomeRepository>()));
}

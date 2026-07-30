import 'package:inspection_app/core/local/local_storage.dart';
import 'package:inspection_app/core/network/dio_base.dart';
import 'package:inspection_app/core/services/biometric_auth_service.dart';
import 'package:inspection_app/core/services/local_notification_service.dart';
import 'package:inspection_app/core/services/photo_capture_service.dart';
import 'package:inspection_app/core/services/push_notification_service.dart';
import 'package:inspection_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:inspection_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:inspection_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:inspection_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:inspection_app/features/auth/domain/usecases/biometric_login_usecase.dart';
import 'package:inspection_app/features/auth/domain/usecases/check_login_status_usecase.dart';
import 'package:inspection_app/features/auth/domain/usecases/get_cached_user_usecase.dart';
import 'package:inspection_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:inspection_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:inspection_app/features/inspector_home/inspector/data/datasources/equipment_inspection_remote_datasource.dart';
import 'package:inspection_app/features/inspector_home/data/datasources/inspector_home_remote_datasource.dart';
import 'package:inspection_app/features/inspector_home/inspector/data/datasources/today_inspection_remote_datasource.dart';
import 'package:inspection_app/features/inspector_home/inspector/data/repositories/equipment_inspection_repository_impl.dart';
import 'package:inspection_app/features/inspector_home/data/repositories/inspector_home_repository_impl.dart';
import 'package:inspection_app/features/inspector_home/inspector/data/repositories/today_inspection_repository_impl.dart';
import 'package:inspection_app/features/inspector_home/inspector/domain/repositories/equipment_inspection_repository.dart';
import 'package:inspection_app/features/inspector_home/domain/repositories/inspector_home_repository.dart';
import 'package:inspection_app/features/inspector_home/inspector/domain/repositories/today_inspection_repository.dart';
import 'package:inspection_app/features/inspector_home/inspector/domain/usecases/get_equipment_inspection_checklist_usecase.dart';
import 'package:inspection_app/features/inspector_home/domain/usecases/get_inspector_profile_usecase.dart';
import 'package:inspection_app/features/inspector_home/inspector/domain/usecases/get_today_inspections_usecase.dart';
import 'package:inspection_app/features/inspector_home/inspector/domain/usecases/submit_inspection_report_usecase.dart';
import 'package:inspection_app/features/inspector_home/maintenance/data/datasources/maintenance_task_remote_datasource.dart';
import 'package:inspection_app/features/inspector_home/maintenance/data/repositories/maintenance_task_repository_impl.dart';
import 'package:inspection_app/features/inspector_home/maintenance/domain/repositories/maintenance_task_repository.dart';
import 'package:inspection_app/features/inspector_home/maintenance/domain/usecases/get_maintenance_task_by_ticket_no_usecase.dart';
import 'package:inspection_app/features/inspector_home/maintenance/domain/usecases/get_maintenance_tasks_usecase.dart';
import 'package:inspection_app/features/inspector_home/maintenance/domain/usecases/update_maintenance_task_usecase.dart';
import 'package:inspection_app/features/inspector_home/maintenance/domain/usecases/verify_ticket_entry_code_usecase.dart';
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
  // Notifications (Firebase Cloud Messaging + Local Notifications) —
  // dùng chung toàn app, khởi tạo (init()) ngay trong main() trước runApp()
  // ═══════════════════════════════════════════════════════════════════════
  sl.registerLazySingleton<LocalNotificationService>(
    () => LocalNotificationServiceImpl(),
  );
  sl.registerLazySingleton<PushNotificationService>(
    () => PushNotificationServiceImpl(
      localStorage: sl<LocalStorage>(),
      localNotificationService: sl<LocalNotificationService>(),
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

  // Biometric hardware service — dùng chung cho LoginBloc
  sl.registerLazySingleton<BiometricAuthService>(
    () => BiometricAuthServiceImpl(),
  );

  // Use Cases
  sl.registerFactory(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerFactory(() => LogoutUseCase(sl<AuthRepository>()));
  sl.registerFactory(() => CheckLoginStatusUseCase(sl<AuthRepository>()));
  sl.registerFactory(() => BiometricLoginUseCase(sl<AuthRepository>()));
  sl.registerFactory(() => GetCachedUserUseCase(sl<AuthRepository>()));

  // ═══════════════════════════════════════════════════════════════════════
  // InspectorHome Feature (巡檢人員)
  // ═══════════════════════════════════════════════════════════════════════

  // Data Sources
  sl.registerLazySingleton<InspectorHomeRemoteDataSource>(
    () => InspectorHomeRemoteDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<InspectorHomeRepository>(
    () => InspectorHomeRepositoryImpl(
      remoteDataSource: sl<InspectorHomeRemoteDataSource>(),
    ),
  );

  // Use Cases
  sl.registerFactory(
    () => GetInspectorProfileUseCase(sl<InspectorHomeRepository>()),
  );

  // ═══════════════════════════════════════════════════════════════════════
  // TodayInspection Feature (今日巡檢 — trang con của InspectorHome)
  // ═══════════════════════════════════════════════════════════════════════

  // Data Sources
  sl.registerLazySingleton<TodayInspectionRemoteDataSource>(
    () => TodayInspectionRemoteDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<TodayInspectionRepository>(
    () => TodayInspectionRepositoryImpl(
      remoteDataSource: sl<TodayInspectionRemoteDataSource>(),
    ),
  );

  // Use Cases
  sl.registerFactory(
    () => GetTodayInspectionsUseCase(sl<TodayInspectionRepository>()),
  );

  // ═══════════════════════════════════════════════════════════════════════
  // EquipmentInspection Feature (設備巡檢 — trang con của InspectorHome,
  // bước tiếp theo sau khi chọn 1 hạng mục trong「今日巡檢」)
  // ═══════════════════════════════════════════════════════════════════════

  // Chụp/chọn ảnh hiện trường — dùng chung cho mọi tuyến kiểm tra
  sl.registerLazySingleton<PhotoCaptureService>(
    () => PhotoCaptureServiceImpl(),
  );

  // Data Sources
  sl.registerLazySingleton<EquipmentInspectionRemoteDataSource>(
    () => EquipmentInspectionRemoteDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<EquipmentInspectionRepository>(
    () => EquipmentInspectionRepositoryImpl(
      remoteDataSource: sl<EquipmentInspectionRemoteDataSource>(),
    ),
  );

  // Use Cases
  sl.registerFactory(
    () => GetEquipmentInspectionChecklistUseCase(
      sl<EquipmentInspectionRepository>(),
    ),
  );
  sl.registerFactory(
    () => SubmitInspectionReportUseCase(sl<EquipmentInspectionRepository>()),
  );

  // ═══════════════════════════════════════════════════════════════════════
  // MaintenanceTask Feature (維修人員 — 我的維修任務, trang con của InspectorHome)
  // ═══════════════════════════════════════════════════════════════════════

  // Data Sources
  sl.registerLazySingleton<MaintenanceTaskRemoteDataSource>(
    () => MaintenanceTaskRemoteDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<MaintenanceTaskRepository>(
    () => MaintenanceTaskRepositoryImpl(
      remoteDataSource: sl<MaintenanceTaskRemoteDataSource>(),
    ),
  );

  // Use Cases
  sl.registerFactory(
    () => GetMaintenanceTasksUseCase(sl<MaintenanceTaskRepository>()),
  );
  sl.registerFactory(
    () => UpdateMaintenanceTaskUseCase(sl<MaintenanceTaskRepository>()),
  );
  sl.registerFactory(
    () => GetMaintenanceTaskByTicketNoUseCase(sl<MaintenanceTaskRepository>()),
  );
  sl.registerFactory(
    () => VerifyTicketEntryCodeUseCase(sl<MaintenanceTaskRepository>()),
  );
}

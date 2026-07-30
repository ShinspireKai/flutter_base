import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:inspection_app/core/arch/logger/app_logger_impl.dart';
import 'package:inspection_app/core/di.dart';
import 'package:inspection_app/core/di/features_di.dart';
import 'package:inspection_app/core/router/auto_route_config.dart';
import 'package:inspection_app/core/router/router_module.dart';
import 'package:inspection_app/core/services/biometric_auth_service.dart';
import 'package:inspection_app/core/services/local_notification_service.dart';
import 'package:inspection_app/core/services/push_notification_service.dart';
import 'package:inspection_app/core/usecases/usecase.dart';
import 'package:inspection_app/firebase_options.dart';
import 'package:inspection_app/features/auth/domain/entities/user_role.dart';
import 'package:inspection_app/features/auth/domain/usecases/biometric_login_usecase.dart';
import 'package:inspection_app/features/auth/domain/usecases/check_login_status_usecase.dart';
import 'package:inspection_app/features/auth/domain/usecases/get_cached_user_usecase.dart';
import 'package:inspection_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:inspection_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:inspection_app/features/auth/presentation/bloc/login_bloc.dart';
import 'package:inspection_app/features/inspector_home/domain/usecases/get_inspector_profile_usecase.dart';
import 'package:inspection_app/features/inspector_home/inspector/domain/usecases/get_today_inspections_usecase.dart';
import 'package:inspection_app/features/inspector_home/maintenance/domain/usecases/get_maintenance_tasks_usecase.dart';
import 'package:inspection_app/features/inspector_home/presentation/bloc/inspector_home_bloc.dart';
import 'package:inspection_app/features/inspector_home/presentation/bloc/inspector_home_event.dart';
import 'package:inspection_app/features/inspector_home/inspector/presentation/bloc/today_inspection_bloc.dart';
import 'package:inspection_app/features/inspector_home/maintenance/presentation/bloc/maintenance_task_bloc.dart';
import 'package:inspection_app/features/inspector_home/maintenance/presentation/bloc/pending_recheck_bloc.dart';
import 'package:inspection_app/util/res/theme_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'core/l10n/app_localizations.dart';

/// Global navigator key — dùng cho toast/dialog không có context
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Host + path prefix của link 派工 gửi qua SMS/Email (「維修單回報」V1)
/// vd: https://eip.shinspire.com.tw/repair?no=0523
const _repairLinkHost = 'eip.shinspire.com.tw';
const _repairLinkPathPrefix = '/repair';

/// Số phiếu (`?no=`) từ link SMS/Email đã mở app (cold start) — được đọc
/// trước khi build UI để MainAppPage có thể bỏ qua bước kiểm tra đăng nhập
/// và vào thẳng màn hình「維修單回報」(luồng passwordless của 外包廠商).
String? _initialTicketNo;

/// Trích 報修單 số từ URI nếu đúng định dạng link 派工, ngược lại null
String? _extractTicketNo(Uri uri) {
  if (uri.host != _repairLinkHost || !uri.path.startsWith(_repairLinkPathPrefix)) {
    return null;
  }
  final no = uri.queryParameters['no'];
  return (no != null && no.isNotEmpty) ? no : null;
}

/// Xử lý tin nhắn FCM khi app đang ở background/bị kill — chạy trong 1
/// isolate riêng biệt (không chia sẻ state với isolate chính) nên phải tự
/// init lại Firebase ở đây. Bắt buộc là top-level function (không phải
/// closure) và có @pragma('vm:entry-point') để Flutter giữ lại lúc build release.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  logger.i('FCM background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await configureDependencies();
  await setupFeaturesDI(sl);
  await sl<LocalNotificationService>().init();
  await sl<PushNotificationService>().init();
  InitGuard.markReady();

  final initialUri = await AppLinks().getInitialLink();
  if (initialUri != null) {
    _initialTicketNo = _extractTicketNo(initialUri);
  }

  runApp(const MyApp());
}

/// Root App Widget
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _routerModule = RouterModule();
  late final AppRouter _appRouter = _routerModule.appRouter();
  late final _routerObserver = _routerModule.routerLoggingObserver(_appRouter);
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    // Bắt link SMS/Email khi app đang chạy (khác với _initialTicketNo, chỉ
    // xử lý lúc cold start) — luôn điều hướng thẳng vào「維修單回報」,
    // ghi đè bất kỳ màn hình nào đang hiển thị vì đây là luồng passwordless
    // dành riêng cho 1 phiếu cụ thể.
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      final ticketNo = _extractTicketNo(uri);
      if (ticketNo != null) {
        _appRouter.replaceAll([ContractorHomeRoute(ticketNo: ticketNo)]);
      }
    });
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // LoginBloc — cung cấp toàn app để LoginPage dùng
        BlocProvider<LoginBloc>(
          create: (_) => LoginBloc(
            loginUseCase: sl<LoginUseCase>(),
            biometricLoginUseCase: sl<BiometricLoginUseCase>(),
            biometricAuthService: sl<BiometricAuthService>(),
          ),
        ),
        // InspectorHomeBloc — cung cấp toàn app cho Home của 巡檢人員 (Inspector)
        BlocProvider<InspectorHomeBloc>(
          create: (_) => InspectorHomeBloc(
            getInspectorProfileUseCase: sl<GetInspectorProfileUseCase>(),
            logoutUseCase: sl<LogoutUseCase>(),
          ),
        ),
        // TodayInspectionBloc — cung cấp toàn app cho trang「今日巡檢」(trang con của InspectorHome)
        BlocProvider<TodayInspectionBloc>(
          create: (_) => TodayInspectionBloc(
            getTodayInspectionsUseCase: sl<GetTodayInspectionsUseCase>(),
          ),
        ),
        // MaintenanceTaskBloc — cung cấp toàn app cho trang「我的維修任務」(trang con của InspectorHome)
        BlocProvider<MaintenanceTaskBloc>(
          create: (_) => MaintenanceTaskBloc(
            getMaintenanceTasksUseCase: sl<GetMaintenanceTasksUseCase>(),
          ),
        ),
        // PendingRecheckBloc — cung cấp toàn app cho trang「待我複檢」(trang con của InspectorHome)
        BlocProvider<PendingRecheckBloc>(
          create: (_) => PendingRecheckBloc(
            getMaintenanceTasksUseCase: sl<GetMaintenanceTasksUseCase>(),
          ),
        ),
      ],
      child: MaterialApp.router(
        title: 'Flutter Base',
        debugShowCheckedModeBanner: false,
        theme: LightModeTheme().themeData,
        locale: const Locale('zh'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: _appRouter.config(
          navigatorObservers: () => [_routerObserver],
        ),
        // EasyLoading overlay builder
        builder: EasyLoading.init(),
      ),
    );
  }
}

/// MainAppPage — Splash screen kiểm tra login status rồi điều hướng
///
/// Đây là entry point của router (initial: true)
/// MVP note: đây là View đơn giản, không cần Presenter vì logic rất ít
@RoutePage()
class MainAppPage extends StatefulWidget {
  const MainAppPage({super.key});

  @override
  State<MainAppPage> createState() => _MainAppPageState();
}

class _MainAppPageState extends State<MainAppPage> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Vào từ link SMS/Email (?no=...) — bỏ qua kiểm tra đăng nhập, vào
    // thẳng「維修單回報」vì đây là luồng passwordless của 外包廠商.
    final ticketNo = _initialTicketNo;
    if (ticketNo != null) {
      context.router.replace(ContractorHomeRoute(ticketNo: ticketNo));
      return;
    }

    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    final checkLoginUseCase = sl<CheckLoginStatusUseCase>();
    final result = await checkLoginUseCase(NoParams());

    if (!mounted) return;

    result.fold((_) => context.router.replace(const LoginRoute()), (
      isLoggedIn,
    ) async {
      if (!isLoggedIn) {
        context.router.replace(const LoginRoute());
        return;
      }

      // Đã login — lấy cached user để biết role, điều hướng đúng Home
      final userResult = await sl<GetCachedUserUseCase>()(NoParams());
      if (!mounted) return;

      userResult.fold(
        (_) => context.router.replace(const LoginRoute()),
        (user) {
          if (user.isContractor) {
            // Mock demo: ticket #0523 (mã 進入代碼 284913) được seed sẵn trong
            // MaintenanceTaskRemoteDataSourceImpl để test luồng không cần SMS thật
            context.router.replace(ContractorHomeRoute(ticketNo: '0523'));
          } else {
            context.read<InspectorHomeBloc>().add(const InspectorHomeLoadUserProfile());
            context.router.replace(const InspectorHomeRoute());
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withValues(alpha: 0.65),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).primaryColor.withValues(alpha: 0.35),
                    blurRadius: 22,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.flutter_dash,
                color: Colors.white,
                size: 46,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              AppLocalizations.of(context)!.splashAppName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              AppLocalizations.of(context)!.splashTagline,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).primaryColorDark,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 44),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

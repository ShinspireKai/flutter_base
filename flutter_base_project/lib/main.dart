import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_project/core/di.dart';
import 'package:flutter_base_project/core/di/features_di.dart';
import 'package:flutter_base_project/core/router/auto_route_config.dart';
import 'package:flutter_base_project/core/usecases/usecase.dart';
import 'package:flutter_base_project/features/auth/domain/usecases/check_login_status_usecase.dart';
import 'package:flutter_base_project/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_base_project/features/auth/domain/usecases/logout_usecase.dart';
import 'package:flutter_base_project/features/auth/presentation/bloc/login_bloc.dart';
import 'package:flutter_base_project/features/home/domain/usecases/get_user_profile_usecase.dart';
import 'package:flutter_base_project/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter_base_project/features/home/presentation/bloc/home_event.dart';
import 'package:flutter_base_project/view/res/theme_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'core/l10n/app_localizations.dart';

/// Global navigator key — dùng cho toast/dialog không có context
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await setupFeaturesDI(sl);
  runApp(const MyApp());
}

/// Root App Widget
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // LoginBloc — cung cấp toàn app để LoginPage dùng
        BlocProvider<LoginBloc>(
          create: (_) => LoginBloc(loginUseCase: sl<LoginUseCase>()),
        ),
        // HomeBloc — cung cấp toàn app, tự load profile khi login xong
        BlocProvider<HomeBloc>(
          create: (_) => HomeBloc(
            getUserProfileUseCase: sl<GetUserProfileUseCase>(),
            logoutUseCase: sl<LogoutUseCase>(),
          )..add(const HomeLoadUserProfile()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Flutter Base',
        debugShowCheckedModeBanner: false,
        theme: LightModeTheme().themeData,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: _appRouter.config(),
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
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    final checkLoginUseCase = sl<CheckLoginStatusUseCase>();
    final result = await checkLoginUseCase(NoParams());

    if (!mounted) return;

    result.fold(
      (_) => context.router.replaceNamed('/login'),
      (isLoggedIn) {
        if (isLoggedIn) {
          context.read<HomeBloc>().add(const HomeLoadUserProfile());
          context.router.replaceNamed('/home');
        } else {
          context.router.replaceNamed('/login');
        }
      },
    );
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
                    Theme.of(context).primaryColor.withOpacity(0.65),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.35),
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
              'Flutter Base',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColorLight,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              'Clean Architecture · BLoC · MVP',
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

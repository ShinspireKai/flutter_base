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

import 'core/l10n/app_localizations.dart';

GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await setupFeaturesDI(sl);
  runApp(const MyApp());
}

/// Root app — wires up Router và MultiBlocProvider
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
        BlocProvider<LoginBloc>(
          create: (_) => LoginBloc(loginUseCase: sl<LoginUseCase>()),
        ),
        BlocProvider<HomeBloc>(
          create: (_) => HomeBloc(
            getUserProfileUseCase: sl<GetUserProfileUseCase>(),
            logoutUseCase: sl<LogoutUseCase>(),
          ),
        ),
      ],
      child: MaterialApp.router(
        title: 'Flutter Base',
        debugShowCheckedModeBanner: false,
        theme: LightModeTheme().themeData,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: _appRouter.config(),
      ),
    );
  }
}

/// MainAppPage — Splash screen kiểm tra trạng thái login rồi điều hướng
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
    // Delay nhỏ để splash hiển thị
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    final checkLoginUseCase = sl<CheckLoginStatusUseCase>();
    final result = await checkLoginUseCase(NoParams());

    if (!mounted) return;

    result.fold(
      (_) => context.router.replaceNamed('/login'),
      (isLoggedIn) {
        if (isLoggedIn) {
          context.router.replaceNamed('/home');
          context.read<HomeBloc>().add(const HomeLoadUserProfile());
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
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.flutter_dash,
                color: Colors.white,
                size: 44,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Flutter Base',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColorLight,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Clean Architecture + BLoC',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).primaryColorDark,
                  ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

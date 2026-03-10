import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_project/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_base_project/features/home/presentation/pages/home_page.dart';
import 'package:flutter_base_project/main.dart';

part 'auto_route_config.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: MainAppRoute.page, initial: true),
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: HomeRoute.page),
      ];
}


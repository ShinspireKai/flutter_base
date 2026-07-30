import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inspection_app/features/auth/presentation/pages/login_page.dart';
import 'package:inspection_app/features/contractor_home/presentation/pages/contractor_home_page.dart';
import 'package:inspection_app/features/inspector_home/inspector/domain/entities/inspection_route_entity.dart';
import 'package:inspection_app/features/inspector_home/inspector/presentation/bloc/equipment_inspection_bloc.dart';
import 'package:inspection_app/features/inspector_home/inspector/presentation/pages/equipment_inspection_page.dart';
import 'package:inspection_app/features/inspector_home/inspector/presentation/pages/inspection_completed_page.dart';
import 'package:inspection_app/features/inspector_home/presentation/pages/inspector_home_page.dart';
import 'package:inspection_app/features/inspector_home/inspector/presentation/pages/photo_record_page.dart';
import 'package:inspection_app/features/inspector_home/inspector/presentation/pages/signature_confirmation_page.dart';
import 'package:inspection_app/features/inspector_home/inspector/presentation/pages/today_inspection_page.dart';
import 'package:inspection_app/features/inspector_home/maintenance/domain/entities/maintenance_task_entity.dart';
import 'package:inspection_app/features/inspector_home/maintenance/presentation/pages/maintenance_report_page.dart';
import 'package:inspection_app/features/inspector_home/maintenance/presentation/pages/maintenance_rework_page.dart';
import 'package:inspection_app/features/inspector_home/maintenance/presentation/pages/maintenance_task_page.dart';
import 'package:inspection_app/features/inspector_home/maintenance/presentation/pages/pending_recheck_page.dart';
import 'package:inspection_app/features/inspector_home/maintenance/presentation/pages/recheck_decision_page.dart';
import 'package:inspection_app/main.dart';

export 'guard/init_guard.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  final List<AutoRouteGuard> globalGuards;

  AppRouter({this.globalGuards = const []});

  @override
  List<AutoRouteGuard> get guards => globalGuards;

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: MainAppRoute.page, initial: true),
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: InspectorHomeRoute.page),
        AutoRoute(page: TodayInspectionRoute.page),
        AutoRoute(page: EquipmentInspectionRoute.page),
        AutoRoute(page: PhotoRecordRoute.page),
        AutoRoute(page: SignatureConfirmationRoute.page),
        AutoRoute(page: InspectionCompletedRoute.page),
        AutoRoute(page: ContractorHomeRoute.page),
        AutoRoute(page: MaintenanceTaskRoute.page),
        AutoRoute(page: MaintenanceReportRoute.page),
        AutoRoute(page: MaintenanceReworkRoute.page),
        AutoRoute(page: PendingRecheckRoute.page),
        AutoRoute(page: RecheckDecisionRoute.page),
      ];
}

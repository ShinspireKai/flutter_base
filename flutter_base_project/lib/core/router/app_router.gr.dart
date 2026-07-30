// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [ContractorHomePage]
class ContractorHomeRoute extends PageRouteInfo<ContractorHomeRouteArgs> {
  ContractorHomeRoute({
    Key? key,
    String? ticketNo,
    List<PageRouteInfo>? children,
  }) : super(
          ContractorHomeRoute.name,
          args: ContractorHomeRouteArgs(
            key: key,
            ticketNo: ticketNo,
          ),
          initialChildren: children,
        );

  static const String name = 'ContractorHomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ContractorHomeRouteArgs>(
          orElse: () => const ContractorHomeRouteArgs());
      return ContractorHomePage(
        key: args.key,
        ticketNo: args.ticketNo,
      );
    },
  );
}

class ContractorHomeRouteArgs {
  const ContractorHomeRouteArgs({
    this.key,
    this.ticketNo,
  });

  final Key? key;

  final String? ticketNo;

  @override
  String toString() {
    return 'ContractorHomeRouteArgs{key: $key, ticketNo: $ticketNo}';
  }
}

/// generated route for
/// [EquipmentInspectionPage]
class EquipmentInspectionRoute
    extends PageRouteInfo<EquipmentInspectionRouteArgs> {
  EquipmentInspectionRoute({
    Key? key,
    required String routeId,
    required String initialTitle,
    required String initialLocation,
    List<PageRouteInfo>? children,
  }) : super(
          EquipmentInspectionRoute.name,
          args: EquipmentInspectionRouteArgs(
            key: key,
            routeId: routeId,
            initialTitle: initialTitle,
            initialLocation: initialLocation,
          ),
          initialChildren: children,
        );

  static const String name = 'EquipmentInspectionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EquipmentInspectionRouteArgs>();
      return EquipmentInspectionPage(
        key: args.key,
        routeId: args.routeId,
        initialTitle: args.initialTitle,
        initialLocation: args.initialLocation,
      );
    },
  );
}

class EquipmentInspectionRouteArgs {
  const EquipmentInspectionRouteArgs({
    this.key,
    required this.routeId,
    required this.initialTitle,
    required this.initialLocation,
  });

  final Key? key;

  final String routeId;

  final String initialTitle;

  final String initialLocation;

  @override
  String toString() {
    return 'EquipmentInspectionRouteArgs{key: $key, routeId: $routeId, initialTitle: $initialTitle, initialLocation: $initialLocation}';
  }
}

/// generated route for
/// [InspectionCompletedPage]
class InspectionCompletedRoute
    extends PageRouteInfo<InspectionCompletedRouteArgs> {
  InspectionCompletedRoute({
    Key? key,
    required InspectionRouteEntity route,
    required DateTime submittedAt,
    List<PageRouteInfo>? children,
  }) : super(
          InspectionCompletedRoute.name,
          args: InspectionCompletedRouteArgs(
            key: key,
            route: route,
            submittedAt: submittedAt,
          ),
          initialChildren: children,
        );

  static const String name = 'InspectionCompletedRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<InspectionCompletedRouteArgs>();
      return InspectionCompletedPage(
        key: args.key,
        route: args.route,
        submittedAt: args.submittedAt,
      );
    },
  );
}

class InspectionCompletedRouteArgs {
  const InspectionCompletedRouteArgs({
    this.key,
    required this.route,
    required this.submittedAt,
  });

  final Key? key;

  final InspectionRouteEntity route;

  final DateTime submittedAt;

  @override
  String toString() {
    return 'InspectionCompletedRouteArgs{key: $key, route: $route, submittedAt: $submittedAt}';
  }
}

/// generated route for
/// [InspectorHomePage]
class InspectorHomeRoute extends PageRouteInfo<void> {
  const InspectorHomeRoute({List<PageRouteInfo>? children})
      : super(
          InspectorHomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'InspectorHomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const InspectorHomePage();
    },
  );
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginPage();
    },
  );
}

/// generated route for
/// [MainAppPage]
class MainAppRoute extends PageRouteInfo<void> {
  const MainAppRoute({List<PageRouteInfo>? children})
      : super(
          MainAppRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainAppRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MainAppPage();
    },
  );
}

/// generated route for
/// [MaintenanceReportPage]
class MaintenanceReportRoute extends PageRouteInfo<MaintenanceReportRouteArgs> {
  MaintenanceReportRoute({
    Key? key,
    required MaintenanceTaskEntity task,
    List<PageRouteInfo>? children,
  }) : super(
          MaintenanceReportRoute.name,
          args: MaintenanceReportRouteArgs(
            key: key,
            task: task,
          ),
          initialChildren: children,
        );

  static const String name = 'MaintenanceReportRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MaintenanceReportRouteArgs>();
      return MaintenanceReportPage(
        key: args.key,
        task: args.task,
      );
    },
  );
}

class MaintenanceReportRouteArgs {
  const MaintenanceReportRouteArgs({
    this.key,
    required this.task,
  });

  final Key? key;

  final MaintenanceTaskEntity task;

  @override
  String toString() {
    return 'MaintenanceReportRouteArgs{key: $key, task: $task}';
  }
}

/// generated route for
/// [MaintenanceReworkPage]
class MaintenanceReworkRoute extends PageRouteInfo<MaintenanceReworkRouteArgs> {
  MaintenanceReworkRoute({
    Key? key,
    required MaintenanceTaskEntity task,
    List<PageRouteInfo>? children,
  }) : super(
          MaintenanceReworkRoute.name,
          args: MaintenanceReworkRouteArgs(
            key: key,
            task: task,
          ),
          initialChildren: children,
        );

  static const String name = 'MaintenanceReworkRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MaintenanceReworkRouteArgs>();
      return MaintenanceReworkPage(
        key: args.key,
        task: args.task,
      );
    },
  );
}

class MaintenanceReworkRouteArgs {
  const MaintenanceReworkRouteArgs({
    this.key,
    required this.task,
  });

  final Key? key;

  final MaintenanceTaskEntity task;

  @override
  String toString() {
    return 'MaintenanceReworkRouteArgs{key: $key, task: $task}';
  }
}

/// generated route for
/// [MaintenanceTaskPage]
class MaintenanceTaskRoute extends PageRouteInfo<void> {
  const MaintenanceTaskRoute({List<PageRouteInfo>? children})
      : super(
          MaintenanceTaskRoute.name,
          initialChildren: children,
        );

  static const String name = 'MaintenanceTaskRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MaintenanceTaskPage();
    },
  );
}

/// generated route for
/// [PendingRecheckPage]
class PendingRecheckRoute extends PageRouteInfo<void> {
  const PendingRecheckRoute({List<PageRouteInfo>? children})
      : super(
          PendingRecheckRoute.name,
          initialChildren: children,
        );

  static const String name = 'PendingRecheckRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PendingRecheckPage();
    },
  );
}

/// generated route for
/// [PhotoRecordPage]
class PhotoRecordRoute extends PageRouteInfo<PhotoRecordRouteArgs> {
  PhotoRecordRoute({
    Key? key,
    required EquipmentInspectionBloc bloc,
    required String itemId,
    List<PageRouteInfo>? children,
  }) : super(
          PhotoRecordRoute.name,
          args: PhotoRecordRouteArgs(
            key: key,
            bloc: bloc,
            itemId: itemId,
          ),
          initialChildren: children,
        );

  static const String name = 'PhotoRecordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PhotoRecordRouteArgs>();
      return PhotoRecordPage(
        key: args.key,
        bloc: args.bloc,
        itemId: args.itemId,
      );
    },
  );
}

class PhotoRecordRouteArgs {
  const PhotoRecordRouteArgs({
    this.key,
    required this.bloc,
    required this.itemId,
  });

  final Key? key;

  final EquipmentInspectionBloc bloc;

  final String itemId;

  @override
  String toString() {
    return 'PhotoRecordRouteArgs{key: $key, bloc: $bloc, itemId: $itemId}';
  }
}

/// generated route for
/// [RecheckDecisionPage]
class RecheckDecisionRoute extends PageRouteInfo<RecheckDecisionRouteArgs> {
  RecheckDecisionRoute({
    Key? key,
    required MaintenanceTaskEntity task,
    List<PageRouteInfo>? children,
  }) : super(
          RecheckDecisionRoute.name,
          args: RecheckDecisionRouteArgs(
            key: key,
            task: task,
          ),
          initialChildren: children,
        );

  static const String name = 'RecheckDecisionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RecheckDecisionRouteArgs>();
      return RecheckDecisionPage(
        key: args.key,
        task: args.task,
      );
    },
  );
}

class RecheckDecisionRouteArgs {
  const RecheckDecisionRouteArgs({
    this.key,
    required this.task,
  });

  final Key? key;

  final MaintenanceTaskEntity task;

  @override
  String toString() {
    return 'RecheckDecisionRouteArgs{key: $key, task: $task}';
  }
}

/// generated route for
/// [SignatureConfirmationPage]
class SignatureConfirmationRoute
    extends PageRouteInfo<SignatureConfirmationRouteArgs> {
  SignatureConfirmationRoute({
    Key? key,
    required EquipmentInspectionBloc bloc,
    List<PageRouteInfo>? children,
  }) : super(
          SignatureConfirmationRoute.name,
          args: SignatureConfirmationRouteArgs(
            key: key,
            bloc: bloc,
          ),
          initialChildren: children,
        );

  static const String name = 'SignatureConfirmationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SignatureConfirmationRouteArgs>();
      return SignatureConfirmationPage(
        key: args.key,
        bloc: args.bloc,
      );
    },
  );
}

class SignatureConfirmationRouteArgs {
  const SignatureConfirmationRouteArgs({
    this.key,
    required this.bloc,
  });

  final Key? key;

  final EquipmentInspectionBloc bloc;

  @override
  String toString() {
    return 'SignatureConfirmationRouteArgs{key: $key, bloc: $bloc}';
  }
}

/// generated route for
/// [TodayInspectionPage]
class TodayInspectionRoute extends PageRouteInfo<void> {
  const TodayInspectionRoute({List<PageRouteInfo>? children})
      : super(
          TodayInspectionRoute.name,
          initialChildren: children,
        );

  static const String name = 'TodayInspectionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TodayInspectionPage();
    },
  );
}

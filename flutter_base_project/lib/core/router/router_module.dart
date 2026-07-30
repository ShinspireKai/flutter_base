import 'app_router.dart';
import 'router_logging_observer.dart';

class RouterModule {
  AppRouter appRouter() {
    return AppRouter(globalGuards: [InitGuard()]);
  }

  RouterLoggingObserver routerLoggingObserver(
    AppRouter appRouter,
  ) {
    return RouterLoggingObserver(
      appRouter: appRouter,
    );
  }
}

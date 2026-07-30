import 'dart:async';

import 'package:auto_route/auto_route.dart';

/// InitGuard — chặn điều hướng cho tới khi DI đã sẵn sàng
/// (configureDependencies() + setupFeaturesDI() trong main() chạy xong).
///
/// main() gọi [InitGuard.markReady] đúng 1 lần ngay sau khi DI init xong,
/// trước runApp(). Guard tồn tại phòng trường hợp runApp() được gọi trước
/// khi DI init hoàn tất (vd sau này đổi sang init bất đồng bộ song song với
/// build UI) — hiện tại DI luôn đã sẵn sàng nên guard sẽ pass ngay lập tức.
class InitGuard extends AutoRouteGuard {
  static final Completer<void> _readyCompleter = Completer<void>();

  static void markReady() {
    if (!_readyCompleter.isCompleted) _readyCompleter.complete();
  }

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    await _readyCompleter.future;
    resolver.next(true);
  }
}

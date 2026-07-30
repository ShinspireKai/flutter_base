import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../core/di.dart';
import '../../../../core/gen/colors.gen.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/auto_route_config.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/domain/usecases/get_cached_user_usecase.dart';
import '../../../auth/domain/usecases/logout_usecase.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AppDrawer — menu điều hướng dùng chung cho các trang của 巡檢人員 (Inspector)
// Dùng lại được ở mọi Scaffold: Scaffold(drawer: const AppDrawer(), ...)
// ─────────────────────────────────────────────────────────────────────────────

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  UserEntity? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final result = await sl<GetCachedUserUseCase>()(NoParams());
    result.fold((_) => null, (user) {
      if (mounted) setState(() => _user = user);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentRoute = context.router.current.name;

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            const SizedBox(height: 8),
            _buildMenuItem(
              context,
              icon: Icons.home_rounded,
              label: l10n.drawerHome,
              isActive: currentRoute == InspectorHomeRoute.name,
              onTap: () => _navigateTo(context, const InspectorHomeRoute()),
            ),
            _buildMenuItem(
              context,
              icon: Icons.checklist_rtl_rounded,
              label: l10n.todayInspectionLabel,
              isActive: currentRoute == TodayInspectionRoute.name,
              onTap: () => _navigateTo(context, const TodayInspectionRoute()),
            ),
            _buildMenuItem(
              context,
              icon: Icons.search_rounded,
              label: l10n.pendingRecheckLabel,
              isActive: currentRoute == PendingRecheckRoute.name,
              onTap: () => _navigateTo(context, const PendingRecheckRoute()),
            ),
            _buildMenuItem(
              context,
              icon: Icons.build_rounded,
              label: l10n.myRepairTasksLabel,
              isActive: currentRoute == MaintenanceTaskRoute.name,
              onTap: () => _navigateTo(context, const MaintenanceTaskRoute()),
            ),
            const Spacer(),
            const Divider(height: 1),
            _buildMenuItem(
              context,
              icon: Icons.logout_rounded,
              label: l10n.logoutAction,
              iconColor: Colors.red.shade400,
              textColor: Colors.red.shade400,
              onTap: () => _confirmLogout(context),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // ─── Header ───────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    final name = _user?.name ?? '...';
    final email = _user?.email ?? '';
    final avatarUrl = _user?.avatarUrl;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
            child: avatarUrl == null
                ? Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Menu item ────────────────────────────────────────────────────────────

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
    Color? iconColor,
    Color? textColor,
  }) {
    final activeColor = Theme.of(context).primaryColor;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? activeColor.withAlpha((0.1 * 255).toInt()) : null,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        leading: Icon(
          icon,
          color:
              iconColor ?? (isActive ? activeColor : ColorName.colorTextGrey),
        ),
        title: Text(
          label,
          style: TextStyle(
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color:
                textColor ?? (isActive ? activeColor : ColorName.greenPrimary),
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  // ─── Actions ──────────────────────────────────────────────────────────────

  void _navigateTo(BuildContext context, PageRouteInfo route) {
    Navigator.of(context).pop();
    if (context.router.current.name != route.routeName) {
      context.router.replace(route);
    }
  }

  void _confirmLogout(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Lấy router trước khi đóng Drawer — context của AppDrawer sẽ unmount
    // ngay sau khi Drawer đóng, nên không thể dùng lại context này sau
    // khi await LogoutUseCase (dialog xác nhận có thể mất vài giây).
    final router = context.router;
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.logout_rounded, color: Colors.red.shade400, size: 24),
            const SizedBox(width: 10),
            Text(l10n.logoutAction),
          ],
        ),
        content: Text(l10n.logoutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(
              l10n.cancel,
              style: TextStyle(color: Theme.of(context).primaryColorDark),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogCtx);
              await _performLogout(router);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade500,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(l10n.logoutAction),
          ),
        ],
      ),
    );
  }

  Future<void> _performLogout(StackRouter router) async {
    await sl<LogoutUseCase>()(NoParams());
    router.replaceAll([const LoginRoute()]);
  }
}

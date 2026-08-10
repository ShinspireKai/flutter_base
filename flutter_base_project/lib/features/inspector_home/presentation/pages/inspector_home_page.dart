import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspection_app/core/gen/colors.gen.dart';
import 'package:inspection_app/core/router/auto_route_config.dart';
import 'package:inspection_app/testing/test_keys.dart';

import '../../../../../mvp/BaseView.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../maintenance/presentation/bloc/pending_recheck_bloc.dart';
import '../../maintenance/presentation/bloc/pending_recheck_event.dart';
import '../../maintenance/presentation/bloc/pending_recheck_state.dart';
import '../bloc/inspector_home_bloc.dart';
import '../bloc/inspector_home_event.dart';
import '../bloc/inspector_home_state.dart';
import '../widgets/inspector_profile_card.dart';
import '../widgets/app_drawer.dart';
import '../mvp/inspector_home_presenter.dart';
import '../mvp/i_inspector_home_view.dart';

// ─────────────────────────────────────────────────────────────────────────────
// InspectorHomePage — BaseView (MVP View) cho 巡檢人員 (Inspector)
// ─────────────────────────────────────────────────────────────────────────────
//
// Phân công rõ ràng:
//   • Presenter → NAVIGATION, dialog confirm, snackbar
//   • BLoC      → DATA STATE (loading, profile data, error message)
//   • View      → chỉ render UI và forward action lên Presenter
// ─────────────────────────────────────────────────────────────────────────────

@RoutePage()
class InspectorHomePage extends BaseView {
  const InspectorHomePage({super.key});

  @override
  State<InspectorHomePage> createState() => _InspectorHomePageState();
}

class _InspectorHomePageState
    extends BaseViewState<InspectorHomePresenter, InspectorHomePage>
    implements IInspectorHomeView {
  // ─── MVP ──────────────────────────────────────────────────────────────────

  @override
  InspectorHomePresenter createPresenter() => InspectorHomePresenter();

  /// Load profile ngay sau frame đầu tiên
  @override
  void afterInit() {
    presenter?.loadProfile(context.read<InspectorHomeBloc>());
    context.read<PendingRecheckBloc>().add(const PendingRecheckLoadTasks());
    presenter?.checkFcmToken();
  }

  // ─── IInspectorHomeView implementation ────────────────────────────────────

  @override
  void navigateToLogin() {
    context.router.replaceNamed('/login');
  }

  @override
  void navigateToTodayInspection() {
    context.router.replace(const TodayInspectionRoute());
  }

  @override
  void navigateToMaintenanceTasks() {
    context.router.replace(const MaintenanceTaskRoute());
  }

  @override
  void navigateToPendingRecheck() {
    context.router.replace(const PendingRecheckRoute());
  }

  @override
  void showLogoutConfirmDialog({required VoidCallback onConfirm}) {
    final l10n = AppLocalizations.of(context)!;
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
            onPressed: () {
              Navigator.pop(dialogCtx);
              onConfirm();
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

  @override
  void showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  @override
  void showFcmTokenSnackbar(String token) {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.token_outlined, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.fcmTokenSnackbarMessage(token),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.blueGrey.shade700,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          action: SnackBarAction(
            label: l10n.copyButtonLabel,
            textColor: Colors.white,
            onPressed: () {
              Clipboard.setData(ClipboardData(text: token));
              showToast(l10n.fcmTokenCopiedToast);
            },
          ),
        ),
      );
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget buildView(BuildContext context) {
    return BlocListener<InspectorHomeBloc, InspectorHomeState>(
      listener: (ctx, state) {
        // Presenter là coordinator — ra lệnh cho View dựa trên BLoC state
        if (state is InspectorHomeLoggedOut) {
          presenter?.onLoggedOut();
        }
        if (state is InspectorHomeError) {
          presenter?.onError(state.message);
        }
      },
      child: Scaffold(
        key: TestKeys.inspectorHomePageScaffold,
        appBar: _buildAppBar(),
        body: BlocBuilder<InspectorHomeBloc, InspectorHomeState>(
          builder: (context, state) {
            if (state is InspectorHomeLoading ||
                state is InspectorHomeInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is InspectorHomeLoggingOut) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(AppLocalizations.of(context)!.loggingOut),
                  ],
                ),
              );
            }
            if (state is InspectorHomeError) {
              return _buildErrorView(state.message);
            }
            if (state is InspectorHomeLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  // Forward lên Presenter — không gọi BLoC trực tiếp từ View
                  presenter?.refresh(context.read<InspectorHomeBloc>());
                  await Future.delayed(const Duration(milliseconds: 1200));
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.selectFeatureHint,
                              style: TextStyle(
                                fontSize: 15,
                                color: ColorName.colorTextGrey,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildItemDashboard(
                              icon: '📋',
                              label: AppLocalizations.of(
                                context,
                              )!.todayInspectionLabel,
                              role: AppLocalizations.of(context)!.roleInspector,
                              onTap: () => presenter?.onTodayInspectionTapped(),
                            ),
                            const SizedBox(height: 12),
                            _buildItemDashboard(
                              icon: '🔧',
                              label: AppLocalizations.of(
                                context,
                              )!.myRepairTasksLabel,
                              role: AppLocalizations.of(
                                context,
                              )!.roleTechnician,
                              onTap: () =>
                                  presenter?.onMyMaintenanceTasksTapped(),
                            ),
                            const SizedBox(height: 12),
                            BlocBuilder<PendingRecheckBloc, PendingRecheckState>(
                              builder: (context, recheckState) {
                                final count = recheckState is PendingRecheckLoaded
                                    ? recheckState.tasks.length
                                    : 0;
                                return _buildItemDashboard(
                                  icon: '🔍',
                                  label:
                                      '${AppLocalizations.of(context)!.pendingRecheckLabel} ',
                                  role: AppLocalizations.of(context)!.roleInspector,
                                  isPendingReinspection: true,
                                  pendingRecheckCount: count,
                                  onTap: () =>
                                      presenter?.onPendingRecheckTapped(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildItemDashboard({
    required String icon,
    required String label,
    required String role,
    bool? isPendingReinspection,
    int pendingRecheckCount = 0,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        height: 122,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          border: BoxBorder.all(color: ColorName.borderOutline, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 6),
            isPendingReinspection ?? false
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        label,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: ColorName.greenPrimary,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: ColorName.colorTextOrgan.withAlpha(
                            (0.1 * 255).toInt(),
                          ),
                        ),
                        child: Text(
                          '$pendingRecheckCount',
                          style: TextStyle(color: ColorName.colorTextOrgan),
                        ),
                      ),
                    ],
                  )
                : Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: ColorName.greenPrimary,
                    ),
                  ),
            Text(
              role,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11, color: ColorName.greenPrimary),
            ),
          ],
        ),
      ),
    );
  }

  // ─── AppBar ───────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: BlocBuilder<InspectorHomeBloc, InspectorHomeState>(
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.appTagline,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          );
        },
      ),
      actions: [
        // TODO: '林先生' là tên placeholder — cần lấy tên user thực từ profile.
        const Text('林先生', style: TextStyle(color: Colors.white)),
        const SizedBox(width: 16),
      ],
    );
  }

  // ─── Widgets ──────────────────────────────────────────────────────────────

  Widget _buildErrorView(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 52,
                color: Colors.red.shade400,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.errorOccurredTitle,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).primaryColorDark,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              // Forward lên Presenter
              onPressed: () =>
                  presenter?.loadProfile(context.read<InspectorHomeBloc>()),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(AppLocalizations.of(context)!.retryButton),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

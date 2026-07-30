import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspection_app/core/gen/colors.gen.dart';
import 'package:inspection_app/core/router/auto_route_config.dart';
import 'package:inspection_app/util/widgets/common_app_bar.dart';

import '../../../../../mvp/BaseView.dart';
import '../../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/maintenance_task_entity.dart';
import '../bloc/maintenance_task_bloc.dart';
import '../bloc/maintenance_task_event.dart';
import '../bloc/maintenance_task_state.dart';
import '../widgets/maintenance_task_card.dart';
import '../../../presentation/widgets/app_drawer.dart';
import '../mvp/maintenance_task_presenter.dart';
import '../mvp/i_maintenance_task_view.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MaintenanceTaskPage — BaseView (MVP View) cho trang「我的維修任務」của 維修人員 (Technician)
// Trang con của InspectorHome, điều hướng tới từ mục "我的維修任務" trên Home
// ─────────────────────────────────────────────────────────────────────────────

@RoutePage()
class MaintenanceTaskPage extends BaseView {
  const MaintenanceTaskPage({super.key});

  @override
  State<MaintenanceTaskPage> createState() => _MaintenanceTaskPageState();
}

class _MaintenanceTaskPageState
    extends BaseViewState<MaintenanceTaskPresenter, MaintenanceTaskPage>
    implements IMaintenanceTaskView {
  // ─── MVP ──────────────────────────────────────────────────────────────────

  @override
  MaintenanceTaskPresenter createPresenter() => MaintenanceTaskPresenter();

  @override
  void afterInit() {
    presenter?.loadTasks(context.read<MaintenanceTaskBloc>());
  }

  // ─── IMaintenanceTaskView implementation ──────────────────────────────────

  @override
  void navigateToReport(MaintenanceTaskEntity task) async {
    final PageRouteInfo route = task.reworkRound > 0
        ? MaintenanceReworkRoute(task: task)
        : MaintenanceReportRoute(task: task);
    await context.router.push(route);
    if (!mounted) return;
    context.read<MaintenanceTaskBloc>().add(const MaintenanceTaskRefreshed());
  }

  @override
  void showTaskAlreadyCompletedNotice() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.taskAlreadyCompletedNotice)),
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

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget buildView(BuildContext context) {
    return BlocListener<MaintenanceTaskBloc, MaintenanceTaskState>(
      listener: (ctx, state) {
        if (state is MaintenanceTaskError) {
          presenter?.onError(state.message);
        }
      },
      child: Scaffold(
        appBar: CommonAppBar(
          title: AppLocalizations.of(context)!.myRepairTasksLabel,
        ),
        drawer: const AppDrawer(),
        body: BlocBuilder<MaintenanceTaskBloc, MaintenanceTaskState>(
          builder: (context, state) {
            if (state is MaintenanceTaskLoading ||
                state is MaintenanceTaskInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is MaintenanceTaskError) {
              return _buildErrorView(state.message);
            }
            if (state is MaintenanceTaskLoaded) {
              return _buildLoadedView(state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildLoadedView(MaintenanceTaskLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        presenter?.refresh(context.read<MaintenanceTaskBloc>());
        await Future.delayed(const Duration(milliseconds: 1200));
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  // TODO: '王師傅' là tên placeholder — cần lấy tên user thực từ profile.
                  AppLocalizations.of(context)!.maintenanceAssignedToMe('王師傅'),
                  style: TextStyle(
                    fontSize: 16,
                    color: ColorName.colorTextGrey,
                  ),
                ),
                const SizedBox(height: 16),
                if (state.tasks.isEmpty)
                  _buildEmptyView()
                else
                  ...state.tasks.map(
                    (task) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => presenter?.onTaskTapped(task),
                        child: MaintenanceTaskCard(task: task),
                      ),
                    ),
                  ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.build_rounded, size: 48, color: ColorName.colorTextGrey),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.noMaintenanceTasks,
              style: TextStyle(color: ColorName.colorTextGrey),
            ),
          ],
        ),
      ),
    );
  }

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
              onPressed: () =>
                  presenter?.loadTasks(context.read<MaintenanceTaskBloc>()),
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

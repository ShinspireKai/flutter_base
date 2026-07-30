import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspection_app/core/gen/colors.gen.dart';
import 'package:inspection_app/core/router/auto_route_config.dart';
import 'package:inspection_app/util/widgets/common_app_bar.dart';

import '../../../../../mvp/BaseView.dart';
import '../../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/maintenance_task_entity.dart';
import '../bloc/pending_recheck_bloc.dart';
import '../bloc/pending_recheck_event.dart';
import '../bloc/pending_recheck_state.dart';
import '../widgets/pending_recheck_card.dart';
import '../../../presentation/widgets/app_drawer.dart';
import '../mvp/pending_recheck_presenter.dart';
import '../mvp/i_pending_recheck_view.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PendingRecheckPage — BaseView (MVP View) cho trang「待我複檢」(C1) của
// 巡檢人員 (Inspector, vai trò người phúc kiểm). Trang con của InspectorHome,
// điều hướng tới từ mục "待複檢" trên Home/Drawer.
// ─────────────────────────────────────────────────────────────────────────────

@RoutePage()
class PendingRecheckPage extends BaseView {
  const PendingRecheckPage({super.key});

  @override
  State<PendingRecheckPage> createState() => _PendingRecheckPageState();
}

class _PendingRecheckPageState
    extends BaseViewState<PendingRecheckPresenter, PendingRecheckPage>
    implements IPendingRecheckView {
  // ─── MVP ──────────────────────────────────────────────────────────────────

  @override
  PendingRecheckPresenter createPresenter() => PendingRecheckPresenter();

  @override
  void afterInit() {
    presenter?.loadTasks(context.read<PendingRecheckBloc>());
  }

  // ─── IPendingRecheckView implementation ───────────────────────────────────

  @override
  void navigateToRecheckDecision(MaintenanceTaskEntity task) async {
    await context.router.push(RecheckDecisionRoute(task: task));
    if (!mounted) return;
    context.read<PendingRecheckBloc>().add(const PendingRecheckRefreshed());
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
    return BlocListener<PendingRecheckBloc, PendingRecheckState>(
      listener: (ctx, state) {
        if (state is PendingRecheckError) {
          presenter?.onError(state.message);
        }
      },
      child: Scaffold(
        appBar: CommonAppBar(
          title: AppLocalizations.of(context)!.pendingRecheckListTitle,
        ),
        drawer: const AppDrawer(),
        body: BlocBuilder<PendingRecheckBloc, PendingRecheckState>(
          builder: (context, state) {
            if (state is PendingRecheckLoading ||
                state is PendingRecheckInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is PendingRecheckError) {
              return _buildErrorView(state.message);
            }
            if (state is PendingRecheckLoaded) {
              return _buildLoadedView(state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildLoadedView(PendingRecheckLoaded state) {
    final l10n = AppLocalizations.of(context)!;
    return RefreshIndicator(
      onRefresh: () async {
        presenter?.refresh(context.read<PendingRecheckBloc>());
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
                  // TODO: '林先生' là tên placeholder — cần lấy tên user thực từ profile.
                  l10n.pendingRecheckSubtitle('林先生'),
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
                        child: PendingRecheckCard(task: task),
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
            Icon(Icons.task_alt_rounded, size: 48, color: ColorName.colorTextGrey),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.noPendingRecheckTasks,
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
                  presenter?.loadTasks(context.read<PendingRecheckBloc>()),
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

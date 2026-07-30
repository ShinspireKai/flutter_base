import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspection_app/core/gen/colors.gen.dart';
import 'package:inspection_app/core/router/auto_route_config.dart';

import '../../../../../../mvp/BaseView.dart';
import '../../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/inspection_task_entity.dart';
import '../bloc/today_inspection_bloc.dart';
import '../bloc/today_inspection_state.dart';
import '../widgets/inspection_task_card.dart';
import '../../../presentation/widgets/app_drawer.dart';
import '../mvp/today_inspection_presenter.dart';
import '../mvp/i_today_inspection_view.dart';
import '../../../../../../util/date_formatter.dart';

// ─────────────────────────────────────────────────────────────────────────────
// TodayInspectionPage — BaseView (MVP View) cho trang「今日巡檢」của 巡檢人員 (Inspector)
// Trang con của InspectorHome, điều hướng tới từ mục "今日巡檢" trên Home
// ─────────────────────────────────────────────────────────────────────────────

@RoutePage()
class TodayInspectionPage extends BaseView {
  const TodayInspectionPage({super.key});

  @override
  State<TodayInspectionPage> createState() => _TodayInspectionPageState();
}

class _TodayInspectionPageState
    extends BaseViewState<TodayInspectionPresenter, TodayInspectionPage>
    implements ITodayInspectionView {
  // ─── MVP ──────────────────────────────────────────────────────────────────

  @override
  TodayInspectionPresenter createPresenter() => TodayInspectionPresenter();

  @override
  void afterInit() {
    presenter?.loadTasks(context.read<TodayInspectionBloc>());
  }

  // ─── ITodayInspectionView implementation ──────────────────────────────────

  @override
  void navigateToEquipmentInspection(InspectionTaskEntity task) {
    context.router.push(
      EquipmentInspectionRoute(
        routeId: task.id,
        initialTitle: task.name,
        initialLocation: task.location,
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

  // ─── AppBar ───────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      title: BlocBuilder<TodayInspectionBloc, TodayInspectionState>(
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.todayInspectionLabel,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          );
        },
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget buildView(BuildContext context) {
    return BlocListener<TodayInspectionBloc, TodayInspectionState>(
      listener: (ctx, state) {
        if (state is TodayInspectionError) {
          presenter?.onError(state.message);
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        drawer: const AppDrawer(),
        body: BlocBuilder<TodayInspectionBloc, TodayInspectionState>(
          builder: (context, state) {
            if (state is TodayInspectionLoading ||
                state is TodayInspectionInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is TodayInspectionError) {
              return _buildErrorView(state.message);
            }
            if (state is TodayInspectionLoaded) {
              return _buildLoadedView(state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildLoadedView(TodayInspectionLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        presenter?.refresh(context.read<TodayInspectionBloc>());
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
                  '${DateFormatter.today(context)} · ${AppLocalizations.of(context)!.inspectorLabelWithName('林先生')}',
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
                        child: InspectionTaskCard(task: task),
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
            Icon(
              Icons.checklist_rtl_rounded,
              size: 48,
              color: ColorName.colorTextGrey,
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.noInspectionItemsToday,
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
                  presenter?.loadTasks(context.read<TodayInspectionBloc>()),
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

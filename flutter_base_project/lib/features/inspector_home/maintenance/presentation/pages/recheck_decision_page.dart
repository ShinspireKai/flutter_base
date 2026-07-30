import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspection_app/core/di.dart';
import 'package:inspection_app/core/gen/colors.gen.dart';
import 'package:inspection_app/util/widgets/common_app_bar.dart';
import 'package:inspection_app/util/widgets/custom_text_field.dart';

import '../../../../../mvp/BaseView.dart';
import '../../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/maintenance_task_entity.dart';
import '../../domain/usecases/update_maintenance_task_usecase.dart';
import '../bloc/recheck_decision_bloc.dart';
import '../bloc/recheck_decision_event.dart';
import '../bloc/recheck_decision_state.dart';
import '../mvp/recheck_decision_presenter.dart';
import '../mvp/i_recheck_decision_view.dart';

// ─────────────────────────────────────────────────────────────────────────────
// RecheckDecisionPage — BaseView (MVP View) cho「異常複檢」(C2)
// Cổng kiểm soát chất lượng (QC gate) duy nhất: người phúc kiểm xem lại toàn
// bộ thông tin sự cố gốc + xử lý của thợ sửa, chọn 通過/不通過 rồi送出複檢.
// ─────────────────────────────────────────────────────────────────────────────

@RoutePage()
class RecheckDecisionPage extends BaseView {
  final MaintenanceTaskEntity task;

  const RecheckDecisionPage({super.key, required this.task});

  @override
  State<RecheckDecisionPage> createState() => _RecheckDecisionPageState();
}

class _RecheckDecisionPageState
    extends BaseViewState<RecheckDecisionPresenter, RecheckDecisionPage>
    implements IRecheckDecisionView {
  late final RecheckDecisionBloc _bloc = RecheckDecisionBloc(
    initialTask: widget.task,
    updateMaintenanceTaskUseCase: sl<UpdateMaintenanceTaskUseCase>(),
  );
  late final TextEditingController _noteController = TextEditingController();

  // ─── MVP ──────────────────────────────────────────────────────────────────

  @override
  RecheckDecisionPresenter createPresenter() => RecheckDecisionPresenter();

  @override
  void dispose() {
    _bloc.close();
    _noteController.dispose();
    super.dispose();
  }

  // ─── IRecheckDecisionView implementation ──────────────────────────────────

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
  void showRecheckNoteRequiredWarning() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.recheckNoteRequiredWarning,
          ),
          backgroundColor: Colors.orange.shade700,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  @override
  void showSubmitCompletedToast({required bool approved}) {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            approved ? l10n.recheckApprovedToast : l10n.recheckRejectedToast,
          ),
          backgroundColor: approved
              ? ColorName.greenCheckBg
              : ColorName.redDanger,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  @override
  void navigateBackToList() {
    Navigator.of(context).pop();
  }

  // ─── Photo viewer ──────────────────────────────────────────────────────────

  void _showCompletionPhotos(List<String> paths) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.completionPhotosLabel,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final path in paths)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(path),
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 80,
                          height: 80,
                          color: ColorName.borderOutline,
                          child: Icon(
                            Icons.image_rounded,
                            color: ColorName.colorTextGrey,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget buildView(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider.value(
      value: _bloc,
      child: BlocListener<RecheckDecisionBloc, RecheckDecisionState>(
        listener: (ctx, state) {
          if (state is RecheckDecisionError) {
            presenter?.onError(state.message);
          }
          if (state is RecheckDecisionSubmitCompleted) {
            presenter?.onSubmitCompleted(state.result);
          }
        },
        child: BlocBuilder<RecheckDecisionBloc, RecheckDecisionState>(
          builder: (context, state) {
            final loaded = state is RecheckDecisionLoaded ? state : null;
            final task = loaded?.task ?? widget.task;
            final result = loaded?.result ?? RecheckResult.approved;
            final isSubmitting = loaded?.isSubmitting ?? false;

            return Scaffold(
              appBar: CommonAppBar(title: l10n.recheckDecisionTitle),
              body: SafeArea(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCategoryRow(task),
                        const SizedBox(height: 8),
                        Text(
                          task.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.currentStatusLabel,
                              style: TextStyle(
                                fontSize: 16,
                                color: ColorName.colorTextGrey,
                              ),
                            ),
                            _buildStatusPill(l10n),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildSummaryTable(l10n, task),
                        const SizedBox(height: 24),
                        _buildResultToggle(l10n, result),
                        const SizedBox(height: 20),
                        _buildNoteField(l10n),
                        const SizedBox(height: 24),
                        _buildSubmitButton(l10n, task, result, isSubmitting),
                        const SizedBox(height: 16),
                        _buildRuleFootnote(l10n),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ─── Header row ─────────────────────────────────────────────────────────────

  Widget _buildCategoryRow(MaintenanceTaskEntity task) {
    final category = task.category;
    return Row(
      children: [
        Expanded(
          child: Text(
            '${_priorityColorFor(task.priority)} ${task.location}'
            '${category != null ? ' $category' : ''}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 16, color: ColorName.colorTextGrey),
          ),
        ),
      ],
    );
  }

  String _priorityColorFor(MaintenanceTaskPriority priority) {
    switch (priority) {
      case MaintenanceTaskPriority.high:
        return '🔴';
      case MaintenanceTaskPriority.medium:
        return '🟡';
      case MaintenanceTaskPriority.low:
        return '⚪';
    }
  }

  Widget _buildStatusPill(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: ColorName.colorTextOrgan.withAlpha((0.1 * 255).toInt()),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        l10n.maintenanceStatusPendingRecheck,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: ColorName.colorTextOrgan,
        ),
      ),
    );
  }

  // ─── Summary table ──────────────────────────────────────────────────────────

  Widget _buildSummaryTable(AppLocalizations l10n, MaintenanceTaskEntity task) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: ColorName.bgInforBox,
        border: Border.all(color: ColorName.borderOutline),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            l10n.reportDescriptionLabel,
            task.reportDescription ?? '',
            valueColor: ColorName.redDanger,
          ),

          // TODO: '王師傅' là tên placeholder — cần lấy tên user thực từ hồ sơ nhiệm vụ.
          _buildSummaryRow(l10n.repairedByLabel, '王師傅'),

          _buildSummaryRow(l10n.completionNoteLabel, task.completionNote ?? ''),
          if (task.completionPhotoPaths.isNotEmpty) ...[
            _buildSummaryLinkRow(
              l10n.completionPhotosLabel,
              l10n.recheckViewPhotosLink,
              onTap: () => _showCompletionPhotos(task.completionPhotoPaths),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: TextStyle(fontSize: 16, color: ColorName.colorTextGrey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryLinkRow(
    String label,
    String linkText, {
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: ColorName.colorTextGrey),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: onTap,
                child: Text(
                  '📷 $linkText',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ColorName.bluePrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Result toggle ──────────────────────────────────────────────────────────

  Widget _buildResultToggle(AppLocalizations l10n, RecheckResult result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.recheckResultSectionTitle,
          style: TextStyle(fontSize: 15, color: ColorName.colorTextGrey),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildResultOption(
                label: '✓ ${l10n.recheckApproveButton}',
                isSelected: result == RecheckResult.approved,
                selectedColor: ColorName.greenCheckBg,
                onTap: () =>
                    presenter?.onResultChanged(_bloc, RecheckResult.approved),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildResultOption(
                label: '✗ ${l10n.recheckRejectButton}',
                isSelected: result == RecheckResult.rejected,
                selectedColor: ColorName.redDanger,
                onTap: () =>
                    presenter?.onResultChanged(_bloc, RecheckResult.rejected),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResultOption({
    required String label,
    required bool isSelected,
    required Color selectedColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : Colors.transparent,
          border: Border.all(
            color: isSelected ? selectedColor : ColorName.borderOutline,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : ColorName.colorTextGrey,
          ),
        ),
      ),
    );
  }

  // ─── Note field ─────────────────────────────────────────────────────────────

  Widget _buildNoteField(AppLocalizations l10n) {
    return CustomTextField(
      controller: _noteController,
      labelText: l10n.recheckNoteLabel,
      labelTextStyle: TextStyle(fontSize: 15, color: ColorName.colorTextGrey),
      hintText: l10n.recheckNoteHint,
      maxLines: 3,
      onChanged: (value) => presenter?.onNoteChanged(_bloc, value),
    );
  }

  // ─── Submit ─────────────────────────────────────────────────────────────────

  Widget _buildSubmitButton(
    AppLocalizations l10n,
    MaintenanceTaskEntity task,
    RecheckResult result,
    bool isSubmitting,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: isSubmitting
            ? null
            : () => presenter?.onSubmitPressed(_bloc, _noteController.text),
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorName.greenCheckBg,
          foregroundColor: Colors.white,
          disabledBackgroundColor: ColorName.greenCheckBg.withValues(
            alpha: 0.4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isSubmitting
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: Colors.white,
                ),
              )
            : Text(
                l10n.submitRecheckButton,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }

  Widget _buildRuleFootnote(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.recheckRuleApprovedNote,
          style: TextStyle(fontSize: 12, color: ColorName.colorTextGrey),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.recheckRuleRejectedNote,
          style: TextStyle(fontSize: 12, color: ColorName.colorTextGrey),
        ),
      ],
    );
  }
}

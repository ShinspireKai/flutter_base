import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspection_app/core/di.dart';
import 'package:inspection_app/core/gen/colors.gen.dart';
import 'package:inspection_app/core/services/photo_capture_service.dart';
import 'package:inspection_app/util/widgets/common_app_bar.dart';
import 'package:inspection_app/util/widgets/custom_text_field.dart';

import '../../../../../mvp/BaseView.dart';
import '../../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/maintenance_task_entity.dart';
import '../../domain/usecases/update_maintenance_task_usecase.dart';
import '../bloc/maintenance_report_bloc.dart';
import '../bloc/maintenance_report_state.dart';
import '../mvp/maintenance_report_presenter.dart';
import '../mvp/i_maintenance_report_view.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MaintenanceReworkPage — BaseView (MVP View) cho「再維修」(R3)
//
// Màn hình riêng cho vòng lặp 再維修 sau khi 複檢不通過 (task.reworkRound > 0)
// — tách khỏi MaintenanceReportPage (chỉ còn phục vụ R2「維修回報」lần đầu).
// Dùng lại MaintenanceReportBloc/Presenter/View interface vì nghiệp vụ
// (chỉnh 完工說明/完工照片, 更新進度, 送出複檢) giống hệt R2 — chỉ khác cách
// hiển thị (tiêu đề, lý do trả về, nhãn nút).
// ─────────────────────────────────────────────────────────────────────────────

@RoutePage()
class MaintenanceReworkPage extends BaseView {
  final MaintenanceTaskEntity task;

  const MaintenanceReworkPage({super.key, required this.task});

  @override
  State<MaintenanceReworkPage> createState() => _MaintenanceReworkPageState();
}

class _MaintenanceReworkPageState
    extends BaseViewState<MaintenanceReportPresenter, MaintenanceReworkPage>
    implements IMaintenanceReportView {
  late final MaintenanceReportBloc _bloc = MaintenanceReportBloc(
    initialTask: widget.task,
    updateMaintenanceTaskUseCase: sl<UpdateMaintenanceTaskUseCase>(),
    photoCaptureService: sl<PhotoCaptureService>(),
  );
  late final TextEditingController _noteController = TextEditingController(
    text: widget.task.completionNote ?? '',
  );

  // ─── MVP ──────────────────────────────────────────────────────────────────

  @override
  MaintenanceReportPresenter createPresenter() => MaintenanceReportPresenter();

  @override
  void dispose() {
    _bloc.close();
    _noteController.dispose();
    super.dispose();
  }

  // ─── IMaintenanceReportView implementation ────────────────────────────────

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
  void showPhotoSourcePicker({
    required void Function(bool fromCamera) onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.camera_alt_rounded,
                color: ColorName.bluePrimary,
              ),
              title: Text(AppLocalizations.of(context)!.takePhoto),
              onTap: () {
                Navigator.pop(sheetCtx);
                onSelected(true);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.photo_library_rounded,
                color: ColorName.bluePrimary,
              ),
              title: Text(AppLocalizations.of(context)!.chooseFromGallery),
              onTap: () {
                Navigator.pop(sheetCtx);
                onSelected(false);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  void showCompletionNoteRequiredWarning() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.completionNoteRequiredWarning,
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
  void showProgressSavedToast() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.progressSavedToast),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  @override
  void showSentForRecheckToast() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.sentForRecheckToast),
          backgroundColor: ColorName.greenPrimary,
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

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget buildView(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocListener<MaintenanceReportBloc, MaintenanceReportState>(
        listener: (ctx, state) {
          if (state is MaintenanceReportError) {
            presenter?.onError(state.message);
          }
          if (state is MaintenanceReportProgressSaved) {
            presenter?.onProgressSaved();
          }
          if (state is MaintenanceReportSentForRecheck) {
            presenter?.onSentForRecheck();
          }
        },
        child: BlocBuilder<MaintenanceReportBloc, MaintenanceReportState>(
          builder: (context, state) {
            final task = state is MaintenanceReportLoaded
                ? state.task
                : widget.task;
            final isSubmitting = state is MaintenanceReportLoaded
                ? state.isSubmitting
                : false;

            return Scaffold(
              appBar: CommonAppBar(title: _titleFor(task)),
              body: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => FocusScope.of(context).unfocus(),
                child: SafeArea(
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
                              style: const TextStyle(
                                fontSize: 20,
                                color: ColorName.colorTextGrey,
                              ),
                            ),
                            _buildStatusPill(),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildRejectionSection(task),
                        const SizedBox(height: 20),
                        _buildCompletionNoteField(),
                        const SizedBox(height: 20),
                        _buildCompletionPhotosSection(task),
                        const SizedBox(height: 28),
                        _buildActionButtons(task, isSubmitting),
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

  // ─── Header ───────────────────────────────────────────────────────────────

  String _titleFor(MaintenanceTaskEntity task) {
    final l10n = AppLocalizations.of(context)!;
    if (task.ticketNo != null) {
      return l10n.contractorReportTitle(task.ticketNo!);
    }
    return l10n.maintenanceReworkTitle;
  }

  Widget _buildCategoryRow(MaintenanceTaskEntity task) {
    final l10n = AppLocalizations.of(context)!;
    final category = task.category;
    return Row(
      children: [
        Expanded(
          child: Text(
            '${_priorityColorFor(task.priority)} ${l10n.abnormalLabel} · ${task.location}'
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

  Widget _buildStatusPill() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: ColorName.bluePrimary.withAlpha((0.1 * 255).toInt()),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        l10n.maintenanceStatusReworking,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: ColorName.bluePrimary,
        ),
      ),
    );
  }

  // ─── Rejection reason section ───────────────────────────────────────────────

  Widget _buildRejectionSection(MaintenanceTaskEntity task) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.rejectionReasonSectionTitle,
          style: TextStyle(fontSize: 15, color: ColorName.colorTextGrey),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.08),
            border: Border.all(color: ColorName.redDanger),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '${task.rejectionReason ?? ''}'
            '${task.rejectionReviewer != null && task.rejectionAt != null ? l10n.rejectionReasonSuffix(task.rejectionReviewer!, _formatDateTime(task.rejectionAt!)) : ''}',
            style: TextStyle(fontSize: 14, color: ColorName.redDanger),
          ),
        ),
      ],
    );
  }

  // ─── Completion note ────────────────────────────────────────────────────────

  Widget _buildCompletionNoteField() {
    final l10n = AppLocalizations.of(context)!;
    return CustomTextField(
      controller: _noteController,
      labelText: l10n.completionNoteLabelRework,
      labelTextStyle: TextStyle(fontSize: 15, color: ColorName.colorTextGrey),
      hintText: l10n.completionNoteHintRework,
      maxLines: 4,
      onChanged: (value) => presenter?.onCompletionNoteChanged(_bloc, value),
    );
  }

  // ─── Completion photos ──────────────────────────────────────────────────────

  Widget _buildCompletionPhotosSection(MaintenanceTaskEntity task) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.completionPhotosLabel,
          style: TextStyle(fontSize: 15, color: ColorName.colorTextGrey),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final path in task.completionPhotoPaths)
              _buildPhotoThumbnail(path),
            _buildAddPhotoTile(),
          ],
        ),
      ],
    );
  }

  Widget _buildPhotoThumbnail(String path) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Image.file(
        File(path),
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: 80,
          height: 80,
          color: ColorName.borderOutline,
          child: Icon(Icons.image_rounded, color: ColorName.colorTextGrey),
        ),
      ),
    );
  }

  Widget _buildAddPhotoTile() {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => presenter?.onAddPhotoTapped(_bloc),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: ColorName.bgAddPhoto,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.add_rounded,
          color: ColorName.colorTextGrey,
          size: 28,
        ),
      ),
    );
  }

  // ─── Action buttons ─────────────────────────────────────────────────────────

  Widget _buildActionButtons(MaintenanceTaskEntity task, bool isSubmitting) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: isSubmitting
                ? null
                : () => presenter?.onProgressUpdatePressed(_bloc),
            style: OutlinedButton.styleFrom(
              foregroundColor: ColorName.bluePrimary,
              side: BorderSide(color: ColorName.bluePrimary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              l10n.updateProgressButton,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: isSubmitting
                ? null
                : () => presenter?.onSubmitPressed(_bloc, task),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorName.colorTextOrgan,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.orange.shade200,
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
                    l10n.completeSendRecheckAgainButton,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime date) {
    final hh = date.hour.toString().padLeft(2, '0');
    final mm = date.minute.toString().padLeft(2, '0');
    return '${date.month}/${date.day} $hh:$mm';
  }
}

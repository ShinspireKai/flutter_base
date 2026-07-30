import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspection_app/core/di.dart';
import 'package:inspection_app/core/gen/colors.gen.dart';
import 'package:inspection_app/core/router/auto_route_config.dart';
import 'package:inspection_app/core/services/photo_capture_service.dart';

import '../../../../../../mvp/BaseView.dart';
import '../../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/inspection_route_entity.dart';
import '../../domain/usecases/get_equipment_inspection_checklist_usecase.dart';
import '../../domain/usecases/submit_inspection_report_usecase.dart';
import '../bloc/equipment_inspection_bloc.dart';
import '../bloc/equipment_inspection_state.dart';
import '../widgets/checklist_item_card.dart';
import '../widgets/checklist_progress_bar.dart';
import '../mvp/equipment_inspection_presenter.dart';
import '../mvp/i_equipment_inspection_view.dart';

// ─────────────────────────────────────────────────────────────────────────────
// EquipmentInspectionPage — BaseView (MVP View) cho màn hình「B1 設備巡檢」
// Trang con của InspectorHome, bước tiếp theo sau khi chọn 1 hạng mục
// trong「今日巡檢」
// ─────────────────────────────────────────────────────────────────────────────

@RoutePage()
class EquipmentInspectionPage extends BaseView {
  final String routeId;
  final String initialTitle;
  final String initialLocation;

  const EquipmentInspectionPage({
    super.key,
    required this.routeId,
    required this.initialTitle,
    required this.initialLocation,
  });

  @override
  State<EquipmentInspectionPage> createState() =>
      _EquipmentInspectionPageState();
}

class _EquipmentInspectionPageState
    extends BaseViewState<EquipmentInspectionPresenter, EquipmentInspectionPage>
    implements IEquipmentInspectionView {
  late final EquipmentInspectionBloc _bloc = EquipmentInspectionBloc(
    getChecklistUseCase: sl<GetEquipmentInspectionChecklistUseCase>(),
    submitReportUseCase: sl<SubmitInspectionReportUseCase>(),
    photoCaptureService: sl<PhotoCaptureService>(),
  );

  // ─── MVP ──────────────────────────────────────────────────────────────────

  @override
  EquipmentInspectionPresenter createPresenter() =>
      EquipmentInspectionPresenter();

  @override
  void afterInit() {
    presenter?.loadChecklist(_bloc, widget.routeId);
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  // ─── IEquipmentInspectionView implementation ──────────────────────────────

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
  void showNoteDialog({
    required String? initialNote,
    required void Function(String note) onSubmit,
  }) {
    final controller = TextEditingController(text: initialNote ?? '');
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.noteDialogTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: l10n.noteHint,
            border: const OutlineInputBorder(),
          ),
        ),
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
              onSubmit(controller.text.trim());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(l10n.save),
          ),
        ],
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
  void showIncompleteChecklistWarning(int remainingCount) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.incompleteChecklistWarning(remainingCount),
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
  void navigateToPhotoRecord(EquipmentInspectionBloc bloc, String itemId) {
    context.router.push(PhotoRecordRoute(bloc: bloc, itemId: itemId));
  }

  @override
  void navigateToSignatureConfirmation(EquipmentInspectionBloc bloc) {
    context.router.push(SignatureConfirmationRoute(bloc: bloc));
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget buildView(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocListener<EquipmentInspectionBloc, EquipmentInspectionState>(
        listener: (ctx, state) {
          if (state is EquipmentInspectionError) {
            presenter?.onError(state.message);
          }
          // EquipmentInspectionSubmitSuccess chỉ được kích hoạt từ màn hình
          // 「簽名確認」— trang đó tự điều hướng quay về, không xử lý ở đây
          // để tránh pop 2 lần trên cùng một Navigator.
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.initialTitle,
              style: const TextStyle(color: Colors.white),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: BlocBuilder<EquipmentInspectionBloc, EquipmentInspectionState>(
            builder: (context, state) {
              if (state is EquipmentInspectionLoading ||
                  state is EquipmentInspectionInitial) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is EquipmentInspectionError) {
                return _buildErrorView(state.message);
              }
              if (state is EquipmentInspectionLoaded) {
                return _buildLoadedView(state);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoadedView(EquipmentInspectionLoaded state) {
    final route = state.route;
    return Column(
      children: [
        _buildProcessBar(route),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            itemCount: route.items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = route.items[index];
              return ChecklistItemCard(
                item: item,
                onStatusSelected: (status) =>
                    presenter?.onItemStatusSelected(_bloc, item.id, status),
                onSeveritySelected: (severity) =>
                    presenter?.onSeveritySelected(_bloc, item.id, severity),
                onNoteTap: () => presenter?.onNoteTapped(_bloc, item),
                onCapturePhotoTap: () =>
                    presenter?.onCapturePhotoTapped(_bloc, item),
                onOpenPhotoRecord: () =>
                    presenter?.onOpenPhotoRecordTapped(_bloc, item.id),
              );
            },
          ),
        ),
        _buildSubmitBar(route, isSubmitting: state.isSubmitting),
      ],
    );
  }

  Padding _buildProcessBar(InspectionRouteEntity route) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📍 ${AppLocalizations.of(context)!.routeLocationInline(route.location, route.name)}',
            style: TextStyle(fontSize: 13, color: ColorName.colorTextGrey),
          ),
          const SizedBox(height: 14),
          ChecklistProgressBar(
            completedCount: route.completedCount,
            totalCount: route.totalCount,
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitBar(
    InspectionRouteEntity route, {
    required bool isSubmitting,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.06 * 255).toInt()),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: isSubmitting
              ? null
              : () => presenter?.onSubmitPressed(_bloc, route),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade600,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.green.shade200,
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
                  AppLocalizations.of(context)!.submitInspectionReport,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
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
              onPressed: () => presenter?.loadChecklist(_bloc, widget.routeId),
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

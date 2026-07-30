import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspection_app/core/gen/colors.gen.dart';
import 'package:inspection_app/util/widgets/custom_text_field.dart';

import '../../../../../../mvp/BaseView.dart';
import '../../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/inspection_checklist_item_entity.dart';
import '../bloc/equipment_inspection_bloc.dart';
import '../bloc/equipment_inspection_state.dart';
import '../mvp/photo_record_presenter.dart';
import '../mvp/i_photo_record_view.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PhotoRecordPage — BaseView (MVP View) cho màn hình「拍照記錄」
// Mở khi user nhấn nút「拍照記錄」của 1 hạng mục 異常 trong màn hình
// 「B1 設備巡檢」— dùng chung EquipmentInspectionBloc được truyền vào để mọi
// thay đổi (ảnh, mức độ, ghi chú) phản ánh ngay khi quay lại checklist.
// ─────────────────────────────────────────────────────────────────────────────

@RoutePage()
class PhotoRecordPage extends BaseView {
  final EquipmentInspectionBloc bloc;
  final String itemId;

  const PhotoRecordPage({super.key, required this.bloc, required this.itemId});

  @override
  State<PhotoRecordPage> createState() => _PhotoRecordPageState();
}

class _PhotoRecordPageState
    extends BaseViewState<PhotoRecordPresenter, PhotoRecordPage>
    implements IPhotoRecordView {
  late final TextEditingController _noteController = TextEditingController(
    text: _findItem(widget.bloc.state)?.note ?? '',
  );
  final _noteFocusNode = FocusNode();

  InspectionChecklistItemEntity? _findItem(EquipmentInspectionState state) {
    if (state is! EquipmentInspectionLoaded) return null;
    for (final item in state.route.items) {
      if (item.id == widget.itemId) return item;
    }
    return null;
  }

  // ─── MVP ──────────────────────────────────────────────────────────────────

  @override
  PhotoRecordPresenter createPresenter() => PhotoRecordPresenter();

  @override
  void dispose() {
    _noteController.dispose();
    _noteFocusNode.dispose();
    super.dispose();
  }

  // ─── IPhotoRecordView implementation ──────────────────────────────────────

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
  void popBack() {
    Navigator.of(context).pop();
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget buildView(BuildContext context) {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<EquipmentInspectionBloc, EquipmentInspectionState>(
        builder: (context, state) {
          final item = _findItem(state);
          if (item == null) return const SizedBox.shrink();

          return Scaffold(
            appBar: AppBar(
              title: Text(
                AppLocalizations.of(context)!.photoRecordTitle(item.index, item.name),
                style: const TextStyle(color: Colors.white),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => FocusScope.of(context).unfocus(),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPhotoSection(item),
                      const SizedBox(height: 24),
                      _buildSeveritySection(item),
                      const SizedBox(height: 24),
                      _buildNoteSection(),
                      const SizedBox(height: 28),
                      _buildActionButtons(item),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPhotoSection(InspectionChecklistItemEntity item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.multiplePhotosHint,
          style: TextStyle(fontSize: 16, color: ColorName.colorTextGrey),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final path in item.photoPaths) _buildPhotoThumbnail(path),
            _buildAddPhotoTile(),
          ],
        ),
      ],
    );
  }

  Widget _buildPhotoThumbnail(String path) {
    return ClipRRect(
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
          child: Icon(Icons.image_rounded, color: ColorName.colorTextGrey),
        ),
      ),
    );
  }

  Widget _buildAddPhotoTile() {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => presenter?.onAddPhotoTapped(widget.bloc, widget.itemId),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: ColorName.borderOutline, width: 1.5),
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

  Widget _buildSeveritySection(InspectionChecklistItemEntity item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.severityLevelLabel,
          style: TextStyle(fontSize: 16, color: ColorName.colorTextGrey),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildSeverityOption(
              severity: InspectionSeverity.high,

              color: ColorName.redDanger,
              current: item.severity,
            ),
            const SizedBox(width: 10),
            _buildSeverityOption(
              severity: InspectionSeverity.medium,

              color: Colors.orange.shade700,
              current: item.severity,
            ),
            const SizedBox(width: 10),
            _buildSeverityOption(
              severity: InspectionSeverity.low,

              color: ColorName.colorGrey2,
              current: item.severity,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: ColorName.borderOutline.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSeverityHint(AppLocalizations.of(context)!.severityHighHint),
              const SizedBox(height: 4),
              _buildSeverityHint(AppLocalizations.of(context)!.severityMediumHint),
              const SizedBox(height: 4),
              _buildSeverityHint(AppLocalizations.of(context)!.severityLowHint),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSeverityHint(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 12, color: ColorName.colorTextGrey),
    );
  }

  String _severityLabel(InspectionSeverity severity) {
    final l10n = AppLocalizations.of(context)!;
    switch (severity) {
      case InspectionSeverity.low:
        return l10n.severityLowLabel;
      case InspectionSeverity.medium:
        return l10n.severityMediumLabel;
      case InspectionSeverity.high:
        return l10n.severityHighLabel;
    }
  }

  Widget _buildSeverityOption({
    required InspectionSeverity severity,
    required Color color,
    required InspectionSeverity? current,
  }) {
    final selected = current == severity;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () =>
            presenter?.onSeveritySelected(widget.bloc, widget.itemId, severity),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? color : ColorName.white,
            border: Border.all(
              color: selected ? color : ColorName.borderOutline,
              width: selected ? 0 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _severityLabel(severity),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : ColorName.colorTextGrey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoteSection() {
    return CustomTextField(
      controller: _noteController,
      focusNode: _noteFocusNode,
      labelText: AppLocalizations.of(context)!.abnormalDescriptionLabel,
      labelTextStyle: TextStyle(fontSize: 16, color: ColorName.colorTextGrey),
      maxLines: 4,
    );
  }

  Widget _buildActionButtons(InspectionChecklistItemEntity item) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () =>
                presenter?.onOpenCameraPressed(widget.bloc, widget.itemId),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorName.bluePrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.camera_alt_rounded),
            label: Text(
              AppLocalizations.of(context)!.openCamera,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: () => presenter?.onCompletePressed(
              widget.bloc,
              widget.itemId,
              _noteController.text.trim(),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: ColorName.bluePrimary,
              side: BorderSide(color: ColorName.bluePrimary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.doneBackToChecklist,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }
}

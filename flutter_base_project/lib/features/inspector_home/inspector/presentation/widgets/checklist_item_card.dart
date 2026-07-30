import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inspection_app/core/gen/colors.gen.dart';
import 'package:inspection_app/util/widgets/custom_button.dart';

import '../../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/inspection_checklist_item_entity.dart';

/// ChecklistItemCard — một hạng mục trong danh sách kiểm tra thiết bị
///
/// Ảnh chụp qua「拍照記錄」và ghi chú được gắn trực tiếp vào hạng mục 異常
/// đang mở rộng — không dùng nút chụp ảnh dùng chung cho cả màn hình để
/// tránh nhầm lẫn ảnh thuộc hạng mục nào.
class ChecklistItemCard extends StatelessWidget {
  final InspectionChecklistItemEntity item;
  final ValueChanged<InspectionItemStatus> onStatusSelected;
  final ValueChanged<InspectionSeverity> onSeveritySelected;
  final VoidCallback onNoteTap;
  final VoidCallback onCapturePhotoTap;
  final VoidCallback onOpenPhotoRecord;

  const ChecklistItemCard({
    super.key,
    required this.item,
    required this.onStatusSelected,
    required this.onSeveritySelected,
    required this.onNoteTap,
    required this.onCapturePhotoTap,
    required this.onOpenPhotoRecord,
  });

  bool get _isAbnormal => item.status == InspectionItemStatus.abnormal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLeadingIcon(),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${item.index}. ${item.name}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildStatusChips(context),
                        if (_isAbnormal) ...[
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: CustomButton(
                              text: AppLocalizations.of(context)!.photoRecordButtonLabel,
                              elevation: 0,
                              onPressed: onOpenPhotoRecord,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          height: 1,
          width: double.infinity,
          color: ColorName.colorTextGrey.withAlpha((255 * 0.5).toInt()),
          child: SizedBox(height: 1, width: 1),
        ),
      ],
    );
  }

  Widget _buildLeadingIcon() {
    switch (item.status) {
      case InspectionItemStatus.notChecked:
        return Container(
          decoration: BoxDecoration(
            border: BoxBorder.all(
              color: ColorName.borderOutline,
              width: 2,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SizedBox(height: 22, width: 22),
        );
      case InspectionItemStatus.normal:
        return Container(
          decoration: BoxDecoration(
            color: ColorName.greenCheckBg,
            border: BoxBorder.all(
              color: ColorName.greenCheckBg,
              width: 2,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.check, color: Colors.white, size: 22),
        );
      case InspectionItemStatus.abnormal:
        return Container(
          decoration: BoxDecoration(
            color: ColorName.redDanger,
            border: BoxBorder.all(
              color: ColorName.redDanger,
              width: 2,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SizedBox(
            height: 22,
            width: 22,
            child: Center(
              child: const FaIcon(
                FontAwesomeIcons.exclamation,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        );
    }
  }

  Widget _buildStatusChips(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasSeverity = item.severity != null;
    // Chưa chọn status nào — hiện cả 2 lựa chọn
    if (item.status == InspectionItemStatus.notChecked) {
      return Row(
        children: [
          Expanded(
            child: _buildStatusChip(
              status: InspectionItemStatus.normal,
              label: l10n.statusNormal,
              selectedColor: Colors.green.shade600,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildStatusChip(
              status: InspectionItemStatus.abnormal,
              label: l10n.abnormalLabel,
              selectedColor: Colors.red.shade600,
            ),
          ),
        ],
      );
    }

    // Đã chọn 1 status — chỉ hiện status đó, bấm lại sẽ bỏ chọn (quay về cả 2)
    return _isAbnormal
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusChip(
                status: InspectionItemStatus.abnormal,
                label: hasSeverity ? l10n.abnormalWithLevelPrefix : l10n.abnormalLabel,
                highlightText: hasSeverity ? _severityLabel(l10n, item.severity!) : null,
                highlightColor: hasSeverity
                    ? _severityColor(item.severity!)
                    : null,
                selectedColor: Colors.red.shade600,
              ),
              _buildAbnormalSummary(context),
            ],
          )
        : _buildStatusChip(
            status: InspectionItemStatus.normal,
            label: l10n.statusNormal,
            selectedColor: Colors.green.shade600,
          );
  }

  Widget _buildStatusChip({
    required InspectionItemStatus status,
    required String label,
    required Color selectedColor,
    String? highlightText,
    Color? highlightColor,
  }) {
    return GestureDetector(
      onTap: () => onStatusSelected(status),
      child: _StatusChip(
        label: label,
        highlightText: highlightText,
        highlightColor: highlightColor,
        selected: item.status == status,
        selectedColor: selectedColor,
        onTap: () => onStatusSelected(status),
      ),
    );
  }

  /// Màu chữ mức độ — khớp với màu dùng ở màn hình「拍照記錄」・異常等級
  Color _severityColor(InspectionSeverity severity) {
    switch (severity) {
      case InspectionSeverity.high:
        return ColorName.redDanger;
      case InspectionSeverity.medium:
        return Colors.orange.shade700;
      case InspectionSeverity.low:
        return ColorName.colorGrey2;
    }
  }

  String _severityLabel(AppLocalizations l10n, InspectionSeverity severity) {
    switch (severity) {
      case InspectionSeverity.low:
        return l10n.severityLowLabel;
      case InspectionSeverity.medium:
        return l10n.severityMediumLabel;
      case InspectionSeverity.high:
        return l10n.severityHighLabel;
    }
  }

  /// Tóm tắt dữ liệu hạng mục 異常 (mức độ / số ảnh / ghi chú) — cập nhật ngay
  /// khi quay lại từ màn hình「拍照記錄」vì dùng chung EquipmentInspectionBloc
  Widget _buildAbnormalSummary(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasSeverity = item.severity != null;
    final hasPhotos = item.photoPaths.isNotEmpty;
    final hasNote = item.note?.isNotEmpty ?? false;

    if (!hasSeverity && !hasPhotos && !hasNote) {
      return Text(
        l10n.checklistNotFilledYet,
        style: TextStyle(fontSize: 12, color: ColorName.colorTextGrey),
      );
    }

    return Row(
      children: [
        if (hasPhotos) ...[
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ColorName.bgInforBox,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '📷 ${l10n.photoCountLabel(item.photoPaths.length)}',
              style: TextStyle(fontSize: 16, color: ColorName.greenPrimary),
            ),
          ),
          if (hasNote) const SizedBox(width: 8),
        ],
        if (hasNote)
          Expanded(
            child: Text(
              item.note ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16, color: ColorName.redDanger),
            ),
          ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final String? highlightText;
  final Color? highlightColor;
  final bool selected;
  final Color selectedColor;
  final VoidCallback onTap;

  const _StatusChip({
    required this.label,
    this.highlightText,
    this.highlightColor,
    required this.selected,
    required this.selectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = selected ? ColorName.greenPrimary : ColorName.colorTextGrey;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: selected,
          activeColor: Colors.black,
          checkColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          onChanged: (_) => onTap(),
        ),
        const SizedBox(width: 4),
        Text.rich(
          TextSpan(
            text: label,
            style: TextStyle(fontSize: 16, color: baseColor),
            children: [
              if (highlightText != null)
                TextSpan(
                  text: highlightText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: highlightColor,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

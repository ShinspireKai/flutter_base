import '../../domain/entities/inspection_checklist_item_entity.dart';

/// InspectionChecklistItemModel extends InspectionChecklistItemEntity — data layer model
class InspectionChecklistItemModel extends InspectionChecklistItemEntity {
  const InspectionChecklistItemModel({
    required super.id,
    required super.index,
    required super.name,
    super.status,
    super.severity,
    super.note,
    super.photoPaths,
  });

  factory InspectionChecklistItemModel.fromJson(Map<String, dynamic> json) {
    return InspectionChecklistItemModel(
      id: json['id']?.toString() ?? '',
      index: json['index'] ?? 0,
      name: json['name'] ?? '',
      status: InspectionItemStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => InspectionItemStatus.notChecked,
      ),
      severity: json['severity'] == null
          ? null
          : InspectionSeverity.values.firstWhere(
              (e) => e.name == json['severity'],
              orElse: () => InspectionSeverity.low,
            ),
      note: json['note'],
      photoPaths: (json['photo_paths'] as List?)?.cast<String>() ?? const [],
    );
  }
}

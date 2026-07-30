import '../../domain/entities/inspection_route_entity.dart';
import 'inspection_checklist_item_model.dart';

/// InspectionRouteModel extends InspectionRouteEntity — data layer model
class InspectionRouteModel extends InspectionRouteEntity {
  const InspectionRouteModel({
    required super.id,
    required super.name,
    required super.location,
    required super.items,
  });

  factory InspectionRouteModel.fromJson(Map<String, dynamic> json) {
    return InspectionRouteModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      items: (json['items'] as List? ?? [])
          .map(
            (item) =>
                InspectionChecklistItemModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

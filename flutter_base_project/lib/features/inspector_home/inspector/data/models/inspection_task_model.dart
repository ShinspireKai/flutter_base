import '../../domain/entities/inspection_task_entity.dart';

/// InspectionTaskModel extends InspectionTaskEntity — data layer model
class InspectionTaskModel extends InspectionTaskEntity {
  const InspectionTaskModel({
    required super.id,
    required super.name,
    required super.location,
    required super.scheduledTime,
    required super.status,
  });

  factory InspectionTaskModel.fromJson(Map<String, dynamic> json) {
    return InspectionTaskModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      scheduledTime: json['scheduled_time'] != null
          ? DateTime.parse(json['scheduled_time'])
          : DateTime.now(),
      status: InspectionTaskStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => InspectionTaskStatus.pending,
      ),
    );
  }
}

import '../../domain/entities/maintenance_task_entity.dart';

/// MaintenanceTaskModel extends MaintenanceTaskEntity — data layer model
class MaintenanceTaskModel extends MaintenanceTaskEntity {
  const MaintenanceTaskModel({
    required super.id,
    required super.name,
    required super.location,
    super.category,
    required super.priority,
    required super.status,
    required super.assignedDate,
    super.reporterName,
    super.reportedAt,
    super.reportDescription,
    super.reportPhotoPaths,
    super.ticketNo,
    super.isExternalAssignment,
    super.completionNote,
    super.completionPhotoPaths,
    super.completedAt,
    super.reworkRound,
    super.rejectionReason,
    super.rejectionReviewer,
    super.rejectionAt,
  });

  factory MaintenanceTaskModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceTaskModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      category: json['category'],
      priority: MaintenanceTaskPriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => MaintenanceTaskPriority.medium,
      ),
      status: MaintenanceTaskStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => MaintenanceTaskStatus.pending,
      ),
      assignedDate: json['assigned_date'] != null
          ? DateTime.parse(json['assigned_date'])
          : DateTime.now(),
      reporterName: json['reporter_name'],
      reportedAt: json['reported_at'] != null
          ? DateTime.parse(json['reported_at'])
          : null,
      reportDescription: json['report_description'],
      reportPhotoPaths:
          (json['report_photo_paths'] as List?)?.cast<String>() ?? const [],
      ticketNo: json['ticket_no'],
      isExternalAssignment: json['is_external_assignment'] ?? false,
      completionNote: json['completion_note'],
      completionPhotoPaths:
          (json['completion_photo_paths'] as List?)?.cast<String>() ??
              const [],
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
      reworkRound: json['rework_round'] ?? 0,
      rejectionReason: json['rejection_reason'],
      rejectionReviewer: json['rejection_reviewer'],
      rejectionAt: json['rejection_at'] != null
          ? DateTime.parse(json['rejection_at'])
          : null,
    );
  }

  factory MaintenanceTaskModel.fromEntity(MaintenanceTaskEntity entity) {
    return MaintenanceTaskModel(
      id: entity.id,
      name: entity.name,
      location: entity.location,
      category: entity.category,
      priority: entity.priority,
      status: entity.status,
      assignedDate: entity.assignedDate,
      reporterName: entity.reporterName,
      reportedAt: entity.reportedAt,
      reportDescription: entity.reportDescription,
      reportPhotoPaths: entity.reportPhotoPaths,
      ticketNo: entity.ticketNo,
      isExternalAssignment: entity.isExternalAssignment,
      completionNote: entity.completionNote,
      completionPhotoPaths: entity.completionPhotoPaths,
      completedAt: entity.completedAt,
      reworkRound: entity.reworkRound,
      rejectionReason: entity.rejectionReason,
      rejectionReviewer: entity.rejectionReviewer,
      rejectionAt: entity.rejectionAt,
    );
  }
}

import '../../domain/entities/inspector_profile_entity.dart';

/// InspectorProfileModel extends InspectorProfileEntity — data layer model
class InspectorProfileModel extends InspectorProfileEntity {
  const InspectorProfileModel({
    required super.id,
    required super.name,
    required super.email,
    super.avatarUrl,
    super.jobTitle,
    super.joinedDate,
  });

  factory InspectorProfileModel.fromJson(Map<String, dynamic> json) {
    return InspectorProfileModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatar_url'],
      jobTitle: json['job_title'],
      joinedDate: json['joined_date'] != null
          ? DateTime.parse(json['joined_date'])
          : null,
    );
  }
}

import '../../domain/entities/user_profile_entity.dart';

/// UserProfileModel extends UserProfileEntity — data layer model
class UserProfileModel extends UserProfileEntity {
  const UserProfileModel({
    required super.id,
    required super.name,
    required super.email,
    super.avatarUrl,
    super.jobTitle,
    super.joinedDate,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
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

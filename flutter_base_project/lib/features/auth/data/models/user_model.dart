import '../../domain/entities/user_entity.dart';

/// Data model — extends entity, thêm serialization
/// Open/Closed: thêm fields mới không cần sửa UserEntity
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.token,
    super.avatarUrl,
    super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      token: json['token']?.toString() ?? '',
      avatarUrl: json['avatar_url']?.toString(),
      role: json['role']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'token': token,
      'avatar_url': avatarUrl,
      'role': role,
    };
  }

  /// Convert từ Entity sang Model (khi cần serialize)
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      token: entity.token,
      avatarUrl: entity.avatarUrl,
      role: entity.role,
    );
  }
}

import '../../domain/entities/user_entity.dart';

/// UserModel extends UserEntity để hỗ trợ serialization
/// Liskov Substitution Principle: có thể dùng ở bất kỳ đâu cần UserEntity
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.token,
    super.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      token: json['token'] ?? '',
      avatarUrl: json['avatar_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'token': token,
      'avatar_url': avatarUrl,
    };
  }

  /// Tạo UserModel từ UserEntity (conversion helper)
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      token: entity.token,
      avatarUrl: entity.avatarUrl,
    );
  }
}

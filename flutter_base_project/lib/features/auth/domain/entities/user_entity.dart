import 'package:equatable/equatable.dart';

/// UserEntity — Pure domain object, không phụ thuộc framework nào
/// Single Responsibility: chỉ là data carrier
class UserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final String token;
  final String? avatarUrl;
  final String? role;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.token,
    this.avatarUrl,
    this.role,
  });

  @override
  List<Object?> get props => [id, email, name, token, avatarUrl, role];
}

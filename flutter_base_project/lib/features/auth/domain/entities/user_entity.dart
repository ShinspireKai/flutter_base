import 'package:equatable/equatable.dart';

/// User entity thuần túy — không phụ thuộc vào bất kỳ framework nào
/// Tuân thủ Single Responsibility Principle
class UserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final String token;
  final String? avatarUrl;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.token,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [id, email, name, token, avatarUrl];
}

import 'package:equatable/equatable.dart';

/// UserProfile entity cho trang Home
class UserProfileEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? jobTitle;
  final DateTime? joinedDate;

  const UserProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.jobTitle,
    this.joinedDate,
  });

  @override
  List<Object?> get props =>
      [id, name, email, avatarUrl, jobTitle, joinedDate];
}

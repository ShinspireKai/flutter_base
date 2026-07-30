import 'package:equatable/equatable.dart';

/// InspectorProfileEntity — thông tin profile cho trang Home của 巡檢人員 (Inspector)
class InspectorProfileEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? jobTitle;
  final DateTime? joinedDate;

  const InspectorProfileEntity({
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

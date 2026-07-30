import 'user_entity.dart';

/// Giá trị hợp lệ cho UserEntity.role
class UserRole {
  static const String inspector = 'inspector'; // 巡檢人員
  static const String contractor = 'contractor'; // 維修人員 / 外包廠商
}

extension UserRoleX on UserEntity {
  /// role != contractor được coi là inspector (mặc định an toàn)
  bool get isContractor => role == UserRole.contractor;
}

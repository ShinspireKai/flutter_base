import '../../../../../mvp/BaseModel.dart';

/// LoginModel — tầng Model của MVP cho Login
///
/// Single Responsibility: chỉ chứa data/state cần thiết cho presentation.
/// Business logic thực sự nằm ở UseCase (domain layer).
///
/// Ở đây Model lưu trạng thái nhỏ của UI không thuộc BLoC:
/// ví dụ: lần cuối user nhập email để pre-fill nếu cần.
class LoginModel extends BaseModel {
  String lastAttemptedEmail = '';

  @override
  void dispose() {
    lastAttemptedEmail = '';
    super.dispose();
  }
}

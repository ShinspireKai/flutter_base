import '../../../../../mvp/IView.dart';

/// ILoginView — View contract cho Login screen
///
/// Định nghĩa những gì Presenter có thể yêu cầu View làm.
/// Interface Segregation: chỉ khai báo method cần thiết cho login.
abstract class ILoginView extends IView {
  /// Điều hướng sang Home sau khi login thành công
  void navigateToHome();

  /// Hiển thị snackbar lỗi
  void showErrorSnackbar(String message);
}

import '../../../../../mvp/IView.dart';

/// ILoginView — View contract cho Login screen
///
/// Định nghĩa những gì Presenter có thể yêu cầu View làm.
/// Interface Segregation: chỉ khai báo method cần thiết cho login.
abstract class ILoginView extends IView {
  /// Điều hướng sang Home của 巡檢人員 (Inspector) sau khi login thành công
  void navigateToInspectorHome();

  /// Điều hướng sang Home của 維修人員 / 外包廠商 (Contractor) sau khi login thành công
  void navigateToContractorHome();

  /// Hiển thị snackbar lỗi
  void showErrorSnackbar(String message);
}

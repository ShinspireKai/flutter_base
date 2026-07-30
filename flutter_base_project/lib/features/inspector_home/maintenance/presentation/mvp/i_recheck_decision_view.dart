import '../../../../../mvp/IView.dart';

/// IRecheckDecisionView — View contract cho màn hình「異常複檢」(C2)
abstract class IRecheckDecisionView extends IView {
  /// Hiển thị snackbar lỗi
  void showErrorSnackbar(String message);

  /// Cảnh báo chưa nhập 複檢說明 khi bấm gửi複檢結果
  void showRecheckNoteRequiredWarning();

  /// Toast xác nhận đã gửi複檢結果 thành công
  void showSubmitCompletedToast({required bool approved});

  /// Điều hướng quay lại danh sách「待我複檢」sau khi gửi複檢結果
  void navigateBackToList();
}

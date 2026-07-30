import '../../../../../mvp/IView.dart';

/// IMaintenanceReportView — View contract cho màn hình「維修回報」(R2) / 「再維修」(R3)
abstract class IMaintenanceReportView extends IView {
  /// Hiển thị snackbar lỗi
  void showErrorSnackbar(String message);

  /// Hiển thị bottom sheet chọn nguồn ảnh (camera/thư viện)
  void showPhotoSourcePicker({required void Function(bool fromCamera) onSelected});

  /// Cảnh báo chưa nhập 完工說明 khi bấm gửi phúc kiểm
  void showCompletionNoteRequiredWarning();

  /// Toast xác nhận đã lưu tạm 更新進度
  void showProgressSavedToast();

  /// Toast xác nhận đã gửi「完成，送複檢」thành công
  void showSentForRecheckToast();

  /// Điều hướng quay lại danh sách「我的維修任務」sau khi gửi phúc kiểm
  void navigateBackToList();
}

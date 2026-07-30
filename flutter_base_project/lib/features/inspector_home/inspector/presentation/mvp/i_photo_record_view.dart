import '../../../../../mvp/IView.dart';

/// IPhotoRecordView — View contract cho màn hình「拍照記錄」
abstract class IPhotoRecordView extends IView {
  /// Hiển thị snackbar lỗi
  void showErrorSnackbar(String message);

  /// Hiển thị bottom sheet chọn nguồn ảnh (camera / thư viện)
  void showPhotoSourcePicker({
    required void Function(bool fromCamera) onSelected,
  });

  /// Lưu xong — quay lại màn hình danh sách kiểm tra
  void popBack();
}

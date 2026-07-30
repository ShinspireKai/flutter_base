import '../../../../../mvp/IView.dart';
import '../bloc/equipment_inspection_bloc.dart';

/// IEquipmentInspectionView — View contract cho màn hình「B1 設備巡檢」
abstract class IEquipmentInspectionView extends IView {
  /// Hiển thị snackbar lỗi
  void showErrorSnackbar(String message);

  /// Điều hướng sang màn hình「拍照記錄」cho 1 hạng mục 異常 — dùng chung bloc
  void navigateToPhotoRecord(EquipmentInspectionBloc bloc, String itemId);

  /// Hiển thị dialog nhập ghi chú
  void showNoteDialog({
    required String? initialNote,
    required void Function(String note) onSubmit,
  });

  /// Hiển thị bottom sheet chọn nguồn ảnh (camera / thư viện)
  void showPhotoSourcePicker({
    required void Function(bool fromCamera) onSelected,
  });

  /// Còn hạng mục chưa hoàn thành — không cho gửi báo cáo
  void showIncompleteChecklistWarning(int remainingCount);

  /// Điều hướng sang màn hình「簽名確認」— dùng chung bloc để gửi báo cáo
  void navigateToSignatureConfirmation(EquipmentInspectionBloc bloc);
}

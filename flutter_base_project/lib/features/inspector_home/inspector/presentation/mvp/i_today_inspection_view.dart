import '../../../../../../mvp/IView.dart';
import '../../domain/entities/inspection_task_entity.dart';

/// ITodayInspectionView — View contract cho trang「今日巡檢」của 巡檢人員 (Inspector)
abstract class ITodayInspectionView extends IView {
  /// Hiển thị snackbar lỗi
  void showErrorSnackbar(String message);

  /// Điều hướng tới màn hình kiểm tra thiết bị (ví dụ:「B1 設備巡檢」)
  /// khi user chọn 1 hạng mục trong danh sách
  void navigateToEquipmentInspection(InspectionTaskEntity task);
}

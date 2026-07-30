import '../../../../../mvp/IView.dart';
import '../../domain/entities/maintenance_task_entity.dart';

/// IMaintenanceTaskView — View contract cho trang「我的維修任務」của 維修人員 (Technician)
abstract class IMaintenanceTaskView extends IView {
  /// Hiển thị snackbar lỗi
  void showErrorSnackbar(String message);

  /// Điều hướng sang màn hình「維修回報」/「再維修」của nhiệm vụ được chọn
  void navigateToReport(MaintenanceTaskEntity task);

  /// Thông báo nhiệm vụ đã 已完成 khi user vẫn nhấn vào
  void showTaskAlreadyCompletedNotice();
}

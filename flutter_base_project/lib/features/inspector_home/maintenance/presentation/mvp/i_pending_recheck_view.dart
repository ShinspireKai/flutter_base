import '../../../../../mvp/IView.dart';
import '../../domain/entities/maintenance_task_entity.dart';

/// IPendingRecheckView — View contract cho trang「待我複檢」của người phúc kiểm
abstract class IPendingRecheckView extends IView {
  /// Hiển thị snackbar lỗi
  void showErrorSnackbar(String message);

  /// Điều hướng sang màn hình「異常複檢」của nhiệm vụ được chọn
  void navigateToRecheckDecision(MaintenanceTaskEntity task);
}

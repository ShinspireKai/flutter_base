import '../../../../../mvp/IView.dart';
import '../../../inspector_home/maintenance/domain/entities/maintenance_task_entity.dart';

/// IContractorHomeView — View contract cho màn hình「維修單回報」(V1),
/// luồng xác thực OTP không cần tài khoản dành cho 外包廠商.
///
/// Interface Segregation: chỉ khai báo method cần thiết cho màn hình này.
abstract class IContractorHomeView extends IView {
  /// Điều hướng sang「維修回報」sau khi xác thực 進入代碼 thành công
  void navigateToRepairReport(MaintenanceTaskEntity ticket);
}

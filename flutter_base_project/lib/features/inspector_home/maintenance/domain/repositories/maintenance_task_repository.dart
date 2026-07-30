import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/maintenance_task_entity.dart';

/// Abstract repository cho danh sách「我的維修任務」của 維修人員 (Technician)
abstract class MaintenanceTaskRepository {
  Future<Either<Failure, List<MaintenanceTaskEntity>>> getMaintenanceTasks();

  /// Cập nhật 1 nhiệm vụ (tiến độ / trạng thái / kết quả phúc kiểm)
  Future<Either<Failure, void>> updateMaintenanceTask(
    MaintenanceTaskEntity task,
  );

  /// Tra cứu nhiệm vụ theo 報修單 số (luồng SMS + OTP của 外包廠商)
  Future<Either<Failure, MaintenanceTaskEntity>> getTaskByTicketNo(
    String ticketNo,
  );

  /// Xác thực 進入代碼 (OTP) gửi kèm SMS
  Future<Either<Failure, bool>> verifyTicketEntryCode(
    String ticketNo,
    String code,
  );
}

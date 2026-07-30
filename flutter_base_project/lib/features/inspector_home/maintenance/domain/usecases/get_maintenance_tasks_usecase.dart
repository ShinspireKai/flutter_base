import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/maintenance_task_entity.dart';
import '../repositories/maintenance_task_repository.dart';

/// UseCase lấy danh sách các nhiệm vụ 維修 (maintenance) của 維修人員 (Technician)
class GetMaintenanceTasksUseCase
    extends UseCase<List<MaintenanceTaskEntity>, NoParams> {
  final MaintenanceTaskRepository _repository;

  GetMaintenanceTasksUseCase(this._repository);

  @override
  Future<Either<Failure, List<MaintenanceTaskEntity>>> call(
    NoParams params,
  ) {
    return _repository.getMaintenanceTasks();
  }
}

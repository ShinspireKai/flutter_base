import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/maintenance_task_entity.dart';
import '../repositories/maintenance_task_repository.dart';

/// UseCase cập nhật 1 nhiệm vụ 維修 (tiến độ / trạng thái / kết quả phúc kiểm)
class UpdateMaintenanceTaskUseCase
    extends UseCase<void, UpdateMaintenanceTaskParams> {
  final MaintenanceTaskRepository _repository;

  UpdateMaintenanceTaskUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(UpdateMaintenanceTaskParams params) {
    return _repository.updateMaintenanceTask(params.task);
  }
}

class UpdateMaintenanceTaskParams extends Equatable {
  final MaintenanceTaskEntity task;

  const UpdateMaintenanceTaskParams({required this.task});

  @override
  List<Object?> get props => [task];
}

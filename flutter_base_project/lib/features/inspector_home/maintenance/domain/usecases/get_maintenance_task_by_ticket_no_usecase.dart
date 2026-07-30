import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/maintenance_task_entity.dart';
import '../repositories/maintenance_task_repository.dart';

/// UseCase tra cứu 報修單 theo số phiếu — dùng cho màn hình「維修單回報」
/// (nhà thầu ngoài vào qua link SMS + OTP, không cần tài khoản)
class GetMaintenanceTaskByTicketNoUseCase
    extends UseCase<MaintenanceTaskEntity, GetMaintenanceTaskByTicketNoParams> {
  final MaintenanceTaskRepository _repository;

  GetMaintenanceTaskByTicketNoUseCase(this._repository);

  @override
  Future<Either<Failure, MaintenanceTaskEntity>> call(
    GetMaintenanceTaskByTicketNoParams params,
  ) {
    return _repository.getTaskByTicketNo(params.ticketNo);
  }
}

class GetMaintenanceTaskByTicketNoParams extends Equatable {
  final String ticketNo;

  const GetMaintenanceTaskByTicketNoParams({required this.ticketNo});

  @override
  List<Object?> get props => [ticketNo];
}

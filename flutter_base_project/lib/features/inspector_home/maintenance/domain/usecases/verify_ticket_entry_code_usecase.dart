import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/maintenance_task_repository.dart';

/// UseCase xác thực 進入代碼 (OTP) gửi kèm SMS khi 報修單 được 派工
class VerifyTicketEntryCodeUseCase
    extends UseCase<bool, VerifyTicketEntryCodeParams> {
  final MaintenanceTaskRepository _repository;

  VerifyTicketEntryCodeUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(VerifyTicketEntryCodeParams params) {
    return _repository.verifyTicketEntryCode(params.ticketNo, params.code);
  }
}

class VerifyTicketEntryCodeParams extends Equatable {
  final String ticketNo;
  final String code;

  const VerifyTicketEntryCodeParams({
    required this.ticketNo,
    required this.code,
  });

  @override
  List<Object?> get props => [ticketNo, code];
}

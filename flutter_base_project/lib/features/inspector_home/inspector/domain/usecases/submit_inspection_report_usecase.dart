import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/inspection_route_entity.dart';
import '../repositories/equipment_inspection_repository.dart';

/// UseCase gửi báo cáo kiểm tra sau khi hoàn tất toàn bộ checklist
class SubmitInspectionReportUseCase
    extends UseCase<bool, SubmitInspectionReportParams> {
  final EquipmentInspectionRepository _repository;

  SubmitInspectionReportUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(SubmitInspectionReportParams params) {
    return _repository.submitReport(params.route);
  }
}

class SubmitInspectionReportParams extends Equatable {
  final InspectionRouteEntity route;

  const SubmitInspectionReportParams({required this.route});

  @override
  List<Object?> get props => [route];
}

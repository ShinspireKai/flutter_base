import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/inspection_route_entity.dart';
import '../repositories/equipment_inspection_repository.dart';

/// UseCase lấy checklist của một tuyến kiểm tra thiết bị
class GetEquipmentInspectionChecklistUseCase
    extends UseCase<InspectionRouteEntity, GetEquipmentInspectionChecklistParams> {
  final EquipmentInspectionRepository _repository;

  GetEquipmentInspectionChecklistUseCase(this._repository);

  @override
  Future<Either<Failure, InspectionRouteEntity>> call(
    GetEquipmentInspectionChecklistParams params,
  ) {
    return _repository.getChecklist(params.routeId);
  }
}

class GetEquipmentInspectionChecklistParams extends Equatable {
  final String routeId;

  const GetEquipmentInspectionChecklistParams({required this.routeId});

  @override
  List<Object?> get props => [routeId];
}

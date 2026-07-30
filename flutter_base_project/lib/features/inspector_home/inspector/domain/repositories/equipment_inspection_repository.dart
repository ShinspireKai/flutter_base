import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/inspection_route_entity.dart';

/// Abstract repository cho tuyến kiểm tra thiết bị (ví dụ: 「B1 設備巡檢」)
abstract class EquipmentInspectionRepository {
  Future<Either<Failure, InspectionRouteEntity>> getChecklist(String routeId);

  Future<Either<Failure, bool>> submitReport(InspectionRouteEntity route);
}

import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../domain/entities/inspection_route_entity.dart';
import '../../domain/repositories/equipment_inspection_repository.dart';
import '../datasources/equipment_inspection_remote_datasource.dart';

/// Concrete implementation của EquipmentInspectionRepository
class EquipmentInspectionRepositoryImpl implements EquipmentInspectionRepository {
  final EquipmentInspectionRemoteDataSource _remoteDataSource;

  EquipmentInspectionRepositoryImpl({
    required EquipmentInspectionRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, InspectionRouteEntity>> getChecklist(
    String routeId,
  ) async {
    try {
      final route = await _remoteDataSource.getChecklist(routeId);
      return Right(route);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> submitReport(
    InspectionRouteEntity route,
  ) async {
    try {
      final success = await _remoteDataSource.submitReport(route);
      return Right(success);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

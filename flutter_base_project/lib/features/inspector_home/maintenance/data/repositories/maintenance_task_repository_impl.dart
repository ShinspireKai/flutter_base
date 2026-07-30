import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../domain/entities/maintenance_task_entity.dart';
import '../../domain/repositories/maintenance_task_repository.dart';
import '../datasources/maintenance_task_remote_datasource.dart';
import '../models/maintenance_task_model.dart';

/// Concrete implementation của MaintenanceTaskRepository
class MaintenanceTaskRepositoryImpl implements MaintenanceTaskRepository {
  final MaintenanceTaskRemoteDataSource _remoteDataSource;

  MaintenanceTaskRepositoryImpl({
    required MaintenanceTaskRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<MaintenanceTaskEntity>>>
      getMaintenanceTasks() async {
    try {
      final tasks = await _remoteDataSource.getMaintenanceTasks();
      return Right(tasks);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateMaintenanceTask(
    MaintenanceTaskEntity task,
  ) async {
    try {
      await _remoteDataSource.updateMaintenanceTask(
        MaintenanceTaskModel.fromEntity(task),
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MaintenanceTaskEntity>> getTaskByTicketNo(
    String ticketNo,
  ) async {
    try {
      final task = await _remoteDataSource.getTaskByTicketNo(ticketNo);
      if (task == null) {
        return Left(ServerFailure(message: 'ticket_not_found'));
      }
      return Right(task);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyTicketEntryCode(
    String ticketNo,
    String code,
  ) async {
    try {
      final isValid = await _remoteDataSource.verifyTicketEntryCode(
        ticketNo,
        code,
      );
      return Right(isValid);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

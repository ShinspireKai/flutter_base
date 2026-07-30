import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../domain/entities/inspection_task_entity.dart';
import '../../domain/repositories/today_inspection_repository.dart';
import '../datasources/today_inspection_remote_datasource.dart';

/// Concrete implementation của TodayInspectionRepository
class TodayInspectionRepositoryImpl implements TodayInspectionRepository {
  final TodayInspectionRemoteDataSource _remoteDataSource;

  TodayInspectionRepositoryImpl({
    required TodayInspectionRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<InspectionTaskEntity>>>
      getTodayInspections() async {
    try {
      final tasks = await _remoteDataSource.getTodayInspections();
      return Right(tasks);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

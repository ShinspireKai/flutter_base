import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/inspector_profile_entity.dart';
import '../../domain/repositories/inspector_home_repository.dart';
import '../datasources/inspector_home_remote_datasource.dart';

/// Concrete implementation của InspectorHomeRepository
class InspectorHomeRepositoryImpl implements InspectorHomeRepository {
  final InspectorHomeRemoteDataSource _remoteDataSource;

  InspectorHomeRepositoryImpl({required InspectorHomeRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, InspectorProfileEntity>> getUserProfile() async {
    try {
      final profile = await _remoteDataSource.getUserProfile();
      return Right(profile);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

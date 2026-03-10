import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

/// Concrete implementation của AuthRepository
/// Orchestrate remote + local data sources
/// Dependency Inversion: phụ thuộc vào abstractions (AuthRemoteDataSource, AuthLocalDataSource)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      // Cache user data locally
      await _localDataSource.cacheUser(userModel);
      return Right(userModel);
    } on Exception catch (e) {
      return Left(AuthFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await _localDataSource.clearAuthData();
      return const Right(true);
    } on Exception catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final result = await _localDataSource.isLoggedIn();
      return Right(result);
    } on Exception catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCachedUser() async {
    try {
      final userModel = await _localDataSource.getCachedUser();
      return Right(userModel);
    } on Exception catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}

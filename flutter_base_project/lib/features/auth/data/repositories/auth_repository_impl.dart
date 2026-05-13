import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

/// AuthRepositoryImpl — Concrete implementation
///
/// SOLID:
/// - S: Chỉ orchestrate remote + local data cho auth
/// - D: Phụ thuộc vào abstractions (AuthRemoteDataSource, AuthLocalDataSource)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remote = remoteDataSource,
        _local = localDataSource;

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _remote.login(email: email, password: password);
      await _local.cacheUser(user); // Cache sau khi login thành công
      return Right(user);
    } on Exception catch (e) {
      return Left(
        AuthFailure(message: e.toString().replaceAll('Exception: ', '')),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await _local.clearAuthData();
      return const Right(true);
    } on Exception catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      return Right(await _local.isLoggedIn());
    } on Exception catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCachedUser() async {
    try {
      return Right(await _local.getCachedUser());
    } on Exception catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}

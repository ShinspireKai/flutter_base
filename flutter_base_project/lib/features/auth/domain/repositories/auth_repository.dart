import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

/// AuthRepository — Abstract contract cho auth operations
/// Dependency Inversion: domain chỉ biết interface này, không biết implementation
abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
    required bool rememberMe,
  });

  Future<Either<Failure, bool>> logout();

  Future<Either<Failure, bool>> isLoggedIn();

  Future<Either<Failure, UserEntity?>> getCachedUser();
}

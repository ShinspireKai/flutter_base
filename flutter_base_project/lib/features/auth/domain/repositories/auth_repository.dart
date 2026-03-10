import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

/// Abstract repository cho auth — Dependency Inversion Principle
/// Domain layer chỉ phụ thuộc vào interface này, không biết implementation
abstract class AuthRepository {
  /// Đăng nhập với email và password
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  /// Đăng xuất
  Future<Either<Failure, bool>> logout();

  /// Kiểm tra đã đăng nhập chưa
  Future<Either<Failure, bool>> isLoggedIn();

  /// Lấy thông tin user hiện tại từ cache
  Future<Either<Failure, UserEntity?>> getCachedUser();
}

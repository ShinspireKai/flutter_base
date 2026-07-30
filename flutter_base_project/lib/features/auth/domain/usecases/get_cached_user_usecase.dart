import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// GetCachedUserUseCase — lấy user đã cache (kèm role) để quyết định
/// điều hướng vào đúng home theo role (Inspector / Contractor)
class GetCachedUserUseCase extends UseCase<UserEntity, NoParams> {
  final AuthRepository _repository;

  GetCachedUserUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    final result = await _repository.getCachedUser();

    return result.fold(
      (failure) => Left(failure),
      (user) => user == null
          ? const Left(AuthFailure(message: 'Không tìm thấy phiên đăng nhập.'))
          : Right(user),
    );
  }
}

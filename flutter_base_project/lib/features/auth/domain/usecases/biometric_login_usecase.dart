import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// BiometricLoginUseCase — đăng nhập lại bằng phiên đã lưu sau khi
/// sinh trắc học xác thực thành công (không gọi lại API đăng nhập)
class BiometricLoginUseCase extends UseCase<UserEntity, NoParams> {
  final AuthRepository _repository;

  BiometricLoginUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    final result = await _repository.getCachedUser();

    return result.fold(
      (failure) => Left(failure),
      (user) => user == null
          ? const Left(
              AuthFailure(
                message: 'Chưa có phiên đăng nhập. Vui lòng đăng nhập bằng mật khẩu trước.',
              ),
            )
          : Right(user),
    );
  }
}

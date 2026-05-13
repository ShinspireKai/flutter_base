import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

/// CheckLoginStatusUseCase — kiểm tra trạng thái đăng nhập
class CheckLoginStatusUseCase extends UseCase<bool, NoParams> {
  final AuthRepository _repository;

  CheckLoginStatusUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return _repository.isLoggedIn();
  }
}

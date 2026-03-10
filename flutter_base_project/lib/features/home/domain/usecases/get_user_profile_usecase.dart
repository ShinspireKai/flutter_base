import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/user_profile_entity.dart';
import '../repositories/home_repository.dart';

/// UseCase lấy thông tin profile user
class GetUserProfileUseCase extends UseCase<UserProfileEntity, NoParams> {
  final HomeRepository _repository;

  GetUserProfileUseCase(this._repository);

  @override
  Future<Either<Failure, UserProfileEntity>> call(NoParams params) {
    return _repository.getUserProfile();
  }
}

import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/inspector_profile_entity.dart';
import '../repositories/inspector_home_repository.dart';

/// UseCase lấy thông tin profile của 巡檢人員 (Inspector)
class GetInspectorProfileUseCase
    extends UseCase<InspectorProfileEntity, NoParams> {
  final InspectorHomeRepository _repository;

  GetInspectorProfileUseCase(this._repository);

  @override
  Future<Either<Failure, InspectorProfileEntity>> call(NoParams params) {
    return _repository.getUserProfile();
  }
}

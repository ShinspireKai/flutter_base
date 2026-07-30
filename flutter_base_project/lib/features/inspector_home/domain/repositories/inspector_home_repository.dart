import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/inspector_profile_entity.dart';

/// Abstract repository cho InspectorHome feature (巡檢人員)
abstract class InspectorHomeRepository {
  Future<Either<Failure, InspectorProfileEntity>> getUserProfile();
}

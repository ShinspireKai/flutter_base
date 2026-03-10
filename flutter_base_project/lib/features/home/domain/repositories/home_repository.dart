import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/user_profile_entity.dart';

/// Abstract repository cho Home feature
abstract class HomeRepository {
  Future<Either<Failure, UserProfileEntity>> getUserProfile();
}

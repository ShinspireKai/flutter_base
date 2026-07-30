import 'package:dartz/dartz.dart';

import '../../../../../../core/error/failures.dart';
import '../entities/inspection_task_entity.dart';

/// Abstract repository cho danh sách「今日巡檢」của 巡檢人員 (Inspector)
abstract class TodayInspectionRepository {
  Future<Either<Failure, List<InspectionTaskEntity>>> getTodayInspections();
}

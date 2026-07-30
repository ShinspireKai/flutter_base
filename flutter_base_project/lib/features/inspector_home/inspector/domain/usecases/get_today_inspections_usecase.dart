import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/inspection_task_entity.dart';
import '../repositories/today_inspection_repository.dart';

/// UseCase lấy danh sách các hạng mục巡檢 hôm nay của 巡檢人員 (Inspector)
class GetTodayInspectionsUseCase
    extends UseCase<List<InspectionTaskEntity>, NoParams> {
  final TodayInspectionRepository _repository;

  GetTodayInspectionsUseCase(this._repository);

  @override
  Future<Either<Failure, List<InspectionTaskEntity>>> call(
    NoParams params,
  ) {
    return _repository.getTodayInspections();
  }
}

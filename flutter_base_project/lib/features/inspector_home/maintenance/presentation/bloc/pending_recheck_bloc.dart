import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../domain/entities/maintenance_task_entity.dart';
import '../../domain/usecases/get_maintenance_tasks_usecase.dart';
import 'pending_recheck_event.dart';
import 'pending_recheck_state.dart';

/// PendingRecheckBloc — quản lý state trang「待我複檢」của người phúc kiểm
///
/// Lọc lại từ danh sách 維修任務 chung, chỉ giữ những nhiệm vụ đã được thợ
/// sửa gửi「完成，送複檢」(status == pendingRecheck), xếp theo thời gian
/// gửi phúc kiểm sớm nhất trước (FIFO).
///
/// Events → States:
///   PendingRecheckLoadTasks → PendingRecheckLoading → PendingRecheckLoaded | PendingRecheckError
///   PendingRecheckRefreshed → PendingRecheckLoaded(isRefreshing: true) → PendingRecheckLoaded
class PendingRecheckBloc extends Bloc<PendingRecheckEvent, PendingRecheckState> {
  final GetMaintenanceTasksUseCase _getMaintenanceTasksUseCase;

  PendingRecheckBloc({
    required GetMaintenanceTasksUseCase getMaintenanceTasksUseCase,
  })  : _getMaintenanceTasksUseCase = getMaintenanceTasksUseCase,
        super(const PendingRecheckInitial()) {
    on<PendingRecheckLoadTasks>(_onLoadTasks);
    on<PendingRecheckRefreshed>(_onRefreshed);
  }

  List<MaintenanceTaskEntity> _pendingRecheckOnly(
    List<MaintenanceTaskEntity> tasks,
  ) {
    final filtered = tasks
        .where((task) => task.status == MaintenanceTaskStatus.pendingRecheck)
        .toList();
    filtered.sort((a, b) {
      final aTime = a.completedAt ?? a.assignedDate;
      final bTime = b.completedAt ?? b.assignedDate;
      return aTime.compareTo(bTime);
    });
    return filtered;
  }

  Future<void> _onLoadTasks(
    PendingRecheckLoadTasks event,
    Emitter<PendingRecheckState> emit,
  ) async {
    emit(const PendingRecheckLoading());
    final result = await _getMaintenanceTasksUseCase(NoParams());
    result.fold(
      (failure) => emit(PendingRecheckError(message: failure.message)),
      (tasks) => emit(PendingRecheckLoaded(tasks: _pendingRecheckOnly(tasks))),
    );
  }

  Future<void> _onRefreshed(
    PendingRecheckRefreshed event,
    Emitter<PendingRecheckState> emit,
  ) async {
    if (state is PendingRecheckLoaded) {
      emit((state as PendingRecheckLoaded).copyWith(isRefreshing: true));
    }
    final result = await _getMaintenanceTasksUseCase(NoParams());
    result.fold(
      (failure) => emit(PendingRecheckError(message: failure.message)),
      (tasks) => emit(PendingRecheckLoaded(tasks: _pendingRecheckOnly(tasks))),
    );
  }
}

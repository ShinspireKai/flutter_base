import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/maintenance_task_entity.dart';
import '../../domain/usecases/update_maintenance_task_usecase.dart';
import 'recheck_decision_event.dart';
import 'recheck_decision_state.dart';

/// RecheckDecisionBloc — quản lý state màn hình「異常複檢」(C2)
///
/// Tạo mới cho mỗi phiên mở nhiệm vụ (page-scoped, giống MaintenanceReportBloc)
/// — không cung cấp toàn app qua main.dart.
///
/// Events → States:
///   *ResultChanged/*NoteChanged        → Loaded (cập nhật lựa chọn/ghi chú)
///   RecheckDecisionSubmitted           → Loaded(isSubmitting: true) →
///       通過 → task.status = completed（結案）
///       不通過 → task.status = inProgress, reworkRound + 1（trả về再維修 cho thợ sửa）
class RecheckDecisionBloc
    extends Bloc<RecheckDecisionEvent, RecheckDecisionState> {
  final UpdateMaintenanceTaskUseCase _updateMaintenanceTaskUseCase;

  /// TODO: '林先生' là tên placeholder — cần lấy tên user thực từ profile.
  static const _reviewerName = '林先生';

  RecheckDecisionBloc({
    required MaintenanceTaskEntity initialTask,
    required UpdateMaintenanceTaskUseCase updateMaintenanceTaskUseCase,
  })  : _updateMaintenanceTaskUseCase = updateMaintenanceTaskUseCase,
        super(RecheckDecisionLoaded(task: initialTask)) {
    on<RecheckDecisionResultChanged>(_onResultChanged);
    on<RecheckDecisionNoteChanged>(_onNoteChanged);
    on<RecheckDecisionSubmitted>(_onSubmitted);
  }

  void _onResultChanged(
    RecheckDecisionResultChanged event,
    Emitter<RecheckDecisionState> emit,
  ) {
    final loaded = state;
    if (loaded is! RecheckDecisionLoaded) return;
    emit(loaded.copyWith(result: event.result));
  }

  void _onNoteChanged(
    RecheckDecisionNoteChanged event,
    Emitter<RecheckDecisionState> emit,
  ) {
    final loaded = state;
    if (loaded is! RecheckDecisionLoaded) return;
    emit(loaded.copyWith(note: event.note));
  }

  Future<void> _onSubmitted(
    RecheckDecisionSubmitted event,
    Emitter<RecheckDecisionState> emit,
  ) async {
    final loaded = state;
    if (loaded is! RecheckDecisionLoaded) return;

    emit(loaded.copyWith(isSubmitting: true));

    final now = DateTime.now();
    final decidedTask = loaded.result == RecheckResult.approved
        ? loaded.task.copyWith(status: MaintenanceTaskStatus.completed)
        : loaded.task.copyWith(
            status: MaintenanceTaskStatus.inProgress,
            reworkRound: loaded.task.reworkRound + 1,
            rejectionReason: loaded.note,
            rejectionReviewer: _reviewerName,
            rejectionAt: now,
            completionNote: null,
            completionPhotoPaths: const [],
            completedAt: null,
          );

    final result = await _updateMaintenanceTaskUseCase(
      UpdateMaintenanceTaskParams(task: decidedTask),
    );
    result.fold(
      (failure) => emit(RecheckDecisionError(message: failure.message)),
      (_) => emit(RecheckDecisionSubmitCompleted(result: loaded.result)),
    );
  }
}

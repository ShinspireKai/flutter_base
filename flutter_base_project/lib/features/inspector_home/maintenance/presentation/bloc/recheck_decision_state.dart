import 'package:equatable/equatable.dart';

import '../../domain/entities/maintenance_task_entity.dart';
import 'recheck_decision_event.dart';

/// RecheckDecision States — màn hình「異常複檢」(C2)
abstract class RecheckDecisionState extends Equatable {
  const RecheckDecisionState();

  @override
  List<Object?> get props => [];
}

/// Trạng thái hiển thị/chỉnh sửa chính — BlocBuilder render từ state này
class RecheckDecisionLoaded extends RecheckDecisionState {
  final MaintenanceTaskEntity task;
  final RecheckResult result;
  final String note;
  final bool isSubmitting;

  const RecheckDecisionLoaded({
    required this.task,
    this.result = RecheckResult.approved,
    this.note = '',
    this.isSubmitting = false,
  });

  RecheckDecisionLoaded copyWith({
    MaintenanceTaskEntity? task,
    RecheckResult? result,
    String? note,
    bool? isSubmitting,
  }) {
    return RecheckDecisionLoaded(
      task: task ?? this.task,
      result: result ?? this.result,
      note: note ?? this.note,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [task, result, note, isSubmitting];
}

/// One-shot — đã gửi複檢結果 thành công; Presenter điều hướng quay lại
/// danh sách「待我複檢」
class RecheckDecisionSubmitCompleted extends RecheckDecisionState {
  final RecheckResult result;

  const RecheckDecisionSubmitCompleted({required this.result});

  @override
  List<Object?> get props => [result];
}

/// Lỗi khi gửi複檢結果
class RecheckDecisionError extends RecheckDecisionState {
  final String message;

  const RecheckDecisionError({required this.message});

  @override
  List<Object?> get props => [message];
}

import 'package:equatable/equatable.dart';

import '../../domain/entities/maintenance_task_entity.dart';

/// PendingRecheck States (待我複檢)
abstract class PendingRecheckState extends Equatable {
  const PendingRecheckState();

  @override
  List<Object?> get props => [];
}

/// Trạng thái ban đầu
class PendingRecheckInitial extends PendingRecheckState {
  const PendingRecheckInitial();
}

/// Đang tải dữ liệu lần đầu
class PendingRecheckLoading extends PendingRecheckState {
  const PendingRecheckLoading();
}

/// Tải thành công, sẵn sàng hiển thị — chỉ gồm nhiệm vụ status == pendingRecheck
class PendingRecheckLoaded extends PendingRecheckState {
  final List<MaintenanceTaskEntity> tasks;
  final bool isRefreshing;

  const PendingRecheckLoaded({
    required this.tasks,
    this.isRefreshing = false,
  });

  PendingRecheckLoaded copyWith({
    List<MaintenanceTaskEntity>? tasks,
    bool? isRefreshing,
  }) {
    return PendingRecheckLoaded(
      tasks: tasks ?? this.tasks,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [tasks, isRefreshing];
}

/// Lỗi tải dữ liệu
class PendingRecheckError extends PendingRecheckState {
  final String message;

  const PendingRecheckError({required this.message});

  @override
  List<Object?> get props => [message];
}

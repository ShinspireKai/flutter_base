import 'package:equatable/equatable.dart';

import '../../domain/entities/inspection_task_entity.dart';

/// TodayInspection States (今日巡檢)
abstract class TodayInspectionState extends Equatable {
  const TodayInspectionState();

  @override
  List<Object?> get props => [];
}

/// Trạng thái ban đầu
class TodayInspectionInitial extends TodayInspectionState {
  const TodayInspectionInitial();
}

/// Đang tải dữ liệu lần đầu
class TodayInspectionLoading extends TodayInspectionState {
  const TodayInspectionLoading();
}

/// Tải thành công, sẵn sàng hiển thị
class TodayInspectionLoaded extends TodayInspectionState {
  final List<InspectionTaskEntity> tasks;
  final bool isRefreshing;

  const TodayInspectionLoaded({
    required this.tasks,
    this.isRefreshing = false,
  });

  int get completedCount => tasks
      .where((t) => t.status == InspectionTaskStatus.completed)
      .length;

  int get pendingCount => tasks
      .where((t) => t.status == InspectionTaskStatus.pending)
      .length;

  int get overdueCount => tasks
      .where((t) => t.status == InspectionTaskStatus.overdue)
      .length;

  TodayInspectionLoaded copyWith({
    List<InspectionTaskEntity>? tasks,
    bool? isRefreshing,
  }) {
    return TodayInspectionLoaded(
      tasks: tasks ?? this.tasks,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [tasks, isRefreshing];
}

/// Lỗi tải dữ liệu
class TodayInspectionError extends TodayInspectionState {
  final String message;

  const TodayInspectionError({required this.message});

  @override
  List<Object?> get props => [message];
}

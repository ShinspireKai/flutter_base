import 'package:equatable/equatable.dart';

import '../../domain/entities/maintenance_task_entity.dart';

/// MaintenanceTask States (我的維修任務)
abstract class MaintenanceTaskState extends Equatable {
  const MaintenanceTaskState();

  @override
  List<Object?> get props => [];
}

/// Trạng thái ban đầu
class MaintenanceTaskInitial extends MaintenanceTaskState {
  const MaintenanceTaskInitial();
}

/// Đang tải dữ liệu lần đầu
class MaintenanceTaskLoading extends MaintenanceTaskState {
  const MaintenanceTaskLoading();
}

/// Tải thành công, sẵn sàng hiển thị
class MaintenanceTaskLoaded extends MaintenanceTaskState {
  final List<MaintenanceTaskEntity> tasks;
  final bool isRefreshing;

  const MaintenanceTaskLoaded({
    required this.tasks,
    this.isRefreshing = false,
  });

  MaintenanceTaskLoaded copyWith({
    List<MaintenanceTaskEntity>? tasks,
    bool? isRefreshing,
  }) {
    return MaintenanceTaskLoaded(
      tasks: tasks ?? this.tasks,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [tasks, isRefreshing];
}

/// Lỗi tải dữ liệu
class MaintenanceTaskError extends MaintenanceTaskState {
  final String message;

  const MaintenanceTaskError({required this.message});

  @override
  List<Object?> get props => [message];
}

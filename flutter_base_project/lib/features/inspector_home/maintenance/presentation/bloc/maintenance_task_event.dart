import 'package:equatable/equatable.dart';

/// MaintenanceTask Events (我的維修任務)
abstract class MaintenanceTaskEvent extends Equatable {
  const MaintenanceTaskEvent();

  @override
  List<Object?> get props => [];
}

/// Load danh sách維修任務 khi vào trang
class MaintenanceTaskLoadTasks extends MaintenanceTaskEvent {
  const MaintenanceTaskLoadTasks();
}

/// User nhấn refresh
class MaintenanceTaskRefreshed extends MaintenanceTaskEvent {
  const MaintenanceTaskRefreshed();
}

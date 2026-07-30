import 'package:equatable/equatable.dart';

/// TodayInspection Events (今日巡檢)
abstract class TodayInspectionEvent extends Equatable {
  const TodayInspectionEvent();

  @override
  List<Object?> get props => [];
}

/// Load danh sách巡檢 hôm nay khi vào trang
class TodayInspectionLoadTasks extends TodayInspectionEvent {
  const TodayInspectionLoadTasks();
}

/// User nhấn refresh
class TodayInspectionRefreshed extends TodayInspectionEvent {
  const TodayInspectionRefreshed();
}

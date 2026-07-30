import 'package:equatable/equatable.dart';

/// PendingRecheck Events (待我複檢)
abstract class PendingRecheckEvent extends Equatable {
  const PendingRecheckEvent();

  @override
  List<Object?> get props => [];
}

/// Load danh sách nhiệm vụ đang 待複檢 khi vào trang
class PendingRecheckLoadTasks extends PendingRecheckEvent {
  const PendingRecheckLoadTasks();
}

/// User nhấn refresh, hoặc quay lại từ màn hình「異常複檢」sau khi đã xử lý xong
class PendingRecheckRefreshed extends PendingRecheckEvent {
  const PendingRecheckRefreshed();
}

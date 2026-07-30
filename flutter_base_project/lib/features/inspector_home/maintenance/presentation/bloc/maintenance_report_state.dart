import 'package:equatable/equatable.dart';

import '../../domain/entities/maintenance_task_entity.dart';

/// MaintenanceReport States — màn hình「維修回報」(R2) / 「再維修」(R3)
abstract class MaintenanceReportState extends Equatable {
  const MaintenanceReportState();

  @override
  List<Object?> get props => [];
}

/// Trạng thái hiển thị/chỉnh sửa chính — BlocBuilder render từ state này
class MaintenanceReportLoaded extends MaintenanceReportState {
  final MaintenanceTaskEntity task;
  final bool isSubmitting;

  const MaintenanceReportLoaded({
    required this.task,
    this.isSubmitting = false,
  });

  MaintenanceReportLoaded copyWith({
    MaintenanceTaskEntity? task,
    bool? isSubmitting,
  }) {
    return MaintenanceReportLoaded(
      task: task ?? this.task,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [task, isSubmitting];
}

/// One-shot — vừa lưu tạm 更新進度 thành công, Presenter hiện toast rồi
/// BLoC emit lại Loaded ngay sau đó để tiếp tục chỉnh sửa
class MaintenanceReportProgressSaved extends MaintenanceReportState {
  final MaintenanceTaskEntity task;

  const MaintenanceReportProgressSaved({required this.task});

  @override
  List<Object?> get props => [task];
}

/// One-shot — đã gửi「完成，送複檢」thành công, [task] chuyển sang
/// pendingRecheck; Presenter hiện toast rồi điều hướng quay lại danh sách
/// 「我的維修任務」— quyết định 通過/不通過 nay do người phúc kiểm xử lý ở
/// màn hình「待我複檢」/「異常複檢」, không còn mô phỏng tự động ở đây
class MaintenanceReportSentForRecheck extends MaintenanceReportState {
  final MaintenanceTaskEntity task;

  const MaintenanceReportSentForRecheck({required this.task});

  @override
  List<Object?> get props => [task];
}

/// Lỗi khi lưu/gửi
class MaintenanceReportError extends MaintenanceReportState {
  final String message;

  const MaintenanceReportError({required this.message});

  @override
  List<Object?> get props => [message];
}

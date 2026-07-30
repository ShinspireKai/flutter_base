import 'package:equatable/equatable.dart';

/// MaintenanceReport Events — màn hình「維修回報」(R2) / 「再維修」(R3)
abstract class MaintenanceReportEvent extends Equatable {
  const MaintenanceReportEvent();

  @override
  List<Object?> get props => [];
}

/// User chỉnh sửa 完工說明 / 本次完工說明
class MaintenanceReportCompletionNoteChanged extends MaintenanceReportEvent {
  final String note;

  const MaintenanceReportCompletionNoteChanged({required this.note});

  @override
  List<Object?> get props => [note];
}

/// Nguồn ảnh — camera (拍照) hoặc thư viện ảnh có sẵn
enum MaintenancePhotoSource { camera, gallery }

/// User nhấn thêm ảnh vào 完工照片
class MaintenanceReportPhotoCaptureRequested extends MaintenanceReportEvent {
  final MaintenancePhotoSource source;

  const MaintenanceReportPhotoCaptureRequested({required this.source});

  @override
  List<Object?> get props => [source];
}

/// User nhấn「更新進度」— lưu tạm完工說明/完工照片, chưa hoàn tất
class MaintenanceReportProgressUpdateRequested extends MaintenanceReportEvent {
  const MaintenanceReportProgressUpdateRequested();
}

/// User nhấn「完成，送複檢」/「完成，再送複檢」(đã được Presenter xác nhận
/// đã nhập完工說明)
class MaintenanceReportSubmitted extends MaintenanceReportEvent {
  const MaintenanceReportSubmitted();
}

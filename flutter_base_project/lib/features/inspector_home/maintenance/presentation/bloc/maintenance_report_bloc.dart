import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/photo_capture_service.dart';
import '../../domain/entities/maintenance_task_entity.dart';
import '../../domain/usecases/update_maintenance_task_usecase.dart';
import 'maintenance_report_event.dart';
import 'maintenance_report_state.dart';

/// MaintenanceReportBloc — quản lý state màn hình「維修回報」(R2) / 「再維修」(R3)
///
/// Tạo mới cho mỗi phiên mở nhiệm vụ (page-scoped, giống EquipmentInspectionBloc)
/// — không cung cấp toàn app qua main.dart.
///
/// Events → States:
///   *NoteChanged/*PhotoCaptureRequested        → Loaded (cập nhật task)
///   MaintenanceReportProgressUpdateRequested   → Loaded(isSubmitting:false) →
///       ProgressSaved → Loaded (lưu tạm, không đổi status)
///   MaintenanceReportSubmitted                 → Loaded(isSubmitting: true) →
///       SentForRecheck (status → pendingRecheck, chờ người phúc kiểm xử lý
///       ở màn hình「待我複檢」/「異常複檢」)
class MaintenanceReportBloc
    extends Bloc<MaintenanceReportEvent, MaintenanceReportState> {
  final UpdateMaintenanceTaskUseCase _updateMaintenanceTaskUseCase;
  final PhotoCaptureService _photoCaptureService;

  MaintenanceReportBloc({
    required MaintenanceTaskEntity initialTask,
    required UpdateMaintenanceTaskUseCase updateMaintenanceTaskUseCase,
    required PhotoCaptureService photoCaptureService,
  })  : _updateMaintenanceTaskUseCase = updateMaintenanceTaskUseCase,
        _photoCaptureService = photoCaptureService,
        super(MaintenanceReportLoaded(task: initialTask)) {
    on<MaintenanceReportCompletionNoteChanged>(_onCompletionNoteChanged);
    on<MaintenanceReportPhotoCaptureRequested>(_onPhotoCaptureRequested);
    on<MaintenanceReportProgressUpdateRequested>(_onProgressUpdateRequested);
    on<MaintenanceReportSubmitted>(_onSubmitted);
  }

  void _onCompletionNoteChanged(
    MaintenanceReportCompletionNoteChanged event,
    Emitter<MaintenanceReportState> emit,
  ) {
    final loaded = state;
    if (loaded is! MaintenanceReportLoaded) return;
    emit(loaded.copyWith(task: loaded.task.copyWith(
      completionNote: event.note,
    )));
  }

  Future<void> _onPhotoCaptureRequested(
    MaintenanceReportPhotoCaptureRequested event,
    Emitter<MaintenanceReportState> emit,
  ) async {
    final loaded = state;
    if (loaded is! MaintenanceReportLoaded) return;

    final photoPath = event.source == MaintenancePhotoSource.camera
        ? await _photoCaptureService.captureFromCamera()
        : await _photoCaptureService.pickFromGallery();
    if (photoPath == null) return; // Người dùng huỷ

    // Đọc lại state mới nhất — tránh ghi đè thay đổi xảy ra trong lúc chờ camera
    final current = state;
    if (current is! MaintenanceReportLoaded) return;

    emit(current.copyWith(
      task: current.task.copyWith(
        completionPhotoPaths: [
          ...current.task.completionPhotoPaths,
          photoPath,
        ],
      ),
    ));
  }

  Future<void> _onProgressUpdateRequested(
    MaintenanceReportProgressUpdateRequested event,
    Emitter<MaintenanceReportState> emit,
  ) async {
    final loaded = state;
    if (loaded is! MaintenanceReportLoaded) return;

    final result = await _updateMaintenanceTaskUseCase(
      UpdateMaintenanceTaskParams(task: loaded.task),
    );
    result.fold(
      (failure) => emit(MaintenanceReportError(message: failure.message)),
      (_) {
        emit(MaintenanceReportProgressSaved(task: loaded.task));
        emit(MaintenanceReportLoaded(task: loaded.task));
      },
    );
  }

  Future<void> _onSubmitted(
    MaintenanceReportSubmitted event,
    Emitter<MaintenanceReportState> emit,
  ) async {
    final loaded = state;
    if (loaded is! MaintenanceReportLoaded) return;

    emit(loaded.copyWith(isSubmitting: true));

    // Đưa nhiệm vụ vào hàng chờ「待我複檢」— quyết định 通過/不通過 do người
    // phúc kiểm thực hiện thủ công ở PendingRecheckBloc/RecheckDecisionBloc.
    final pendingTask = loaded.task.copyWith(
      status: MaintenanceTaskStatus.pendingRecheck,
      completedAt: DateTime.now(),
    );
    final result = await _updateMaintenanceTaskUseCase(
      UpdateMaintenanceTaskParams(task: pendingTask),
    );
    result.fold(
      (failure) => emit(MaintenanceReportError(message: failure.message)),
      (_) => emit(MaintenanceReportSentForRecheck(task: pendingTask)),
    );
  }
}

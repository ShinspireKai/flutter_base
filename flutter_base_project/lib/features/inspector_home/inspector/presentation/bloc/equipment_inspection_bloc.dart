import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/photo_capture_service.dart';
import '../../domain/entities/inspection_checklist_item_entity.dart';
import '../../domain/usecases/get_equipment_inspection_checklist_usecase.dart';
import '../../domain/usecases/submit_inspection_report_usecase.dart';
import 'equipment_inspection_event.dart';
import 'equipment_inspection_state.dart';

/// EquipmentInspectionBloc — quản lý state màn hình「B1 設備巡檢」(và các tuyến khác)
///
/// Events → States:
///   EquipmentInspectionLoadChecklist   → Loading → Loaded | Error
///   *ItemStatusChanged/*SeverityChanged/*NoteChanged/*PhotoCaptureRequested → Loaded (cập nhật item)
///   EquipmentInspectionSubmitted       → Loaded(isSubmitting: true) → SubmitSuccess | Error
class EquipmentInspectionBloc
    extends Bloc<EquipmentInspectionEvent, EquipmentInspectionState> {
  final GetEquipmentInspectionChecklistUseCase _getChecklistUseCase;
  final SubmitInspectionReportUseCase _submitReportUseCase;
  final PhotoCaptureService _photoCaptureService;

  EquipmentInspectionBloc({
    required GetEquipmentInspectionChecklistUseCase getChecklistUseCase,
    required SubmitInspectionReportUseCase submitReportUseCase,
    required PhotoCaptureService photoCaptureService,
  })  : _getChecklistUseCase = getChecklistUseCase,
        _submitReportUseCase = submitReportUseCase,
        _photoCaptureService = photoCaptureService,
        super(const EquipmentInspectionInitial()) {
    on<EquipmentInspectionLoadChecklist>(_onLoadChecklist);
    on<EquipmentInspectionItemStatusChanged>(_onItemStatusChanged);
    on<EquipmentInspectionSeverityChanged>(_onSeverityChanged);
    on<EquipmentInspectionNoteChanged>(_onNoteChanged);
    on<EquipmentInspectionPhotoCaptureRequested>(_onPhotoCaptureRequested);
    on<EquipmentInspectionSubmitted>(_onSubmitted);
  }

  Future<void> _onLoadChecklist(
    EquipmentInspectionLoadChecklist event,
    Emitter<EquipmentInspectionState> emit,
  ) async {
    emit(const EquipmentInspectionLoading());
    final result = await _getChecklistUseCase(
      GetEquipmentInspectionChecklistParams(routeId: event.routeId),
    );
    result.fold(
      (failure) => emit(EquipmentInspectionError(message: failure.message)),
      (route) => emit(EquipmentInspectionLoaded(route: route)),
    );
  }

  void _onItemStatusChanged(
    EquipmentInspectionItemStatusChanged event,
    Emitter<EquipmentInspectionState> emit,
  ) {
    final loaded = state;
    if (loaded is! EquipmentInspectionLoaded) return;

    final item = loaded.route.items.firstWhere((i) => i.id == event.itemId);
    // Bấm lại đúng status đang chọn — bỏ chọn, quay về chưa kiểm tra
    final nextStatus = item.status == event.status
        ? InspectionItemStatus.notChecked
        : event.status;
    final updated = item.copyWith(
      status: nextStatus,
      clearSeverity: true,
      clearNote: true,
      photoPaths: const [],
    );
    emit(loaded.copyWith(route: loaded.route.copyWithItem(updated)));
  }

  void _onSeverityChanged(
    EquipmentInspectionSeverityChanged event,
    Emitter<EquipmentInspectionState> emit,
  ) {
    final loaded = state;
    if (loaded is! EquipmentInspectionLoaded) return;

    final item = loaded.route.items.firstWhere((i) => i.id == event.itemId);
    final updated = item.copyWith(severity: event.severity);
    emit(loaded.copyWith(route: loaded.route.copyWithItem(updated)));
  }

  void _onNoteChanged(
    EquipmentInspectionNoteChanged event,
    Emitter<EquipmentInspectionState> emit,
  ) {
    final loaded = state;
    if (loaded is! EquipmentInspectionLoaded) return;

    final item = loaded.route.items.firstWhere((i) => i.id == event.itemId);
    final updated = item.copyWith(note: event.note);
    emit(loaded.copyWith(route: loaded.route.copyWithItem(updated)));
  }

  Future<void> _onPhotoCaptureRequested(
    EquipmentInspectionPhotoCaptureRequested event,
    Emitter<EquipmentInspectionState> emit,
  ) async {
    final loaded = state;
    if (loaded is! EquipmentInspectionLoaded) return;

    final photoPath = event.source == InspectionPhotoSource.camera
        ? await _photoCaptureService.captureFromCamera()
        : await _photoCaptureService.pickFromGallery();
    if (photoPath == null) return; // Người dùng huỷ

    // Đọc lại state mới nhất — tránh ghi đè thay đổi xảy ra trong lúc chờ camera
    final current = state;
    if (current is! EquipmentInspectionLoaded) return;

    final item = current.route.items.firstWhere((i) => i.id == event.itemId);
    final updated = item.copyWith(
      photoPaths: [...item.photoPaths, photoPath],
    );
    emit(current.copyWith(route: current.route.copyWithItem(updated)));
  }

  Future<void> _onSubmitted(
    EquipmentInspectionSubmitted event,
    Emitter<EquipmentInspectionState> emit,
  ) async {
    final loaded = state;
    if (loaded is! EquipmentInspectionLoaded) return;

    emit(loaded.copyWith(isSubmitting: true));
    final result = await _submitReportUseCase(
      SubmitInspectionReportParams(route: loaded.route),
    );
    result.fold(
      (failure) => emit(EquipmentInspectionError(message: failure.message)),
      (_) => emit(EquipmentInspectionSubmitSuccess(route: loaded.route)),
    );
  }
}

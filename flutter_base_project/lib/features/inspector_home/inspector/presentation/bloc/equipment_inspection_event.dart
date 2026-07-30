import 'package:equatable/equatable.dart';

import '../../domain/entities/inspection_checklist_item_entity.dart';

/// EquipmentInspection Events — tuyến kiểm tra thiết bị (ví dụ: 「B1 設備巡檢」)
abstract class EquipmentInspectionEvent extends Equatable {
  const EquipmentInspectionEvent();

  @override
  List<Object?> get props => [];
}

/// Load checklist của tuyến kiểm tra khi vào màn hình
class EquipmentInspectionLoadChecklist extends EquipmentInspectionEvent {
  final String routeId;

  const EquipmentInspectionLoadChecklist({required this.routeId});

  @override
  List<Object?> get props => [routeId];
}

/// User chọn 正常 / 異常 cho một hạng mục
class EquipmentInspectionItemStatusChanged extends EquipmentInspectionEvent {
  final String itemId;
  final InspectionItemStatus status;

  const EquipmentInspectionItemStatusChanged({
    required this.itemId,
    required this.status,
  });

  @override
  List<Object?> get props => [itemId, status];
}

/// User chọn mức độ nghiêm trọng cho hạng mục 異常
class EquipmentInspectionSeverityChanged extends EquipmentInspectionEvent {
  final String itemId;
  final InspectionSeverity severity;

  const EquipmentInspectionSeverityChanged({
    required this.itemId,
    required this.severity,
  });

  @override
  List<Object?> get props => [itemId, severity];
}

/// User nhập ghi chú cho hạng mục 異常
class EquipmentInspectionNoteChanged extends EquipmentInspectionEvent {
  final String itemId;
  final String note;

  const EquipmentInspectionNoteChanged({
    required this.itemId,
    required this.note,
  });

  @override
  List<Object?> get props => [itemId, note];
}

/// Nguồn ảnh — camera (拍照) hoặc thư viện ảnh có sẵn
enum InspectionPhotoSource { camera, gallery }

/// User nhấn 「拍照記錄」cho một hạng mục 異常 — mở camera/thư viện rồi gắn ảnh
/// vào hạng mục đang kiểm tra
class EquipmentInspectionPhotoCaptureRequested
    extends EquipmentInspectionEvent {
  final String itemId;
  final InspectionPhotoSource source;

  const EquipmentInspectionPhotoCaptureRequested({
    required this.itemId,
    this.source = InspectionPhotoSource.camera,
  });

  @override
  List<Object?> get props => [itemId, source];
}

/// User nhấn 送出巡檢報告 (đã được Presenter xác nhận đủ điều kiện gửi)
class EquipmentInspectionSubmitted extends EquipmentInspectionEvent {
  const EquipmentInspectionSubmitted();
}

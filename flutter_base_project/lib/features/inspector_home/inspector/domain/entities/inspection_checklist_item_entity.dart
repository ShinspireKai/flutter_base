import 'package:equatable/equatable.dart';

/// Trạng thái đánh giá của một hạng mục kiểm tra thiết bị
enum InspectionItemStatus {
  /// Chưa chọn 正常 / 異常
  notChecked,

  /// 正常 — Bình thường
  normal,

  /// 異常 — Bất thường
  abnormal,
}

/// Mức độ nghiêm trọng khi hạng mục ở trạng thái 異常 (Bất thường)
enum InspectionSeverity {
  /// 高 — Cao
  high,

  /// 中 — Trung bình
  medium,

  /// 低 — Thấp
  low,
}

/// InspectionChecklistItemEntity — một hạng mục trong tuyến kiểm tra thiết bị
/// (ví dụ: 「7. 電盤溫度」trong tuyến「B1 設備巡檢」)
class InspectionChecklistItemEntity extends Equatable {
  final String id;
  final int index;
  final String name;
  final InspectionItemStatus status;
  final InspectionSeverity? severity;
  final String? note;
  final List<String> photoPaths;

  const InspectionChecklistItemEntity({
    required this.id,
    required this.index,
    required this.name,
    this.status = InspectionItemStatus.notChecked,
    this.severity,
    this.note,
    this.photoPaths = const [],
  });

  /// Hạng mục được coi là hoàn thành khi:
  /// - 正常: không cần thêm gì
  /// - 異常: bắt buộc phải chọn mức độ nghiêm trọng
  bool get isCompleted {
    switch (status) {
      case InspectionItemStatus.notChecked:
        return false;
      case InspectionItemStatus.normal:
        return true;
      case InspectionItemStatus.abnormal:
        return severity != null;
    }
  }

  InspectionChecklistItemEntity copyWith({
    InspectionItemStatus? status,
    InspectionSeverity? severity,
    String? note,
    List<String>? photoPaths,
    bool clearSeverity = false,
    bool clearNote = false,
  }) {
    return InspectionChecklistItemEntity(
      id: id,
      index: index,
      name: name,
      status: status ?? this.status,
      severity: clearSeverity ? null : (severity ?? this.severity),
      note: clearNote ? null : (note ?? this.note),
      photoPaths: photoPaths ?? this.photoPaths,
    );
  }

  @override
  List<Object?> get props => [
    id,
    index,
    name,
    status,
    severity,
    note,
    photoPaths,
  ];
}

import 'package:equatable/equatable.dart';

/// Mức độ ưu tiên của một nhiệm vụ 維修 (maintenance task)
enum MaintenanceTaskPriority {
  /// Chấm đỏ — mức độ nghiêm trọng cao, cần xử lý ưu tiên
  high,

  /// Chấm vàng — mức độ cảnh báo, ưu tiên thấp hơn
  medium,

  /// Chấm trắng — mức độ cảnh báo, ưu tiên thấp hơn
  low,
}

/// Trạng thái của một nhiệm vụ 維修 (maintenance task)
enum MaintenanceTaskStatus {
  /// 待維修 — chờ sửa chữa
  pending,

  /// 維修中 — đang sửa chữa
  inProgress,

  /// 待複檢 — đã gửi, chờ phúc kiểm
  pendingRecheck,

  /// 已完成 — phúc kiểm đạt, đóng nhiệm vụ
  completed,
}

/// MaintenanceTaskEntity — một nhiệm vụ trong danh sách「我的維修任務」của 維修人員 (Technician)
///
/// Vòng đời: pending/inProgress → (完成，送複檢) → pendingRecheck →
/// phúc kiểm KHÔNG đạt → inProgress (reworkRound + 1, có rejectionReason) →
/// (完成，再送複檢) → pendingRecheck → phúc kiểm đạt → completed.
class MaintenanceTaskEntity extends Equatable {
  final String id;
  final String name;
  final String location;
  final String? category;
  final MaintenanceTaskPriority priority;
  final MaintenanceTaskStatus status;
  final DateTime assignedDate;

  /// Thông tin báo cáo sự cố gốc — null nếu nhiệm vụ chưa từng được báo cáo
  ///
  /// Khi [isExternalAssignment] = true, [reporterName] chứa tên nhà thầu
  /// được ủy quyền (委派) thay vì người thông báo (通報) — 2 vai trò dùng
  /// chung 1 field vì UI chỉ khác nhãn hiển thị, không khác dữ liệu.
  final String? reporterName;
  final DateTime? reportedAt;
  final String? reportDescription;
  final List<String> reportPhotoPaths;

  /// Số phiếu hiển thị cho nhà thầu ngoài (vd "#0523") — null với nhiệm vụ nội bộ
  final String? ticketNo;

  /// true nếu nhiệm vụ được giao qua link SMS + OTP cho nhà thầu ngoài (外包廠商)
  final bool isExternalAssignment;

  /// Bản nháp完工說明/完工照片 của lượt sửa hiện tại — reset mỗi khi bị退回
  final String? completionNote;
  final List<String> completionPhotoPaths;

  /// Thời điểm gửi「完成，送複檢」— null nếu chưa từng gửi phúc kiểm ở lượt hiện tại
  final DateTime? completedAt;

  /// Số lần bị phúc kiểm trả về — 0 = lần sửa đầu tiên, >0 = đang再維修
  final int reworkRound;
  final String? rejectionReason;
  final String? rejectionReviewer;
  final DateTime? rejectionAt;

  const MaintenanceTaskEntity({
    required this.id,
    required this.name,
    required this.location,
    this.category,
    required this.priority,
    required this.status,
    required this.assignedDate,
    this.reporterName,
    this.reportedAt,
    this.reportDescription,
    this.reportPhotoPaths = const [],
    this.ticketNo,
    this.isExternalAssignment = false,
    this.completionNote,
    this.completionPhotoPaths = const [],
    this.completedAt,
    this.reworkRound = 0,
    this.rejectionReason,
    this.rejectionReviewer,
    this.rejectionAt,
  });

  static const _unset = Object();

  MaintenanceTaskEntity copyWith({
    MaintenanceTaskStatus? status,
    Object? completionNote = _unset,
    List<String>? completionPhotoPaths,
    Object? completedAt = _unset,
    int? reworkRound,
    Object? rejectionReason = _unset,
    Object? rejectionReviewer = _unset,
    Object? rejectionAt = _unset,
  }) {
    return MaintenanceTaskEntity(
      id: id,
      name: name,
      location: location,
      category: category,
      priority: priority,
      status: status ?? this.status,
      assignedDate: assignedDate,
      reporterName: reporterName,
      reportedAt: reportedAt,
      reportDescription: reportDescription,
      reportPhotoPaths: reportPhotoPaths,
      ticketNo: ticketNo,
      isExternalAssignment: isExternalAssignment,
      completionNote: completionNote == _unset
          ? this.completionNote
          : completionNote as String?,
      completionPhotoPaths: completionPhotoPaths ?? this.completionPhotoPaths,
      completedAt: completedAt == _unset
          ? this.completedAt
          : completedAt as DateTime?,
      reworkRound: reworkRound ?? this.reworkRound,
      rejectionReason: rejectionReason == _unset
          ? this.rejectionReason
          : rejectionReason as String?,
      rejectionReviewer: rejectionReviewer == _unset
          ? this.rejectionReviewer
          : rejectionReviewer as String?,
      rejectionAt: rejectionAt == _unset
          ? this.rejectionAt
          : rejectionAt as DateTime?,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    location,
    category,
    priority,
    status,
    assignedDate,
    reporterName,
    reportedAt,
    ticketNo,
    isExternalAssignment,
    reportDescription,
    reportPhotoPaths,
    completionNote,
    completionPhotoPaths,
    completedAt,
    reworkRound,
    rejectionReason,
    rejectionReviewer,
    rejectionAt,
  ];
}

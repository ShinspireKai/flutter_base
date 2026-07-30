import 'package:equatable/equatable.dart';

/// Trạng thái của một hạng mục 巡檢 (inspection task)
enum InspectionTaskStatus {
  /// Chưa巡檢
  pending,

  /// Đã hoàn thành
  completed,

  /// Quá hạn巡檢
  overdue,
}

/// InspectionTaskEntity — một hạng mục巡檢 trong danh sách「今日巡檢」
class InspectionTaskEntity extends Equatable {
  final String id;
  final String name;
  final String location;
  final DateTime scheduledTime;
  final InspectionTaskStatus status;

  const InspectionTaskEntity({
    required this.id,
    required this.name,
    required this.location,
    required this.scheduledTime,
    required this.status,
  });

  @override
  List<Object?> get props => [id, name, location, scheduledTime, status];
}

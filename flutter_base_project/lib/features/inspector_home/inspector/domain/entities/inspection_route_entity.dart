import 'package:equatable/equatable.dart';

import 'inspection_checklist_item_entity.dart';

/// InspectionRouteEntity — một tuyến kiểm tra thiết bị (ví dụ: 「B1 設備巡檢」)
/// cùng danh sách hạng mục cần kiểm tra của tuyến đó
class InspectionRouteEntity extends Equatable {
  final String id;
  final String name;
  final String location;
  final List<InspectionChecklistItemEntity> items;

  const InspectionRouteEntity({
    required this.id,
    required this.name,
    required this.location,
    required this.items,
  });

  int get completedCount => items.where((item) => item.isCompleted).length;

  int get totalCount => items.length;

  /// Số hạng mục đang ở trạng thái 異常 (Bất thường)
  int get abnormalCount =>
      items.where((item) => item.status == InspectionItemStatus.abnormal).length;

  /// Tiến độ hoàn thành, giá trị trong khoảng 0.0 → 1.0
  double get progress => totalCount == 0 ? 0 : completedCount / totalCount;

  bool get isAllCompleted => totalCount > 0 && completedCount == totalCount;

  InspectionRouteEntity copyWithItem(InspectionChecklistItemEntity updated) {
    return InspectionRouteEntity(
      id: id,
      name: name,
      location: location,
      items: [
        for (final item in items)
          if (item.id == updated.id) updated else item,
      ],
    );
  }

  @override
  List<Object?> get props => [id, name, location, items];
}

import 'package:equatable/equatable.dart';

import '../../domain/entities/inspection_route_entity.dart';

/// EquipmentInspection States — tuyến kiểm tra thiết bị (ví dụ: 「B1 設備巡檢」)
abstract class EquipmentInspectionState extends Equatable {
  const EquipmentInspectionState();

  @override
  List<Object?> get props => [];
}

/// Trạng thái ban đầu
class EquipmentInspectionInitial extends EquipmentInspectionState {
  const EquipmentInspectionInitial();
}

/// Đang tải checklist lần đầu
class EquipmentInspectionLoading extends EquipmentInspectionState {
  const EquipmentInspectionLoading();
}

/// Tải thành công, sẵn sàng hiển thị/chỉnh sửa checklist
class EquipmentInspectionLoaded extends EquipmentInspectionState {
  final InspectionRouteEntity route;
  final bool isSubmitting;

  const EquipmentInspectionLoaded({
    required this.route,
    this.isSubmitting = false,
  });

  EquipmentInspectionLoaded copyWith({
    InspectionRouteEntity? route,
    bool? isSubmitting,
  }) {
    return EquipmentInspectionLoaded(
      route: route ?? this.route,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [route, isSubmitting];
}

/// Lỗi tải checklist hoặc gửi báo cáo
class EquipmentInspectionError extends EquipmentInspectionState {
  final String message;

  const EquipmentInspectionError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Gửi báo cáo thành công — Presenter lắng nghe để điều hướng sang màn hình
/// 「巡檢完成」, mang theo snapshot route lúc gửi (route sẽ mất khỏi state
/// sau khi rời khỏi EquipmentInspectionLoaded)
class EquipmentInspectionSubmitSuccess extends EquipmentInspectionState {
  final InspectionRouteEntity route;

  const EquipmentInspectionSubmitSuccess({required this.route});

  @override
  List<Object?> get props => [route];
}

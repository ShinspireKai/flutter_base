import 'package:equatable/equatable.dart';

import '../../domain/entities/inspector_profile_entity.dart';

/// InspectorHome States (巡檢人員)
abstract class InspectorHomeState extends Equatable {
  const InspectorHomeState();

  @override
  List<Object?> get props => [];
}

/// Trạng thái ban đầu
class InspectorHomeInitial extends InspectorHomeState {
  const InspectorHomeInitial();
}

/// Đang tải dữ liệu lần đầu
class InspectorHomeLoading extends InspectorHomeState {
  const InspectorHomeLoading();
}

/// Tải thành công, sẵn sàng hiển thị
class InspectorHomeLoaded extends InspectorHomeState {
  final InspectorProfileEntity profile;
  final bool isRefreshing;

  const InspectorHomeLoaded({
    required this.profile,
    this.isRefreshing = false,
  });

  InspectorHomeLoaded copyWith({
    InspectorProfileEntity? profile,
    bool? isRefreshing,
  }) {
    return InspectorHomeLoaded(
      profile: profile ?? this.profile,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [profile, isRefreshing];
}

/// Lỗi tải dữ liệu
class InspectorHomeError extends InspectorHomeState {
  final String message;

  const InspectorHomeError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Đang logout
class InspectorHomeLoggingOut extends InspectorHomeState {
  const InspectorHomeLoggingOut();
}

/// Logout thành công — trigger navigate
class InspectorHomeLoggedOut extends InspectorHomeState {
  const InspectorHomeLoggedOut();
}

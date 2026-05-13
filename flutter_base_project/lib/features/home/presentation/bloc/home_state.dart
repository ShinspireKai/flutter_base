import 'package:equatable/equatable.dart';

import '../../domain/entities/user_profile_entity.dart';

/// Home States
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

/// Trạng thái ban đầu
class HomeInitial extends HomeState {
  const HomeInitial();
}

/// Đang tải dữ liệu lần đầu
class HomeLoading extends HomeState {
  const HomeLoading();
}

/// Tải thành công, sẵn sàng hiển thị
class HomeLoaded extends HomeState {
  final UserProfileEntity profile;
  final bool isRefreshing;

  const HomeLoaded({
    required this.profile,
    this.isRefreshing = false,
  });

  HomeLoaded copyWith({UserProfileEntity? profile, bool? isRefreshing}) {
    return HomeLoaded(
      profile: profile ?? this.profile,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [profile, isRefreshing];
}

/// Lỗi tải dữ liệu
class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Đang logout
class HomeLoggingOut extends HomeState {
  const HomeLoggingOut();
}

/// Logout thành công — trigger navigate
class HomeLoggedOut extends HomeState {
  const HomeLoggedOut();
}

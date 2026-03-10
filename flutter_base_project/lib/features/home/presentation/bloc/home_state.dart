import 'package:equatable/equatable.dart';

import '../../domain/entities/user_profile_entity.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

/// Trạng thái ban đầu
class HomeInitial extends HomeState {
  const HomeInitial();
}

/// Đang tải dữ liệu
class HomeLoading extends HomeState {
  const HomeLoading();
}

/// Tải thành công profile
class HomeLoaded extends HomeState {
  final UserProfileEntity profile;
  const HomeLoaded({required this.profile});

  @override
  List<Object?> get props => [profile];
}

/// Có lỗi xảy ra
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

/// Logout thành công
class HomeLoggedOut extends HomeState {
  const HomeLoggedOut();
}

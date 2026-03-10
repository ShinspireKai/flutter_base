import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

/// Event load user profile khi vào trang Home
class HomeLoadUserProfile extends HomeEvent {
  const HomeLoadUserProfile();
}

/// Event logout
class HomeLogout extends HomeEvent {
  const HomeLogout();
}

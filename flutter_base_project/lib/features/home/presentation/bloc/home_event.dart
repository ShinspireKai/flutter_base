import 'package:equatable/equatable.dart';

/// Home Events
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

/// Load user profile khi vào trang Home
class HomeLoadUserProfile extends HomeEvent {
  const HomeLoadUserProfile();
}

/// User nhấn refresh
class HomeRefreshed extends HomeEvent {
  const HomeRefreshed();
}

/// User nhấn logout
class HomeLogout extends HomeEvent {
  const HomeLogout();
}

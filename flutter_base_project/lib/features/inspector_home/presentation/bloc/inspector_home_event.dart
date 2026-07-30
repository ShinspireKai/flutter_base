import 'package:equatable/equatable.dart';

/// InspectorHome Events (巡檢人員)
abstract class InspectorHomeEvent extends Equatable {
  const InspectorHomeEvent();

  @override
  List<Object?> get props => [];
}

/// Load user profile khi vào trang Home
class InspectorHomeLoadUserProfile extends InspectorHomeEvent {
  const InspectorHomeLoadUserProfile();
}

/// User nhấn refresh
class InspectorHomeRefreshed extends InspectorHomeEvent {
  const InspectorHomeRefreshed();
}

/// User nhấn logout
class InspectorHomeLogout extends InspectorHomeEvent {
  const InspectorHomeLogout();
}

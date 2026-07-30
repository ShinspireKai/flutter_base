import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../auth/domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_inspector_profile_usecase.dart';
import 'inspector_home_event.dart';
import 'inspector_home_state.dart';

/// InspectorHomeBloc — quản lý state trang Home của 巡檢人員 (Inspector)
///
/// Events → States:
///   InspectorHomeLoadUserProfile → InspectorHomeLoading → InspectorHomeLoaded | InspectorHomeError
///   InspectorHomeRefreshed       → InspectorHomeLoaded(isRefreshing: true) → InspectorHomeLoaded
///   InspectorHomeLogout          → InspectorHomeLoggingOut → InspectorHomeLoggedOut | InspectorHomeError
class InspectorHomeBloc extends Bloc<InspectorHomeEvent, InspectorHomeState> {
  final GetInspectorProfileUseCase _getInspectorProfileUseCase;
  final LogoutUseCase _logoutUseCase;

  InspectorHomeBloc({
    required GetInspectorProfileUseCase getInspectorProfileUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _getInspectorProfileUseCase = getInspectorProfileUseCase,
        _logoutUseCase = logoutUseCase,
        super(const InspectorHomeInitial()) {
    on<InspectorHomeLoadUserProfile>(_onLoadUserProfile);
    on<InspectorHomeRefreshed>(_onRefreshed);
    on<InspectorHomeLogout>(_onLogout);
  }

  Future<void> _onLoadUserProfile(
    InspectorHomeLoadUserProfile event,
    Emitter<InspectorHomeState> emit,
  ) async {
    emit(const InspectorHomeLoading());
    final result = await _getInspectorProfileUseCase(NoParams());
    result.fold(
      (failure) => emit(InspectorHomeError(message: failure.message)),
      (profile) => emit(InspectorHomeLoaded(profile: profile)),
    );
  }

  Future<void> _onRefreshed(
    InspectorHomeRefreshed event,
    Emitter<InspectorHomeState> emit,
  ) async {
    if (state is InspectorHomeLoaded) {
      emit((state as InspectorHomeLoaded).copyWith(isRefreshing: true));
    }
    final result = await _getInspectorProfileUseCase(NoParams());
    result.fold(
      (failure) => emit(InspectorHomeError(message: failure.message)),
      (profile) => emit(InspectorHomeLoaded(profile: profile)),
    );
  }

  Future<void> _onLogout(
    InspectorHomeLogout event,
    Emitter<InspectorHomeState> emit,
  ) async {
    emit(const InspectorHomeLoggingOut());
    final result = await _logoutUseCase(NoParams());
    result.fold(
      (failure) => emit(InspectorHomeError(message: failure.message)),
      (_) => emit(const InspectorHomeLoggedOut()),
    );
  }
}

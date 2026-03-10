import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../auth/domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

/// HomeBloc — quản lý state cho trang Home
/// Single Responsibility: chỉ xử lý home state
/// Dependency Inversion: phụ thuộc vào UseCases (abstractions)
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetUserProfileUseCase _getUserProfileUseCase;
  final LogoutUseCase _logoutUseCase;

  HomeBloc({
    required GetUserProfileUseCase getUserProfileUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _getUserProfileUseCase = getUserProfileUseCase,
        _logoutUseCase = logoutUseCase,
        super(const HomeInitial()) {
    on<HomeLoadUserProfile>(_onLoadUserProfile);
    on<HomeLogout>(_onLogout);
  }

  Future<void> _onLoadUserProfile(
    HomeLoadUserProfile event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());

    final result = await _getUserProfileUseCase(NoParams());

    result.fold(
      (failure) => emit(HomeError(message: failure.message)),
      (profile) => emit(HomeLoaded(profile: profile)),
    );
  }

  Future<void> _onLogout(
    HomeLogout event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoggingOut());

    final result = await _logoutUseCase(NoParams());

    result.fold(
      (failure) => emit(HomeError(message: failure.message)),
      (_) => emit(const HomeLoggedOut()),
    );
  }
}

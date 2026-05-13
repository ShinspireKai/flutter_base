import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/login_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

/// LoginBloc — Single Responsibility: chỉ xử lý login state
///
/// Flow:
///   LoginSubmitted → LoginLoading → LoginSuccess | LoginFailure
///   LoginPasswordVisibilityToggled → cập nhật UI state
///
/// Dependency Inversion: phụ thuộc vào LoginUseCase (abstraction)
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase _loginUseCase;

  LoginBloc({required LoginUseCase loginUseCase})
      : _loginUseCase = loginUseCase,
        super(const LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LoginReset>(_onLoginReset);
    on<LoginPasswordVisibilityToggled>(_onPasswordVisibilityToggled);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());

    final result = await _loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(LoginFailure(errorMessage: failure.message)),
      (user) => emit(LoginSuccess(user: user)),
    );
  }

  void _onLoginReset(LoginReset event, Emitter<LoginState> emit) {
    emit(const LoginInitial());
  }

  void _onPasswordVisibilityToggled(
    LoginPasswordVisibilityToggled event,
    Emitter<LoginState> emit,
  ) {
    // Chỉ toggle khi đang ở LoginInitial (không toggle lúc loading)
    final current = state;
    if (current is LoginInitial) {
      emit(current.copyWith(isPasswordVisible: !current.isPasswordVisible));
    }
  }
}

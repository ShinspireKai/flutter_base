import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/biometric_auth_service.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/biometric_login_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

/// LoginBloc — Single Responsibility: chỉ xử lý login state
///
/// Flow:
///   LoginSubmitted            → LoginLoading → LoginSuccess | LoginFailure
///   LoginBiometricRequested   → LoginLoading → LoginSuccess | LoginFailure
///   LoginPasswordVisibilityToggled → cập nhật UI state
///
/// Dependency Inversion: phụ thuộc vào LoginUseCase/BiometricLoginUseCase (abstraction)
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase _loginUseCase;
  final BiometricLoginUseCase _biometricLoginUseCase;
  final BiometricAuthService _biometricAuthService;

  LoginBloc({
    required LoginUseCase loginUseCase,
    required BiometricLoginUseCase biometricLoginUseCase,
    required BiometricAuthService biometricAuthService,
  })  : _loginUseCase = loginUseCase,
        _biometricLoginUseCase = biometricLoginUseCase,
        _biometricAuthService = biometricAuthService,
        super(const LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LoginReset>(_onLoginReset);
    on<LoginPasswordVisibilityToggled>(_onPasswordVisibilityToggled);
    on<LoginBiometricAvailabilityChecked>(_onBiometricAvailabilityChecked);
    on<LoginBiometricRequested>(_onBiometricRequested);

    add(const LoginBiometricAvailabilityChecked());
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());

    final result = await _loginUseCase(
      LoginParams(
        email: event.email,
        password: event.password,
        rememberMe: event.rememberMe,
      ),
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

  Future<void> _onBiometricAvailabilityChecked(
    LoginBiometricAvailabilityChecked event,
    Emitter<LoginState> emit,
  ) async {
    final isAvailable = await _biometricAuthService.isAvailable;
    final current = state;
    if (current is LoginInitial) {
      emit(current.copyWith(isBiometricAvailable: isAvailable));
    }
  }

  Future<void> _onBiometricRequested(
    LoginBiometricRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());

    final authenticated = await _biometricAuthService.authenticate(
      reason: event.reason,
    );
    if (!authenticated) {
      emit(LoginFailure(errorMessage: event.failureMessage));
      return;
    }

    final result = await _biometricLoginUseCase(NoParams());
    result.fold(
      (failure) => emit(LoginFailure(errorMessage: failure.message)),
      (user) => emit(LoginSuccess(user: user)),
    );
  }
}

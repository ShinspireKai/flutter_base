import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';

/// Login States
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

/// Trạng thái ban đầu — giữ UI state (isPasswordVisible, isBiometricAvailable)
class LoginInitial extends LoginState {
  final bool isPasswordVisible;
  final bool isBiometricAvailable;

  const LoginInitial({
    this.isPasswordVisible = false,
    this.isBiometricAvailable = false,
  });

  LoginInitial copyWith({bool? isPasswordVisible, bool? isBiometricAvailable}) {
    return LoginInitial(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isBiometricAvailable: isBiometricAvailable ?? this.isBiometricAvailable,
    );
  }

  @override
  List<Object?> get props => [isPasswordVisible, isBiometricAvailable];
}

/// Đang gọi API
class LoginLoading extends LoginState {
  const LoginLoading();
}

/// Login thành công
class LoginSuccess extends LoginState {
  final UserEntity user;

  const LoginSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Login thất bại
class LoginFailure extends LoginState {
  final String errorMessage;

  const LoginFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

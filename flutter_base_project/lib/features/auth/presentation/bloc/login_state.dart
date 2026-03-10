import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';

/// States cho LoginBloc
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

/// Trạng thái ban đầu
class LoginInitial extends LoginState {
  final bool isPasswordVisible;
  const LoginInitial({this.isPasswordVisible = false});

  @override
  List<Object?> get props => [isPasswordVisible];
}

/// Đang xử lý login
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

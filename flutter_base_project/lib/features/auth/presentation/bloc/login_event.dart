import 'package:equatable/equatable.dart';

/// Events cho LoginBloc
/// Open/Closed: thêm event mới không cần sửa BLoC handler logic cũ
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

/// Event khi user nhấn nút login
class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;

  const LoginSubmitted({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

/// Event reset về trạng thái ban đầu
class LoginReset extends LoginEvent {
  const LoginReset();
}

/// Event toggle show/hide password
class LoginPasswordVisibilityToggled extends LoginEvent {
  const LoginPasswordVisibilityToggled();
}

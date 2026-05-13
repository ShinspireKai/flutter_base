import 'package:equatable/equatable.dart';

/// Login Events — Open/Closed: thêm event mới không sửa handler cũ
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

/// User nhấn nút đăng nhập
class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;

  const LoginSubmitted({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

/// Reset về trạng thái ban đầu (sau khi xử lý error/success)
class LoginReset extends LoginEvent {
  const LoginReset();
}

/// Toggle hiển thị mật khẩu
class LoginPasswordVisibilityToggled extends LoginEvent {
  const LoginPasswordVisibilityToggled();
}

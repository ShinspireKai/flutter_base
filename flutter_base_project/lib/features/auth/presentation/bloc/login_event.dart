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
  final bool rememberMe;

  const LoginSubmitted({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  @override
  List<Object?> get props => [email, password, rememberMe];
}

/// Reset về trạng thái ban đầu (sau khi xử lý error/success)
class LoginReset extends LoginEvent {
  const LoginReset();
}

/// Toggle hiển thị mật khẩu
class LoginPasswordVisibilityToggled extends LoginEvent {
  const LoginPasswordVisibilityToggled();
}

/// Kiểm tra thiết bị có hỗ trợ sinh trắc học không (gọi 1 lần khi bloc khởi tạo)
class LoginBiometricAvailabilityChecked extends LoginEvent {
  const LoginBiometricAvailabilityChecked();
}

/// User nhấn nút đăng nhập bằng sinh trắc học
///
/// [reason] và [failureMessage] được truyền từ View (nơi có BuildContext
/// để lấy chuỗi đã bản địa hoá) — BLoC không phụ thuộc trực tiếp vào
/// AppLocalizations.
class LoginBiometricRequested extends LoginEvent {
  final String reason;
  final String failureMessage;

  const LoginBiometricRequested({
    required this.reason,
    required this.failureMessage,
  });

  @override
  List<Object?> get props => [reason, failureMessage];
}

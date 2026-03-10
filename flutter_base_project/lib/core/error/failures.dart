import 'package:equatable/equatable.dart';

/// Abstract Failure class — Open/Closed Principle
/// Mở rộng bằng cách tạo subclass, không sửa class gốc
abstract class Failure extends Equatable {
  final String message;
  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Lỗi từ phía server
class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

/// Lỗi mạng (không có internet)
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

/// Lỗi khi đọc/ghi local cache
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// Lỗi xác thực (sai thông tin đăng nhập)
class AuthFailure extends Failure {
  const AuthFailure({required super.message});
}

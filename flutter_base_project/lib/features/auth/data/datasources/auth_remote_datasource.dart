import '../models/user_model.dart';

/// Abstract interface — Interface Segregation: chỉ expose remote auth operations
abstract class AuthRemoteDataSource {
  /// Đăng nhập qua API
  Future<UserModel> login({required String email, required String password});
}

/// Mock implementation — thay bằng ApiService call thực tế
///
/// Demo credentials: test@example.com / password123
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // Inject ApiService khi dùng thực tế:
  // final ApiService _apiService;
  // AuthRemoteDataSourceImpl(this._apiService);

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    // Simulate network latency
    await Future.delayed(const Duration(milliseconds: 1500));

    if (email == 'test@example.com' && password == 'password123') {
      return UserModel(
        id: 'usr_001',
        email: email,
        name: 'Nguyễn Văn A',
        token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        avatarUrl: null,
        role: 'user',
      );
    }

    // Ném exception — Repository sẽ catch và map thành Failure
    throw Exception('Sai email hoặc mật khẩu. Vui lòng thử lại.');
  }
}

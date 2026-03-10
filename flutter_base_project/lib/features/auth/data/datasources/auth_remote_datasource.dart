import '../models/user_model.dart';

/// Abstract interface cho remote auth data source
/// Interface Segregation Principle: chỉ expose methods cần thiết
abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
}

/// Mock implementation — trong thực tế sẽ gọi ApiService
/// Demo: email: test@example.com, password: password123
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // final ApiService _apiService;
  // AuthRemoteDataSourceImpl(this._apiService);

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1500));

    // Mock credentials validation
    if (email == 'test@example.com' && password == 'password123') {
      return UserModel(
        id: 'usr_001',
        email: email,
        name: 'Nguyễn Văn A',
        token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        avatarUrl: null,
      );
    }

    throw Exception('Sai email hoặc mật khẩu');
  }
}

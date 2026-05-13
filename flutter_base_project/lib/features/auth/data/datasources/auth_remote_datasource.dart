import '../../../../core/network/dio_base.dart';
import '../models/user_model.dart';

/// Abstract interface — Interface Segregation
abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
}

// ─────────────────────────────────────────────────────────────────────────────
/// AuthRemoteDataSourceImpl — Demo dùng DioBase trực tiếp
///
/// Cách 1: Gọi qua convenience methods (có loading overlay tự động)
///   final response = await dio.post('auth/login', data: {...});
///
/// Cách 2: Gọi raw Dio (không có loading overlay — tự quản lý)
///   final response = await dio.dio.post('auth/login', data: {...});
///
/// Trong project thực tế, thay mock data bằng API call thật:
///   - Đổi Constants.BASE_URL sang endpoint thật
///   - Parse response.data theo cấu trúc API
// ─────────────────────────────────────────────────────────────────────────────
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioBase _dio;

  /// DioBase được inject từ ngoài vào (qua Repository hoặc DI)
  AuthRemoteDataSourceImpl({required DioBase dio}) : _dio = dio;

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    // ── Gọi API thật (bỏ comment khi có backend) ─────────────────────────
    // final response = await _dio.post(
    //   'auth/login',
    //   data: {'email': email, 'password': password},
    // );
    //
    // if (response == null) {
    //   throw Exception('Không thể kết nối đến máy chủ');
    // }
    //
    // // Kiểm tra status code từ API (nếu API trả về code trong body)
    // final body = response.data as Map<String, dynamic>;
    // if (response.statusCode != 200) {
    //   throw Exception(body['message'] ?? 'Đăng nhập thất bại');
    // }
    //
    // return UserModel.fromJson(body['data']);

    // ── Mock data — xoá khi có API thật ──────────────────────────────────
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

    throw Exception('Sai email hoặc mật khẩu. Vui lòng thử lại.');
  }
}

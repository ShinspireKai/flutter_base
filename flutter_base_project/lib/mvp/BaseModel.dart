import '../core/network/dio_base.dart';
import 'IModel.dart';

/// BaseModel — nền tảng cho mọi Model trong MVP
///
/// Mỗi Model có sẵn [dio] (DioBase) được inject từ BasePresenter.
/// Dùng [dio] để gọi API trực tiếp bên trong Model:
///
/// ```dart
/// class AuthModel extends BaseModel {
///   Future<UserModel?> login(String email, String password) async {
///     final response = await dio.post(
///       'auth/login',
///       data: {'email': email, 'password': password},
///     );
///     if (response == null) return null;
///     return UserModel.fromJson(response.data['data']);
///   }
/// }
/// ```
///
/// Open/Closed: kế thừa để mở rộng, không cần sửa class này.
abstract class BaseModel implements IModel {
  /// DioBase được inject bởi BasePresenter khi attachView()
  late DioBase dio;

  @override
  void dispose() {}
}

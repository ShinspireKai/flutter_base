import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constans.dart';
import 'error_handle.dart';
import 'failure.dart';

// ─── Header keys ─────────────────────────────────────────────────────────────
const String kContentType  = 'content-type';
const String kAccept       = 'accept';
const String kAuthorization = 'authorization';
const String kLanguage     = 'language';
const String kApplicationJson = 'application/json';

// ─────────────────────────────────────────────────────────────────────────────
/// DioBase — Dio client được cấu hình sẵn cho toàn bộ project
///
/// Tích hợp:
/// - [BaseOptions]           : baseUrl, timeout, default headers
/// - [AuthInterceptor]       : tự động đính Bearer token mỗi request
/// - [RetryInterceptor]      : tự động retry khi network lỗi (tối đa 3 lần)
/// - [ErrorMappingInterceptor]: DioException → [Failure] có thể dùng với Either
/// - [PrettyDioLogger]       : log đẹp (chỉ debug mode)
///
/// Cách dùng trong Model:
/// ```dart
/// class AuthModel extends BaseModel {
///   Future<UserModel> login(String email, String password) async {
///     final response = await dio.post(
///       'auth/login',
///       data: {'email': email, 'password': password},
///     );
///     return UserModel.fromJson(response.data['data']);
///   }
/// }
/// ```
// ─────────────────────────────────────────────────────────────────────────────
class DioBase {
  late final Dio _dio;

  // Callback từ BasePresenter để hiện/ẩn loading overlay
  final void Function(bool isLoading) onLoading;

  // Callback từ BasePresenter khi có lỗi chưa được xử lý
  final void Function(Failure failure) onError;

  DioBase({
    required this.onLoading,
    required this.onError,
    String? baseUrl,
    Map<String, dynamic>? extraHeaders,
  }) {
    _dio = _buildDio(
      baseUrl: baseUrl ?? Constants.BASE_URL,
      extraHeaders: extraHeaders,
    );
  }

  /// Public getter — dùng trong Model để gọi API
  Dio get dio => _dio;

  // ─── Build ─────────────────────────────────────────────────────────────────

  Dio _buildDio({
    required String baseUrl,
    Map<String, dynamic>? extraHeaders,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: Constants.apiTimeOut),
        receiveTimeout: const Duration(seconds: Constants.apiTimeOut),
        sendTimeout: const Duration(seconds: Constants.apiTimeOut),
        headers: {
          kContentType: kApplicationJson,
          kAccept: kApplicationJson,
          kLanguage: 'vi',
          ...?extraHeaders,
        },
        // Không throw lỗi cho 4xx/5xx — để ErrorMappingInterceptor xử lý
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    // Thứ tự interceptor quan trọng: Auth → Retry → ErrorMapping → Logger
    dio.interceptors.addAll([
      AuthInterceptor(),
      RetryInterceptor(dio: dio),
      ErrorMappingInterceptor(onFailure: onError),
      if (!kReleaseMode)
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          compact: true,
          maxWidth: 120,
        ),
    ]);

    return dio;
  }

  // ─── Convenience methods — wrap loading state tự động ─────────────────────

  /// GET với loading overlay tự động
  Future<Response?> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _execute(() => _dio.get(
            path,
            queryParameters: queryParameters,
            options: options,
          ));

  /// POST với loading overlay tự động
  Future<Response?> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _execute(() => _dio.post(
            path,
            data: data,
            queryParameters: queryParameters,
            options: options,
          ));

  /// PUT với loading overlay tự động
  Future<Response?> put(
    String path, {
    dynamic data,
    Options? options,
  }) =>
      _execute(() => _dio.put(path, data: data, options: options));

  /// PATCH với loading overlay tự động
  Future<Response?> patch(
    String path, {
    dynamic data,
    Options? options,
  }) =>
      _execute(() => _dio.patch(path, data: data, options: options));

  /// DELETE với loading overlay tự động
  Future<Response?> delete(
    String path, {
    dynamic data,
    Options? options,
  }) =>
      _execute(() => _dio.delete(path, data: data, options: options));

  /// Upload file (multipart/form-data)
  Future<Response?> upload(
    String path, {
    required FormData formData,
    void Function(int sent, int total)? onSendProgress,
    Options? options,
  }) =>
      _execute(() => _dio.post(
            path,
            data: formData,
            onSendProgress: onSendProgress,
            options: options ??
                Options(contentType: 'multipart/form-data'),
          ));

  // ─── Internal executor — tự động gắn loading state ────────────────────────

  Future<Response?> _execute(Future<Response> Function() request) async {
    try {
      onLoading(true);
      return await request();
    } on DioException catch (e) {
      // ErrorMappingInterceptor đã xử lý → chỉ cần return null
      // Nếu interceptor chưa kịp xử lý (cancelled,...) thì handle ở đây
      if (e.type == DioExceptionType.cancel) return null;
      final failure = ErrorHandler.handle(e).failure;
      onError(Failure(failure.code, failure.message));
      return null;
    } finally {
      onLoading(false);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
/// AuthInterceptor — tự động đính Bearer token vào mỗi request
///
/// - Đọc token từ SharedPreferences (sync với DioFactory)
/// - Nếu response 401 → xoá token (force logout)
// ─────────────────────────────────────────────────────────────────────────────
class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('_access_token') ?? '';
    if (token.isNotEmpty) {
      options.headers[kAuthorization] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('_access_token');
    }
    return handler.next(err);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
/// RetryInterceptor — tự động retry khi gặp lỗi network (không phải 4xx/5xx)
///
/// - Retry tối đa [maxRetries] lần (mặc định: 3)
/// - Chờ [retryDelay] trước mỗi lần retry (mặc định: 1 giây)
/// - Chỉ retry các lỗi network, timeout — không retry lỗi API (4xx/5xx)
// ─────────────────────────────────────────────────────────────────────────────
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration retryDelay;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;

    final shouldRetry = _isNetworkError(err.type) && retryCount < maxRetries;

    if (shouldRetry) {
      err.requestOptions.extra['retryCount'] = retryCount + 1;

      await Future.delayed(retryDelay * (retryCount + 1)); // exponential backoff

      try {
        final response = await dio.fetch(err.requestOptions);
        return handler.resolve(response);
      } catch (e) {
        return handler.next(err);
      }
    }

    return handler.next(err);
  }

  bool _isNetworkError(DioExceptionType type) {
    return type == DioExceptionType.connectionTimeout ||
        type == DioExceptionType.receiveTimeout ||
        type == DioExceptionType.sendTimeout ||
        type == DioExceptionType.connectionError;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
/// ErrorMappingInterceptor — map DioException → Failure và gọi onError callback
///
/// Cho phép Model/Presenter xử lý lỗi theo kiểu functional (Either)
/// mà không cần try/catch ở mọi chỗ.
// ─────────────────────────────────────────────────────────────────────────────
class ErrorMappingInterceptor extends Interceptor {
  final void Function(Failure failure) onFailure;

  ErrorMappingInterceptor({required this.onFailure});

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Map lỗi từ status code (4xx mà validateStatus cho qua)
    final statusCode = response.statusCode ?? 0;
    if (statusCode >= 400 && statusCode < 500) {
      final message = _extractMessage(response.data) ??
          _messageForCode(statusCode);
      onFailure(Failure(statusCode, message));
    }
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final failure = ErrorHandler.handle(err).failure;
    onFailure(Failure(failure.code, failure.message));
    return handler.next(err);
  }

  String? _extractMessage(dynamic data) {
    try {
      if (data is Map) {
        return data['message']?.toString() ??
            data['error']?.toString() ??
            data['msg']?.toString();
      }
    } catch (_) {}
    return null;
  }

  String _messageForCode(int code) {
    switch (code) {
      case 400: return 'Yêu cầu không hợp lệ';
      case 401: return 'Phiên đăng nhập hết hạn';
      case 403: return 'Không có quyền truy cập';
      case 404: return 'Không tìm thấy tài nguyên';
      case 422: return 'Dữ liệu không hợp lệ';
      case 429: return 'Quá nhiều yêu cầu, vui lòng thử lại';
      default:  return 'Đã có lỗi xảy ra (HTTP $code)';
    }
  }
}

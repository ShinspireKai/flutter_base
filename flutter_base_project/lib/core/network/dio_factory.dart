import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constans.dart';

const String applicationJson = 'application/json';
const String contentType = 'content-type';
const String accept = 'accept';
const String authorization = 'authorization';
const String defaultLanguage = 'language';

/// DioFactory — khởi tạo Dio với đầy đủ config
///
/// Features:
/// - Base headers (content-type, accept, language)
/// - Timeout config
/// - Auth token interceptor (tự động đính token từ SharedPreferences)
/// - Pretty logging (chỉ ở debug mode)
/// - 401 auto-clear token interceptor
@lazySingleton
class DioFactory {
  Dio? _dio;

  Dio get dio {
    _dio ??= _buildDio();
    return _dio!;
  }

  Dio _buildDio() {
    final dio = Dio();

    dio.options = BaseOptions(
      baseUrl: Constants.BASE_URL,
      connectTimeout: const Duration(seconds: Constants.apiTimeOut),
      receiveTimeout: const Duration(seconds: Constants.apiTimeOut),
      sendTimeout: const Duration(seconds: Constants.apiTimeOut),
      headers: {
        contentType: applicationJson,
        accept: applicationJson,
        defaultLanguage: 'vi',
      },
    );

    // Auth Token Interceptor — tự động đính Bearer token
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('_access_token') ?? '';
          if (token.isNotEmpty) {
            options.headers[authorization] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          // Nếu 401 → xoá token (logout tự động nếu cần)
          if (error.response?.statusCode == 401) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('_access_token');
          }
          return handler.next(error);
        },
      ),
    );

    // Pretty logger — chỉ bật ở debug
    if (!kReleaseMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          compact: true,
        ),
      );
    }

    return dio;
  }
}

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'dio_factory.dart';

/// ApiService — wrapper cho Dio HTTP client
///
/// Single Responsibility: chỉ thực hiện HTTP calls
/// Dependency Inversion: inject DioFactory qua constructor
@singleton
class ApiService {
  final Dio _dio;

  // DioFactory được GetIt inject tự động
  ApiService(DioFactory dioFactory) : _dio = dioFactory.dio;

  /// GET request
  Future<Response> get({
    required String endPoint,
    Map<String, dynamic>? params,
  }) async {
    return _dio.get(endPoint, queryParameters: params);
  }

  /// POST request
  Future<Response> post({
    required String endPoint,
    dynamic data,
    Map<String, dynamic>? params,
  }) async {
    return _dio.post(endPoint, data: data, queryParameters: params);
  }

  /// PUT request
  Future<Response> put({
    required String endPoint,
    dynamic data,
  }) async {
    return _dio.put(endPoint, data: data);
  }

  /// PATCH request
  Future<Response> patch({
    required String endPoint,
    dynamic data,
  }) async {
    return _dio.patch(endPoint, data: data);
  }

  /// DELETE request
  Future<Response> delete({
    required String endPoint,
    dynamic data,
  }) async {
    return _dio.delete(endPoint, data: data);
  }
}

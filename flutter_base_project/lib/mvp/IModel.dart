import 'package:dio/dio.dart';

/// Interface cho Model trong MVP pattern
/// Model chịu trách nhiệm xử lý data + business logic ở tầng thấp
abstract class IModel {
  void dispose();
}

/// Helper class cho HTTP requests trong Model
/// Tách biệt loading/error handling khỏi business logic
class HttpBase {
  final void Function(bool isLoading) onLoading;
  final void Function(dynamic error) onError;
  final Dio? dio;

  HttpBase({
    required this.onLoading,
    required this.onError,
    this.dio,
  });

  /// Thực thi một request với loading state tự động
  Future<T?> execute<T>(Future<T> Function() request) async {
    try {
      onLoading(true);
      final result = await request();
      return result;
    } catch (e) {
      onError(e);
      return null;
    } finally {
      onLoading(false);
    }
  }
}

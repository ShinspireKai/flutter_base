import 'package:dio/dio.dart';

import 'failure.dart';

/// ErrorHandler — map DioException → Failure
/// Không còn phụ thuộc vào navigatorKey hay context
class ErrorHandler implements Exception {
  late Failure failure;

  ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      failure = _handleDioError(error);
    } else {
      failure = DataSource.DEFAULT.getFailure();
    }
  }
}

Failure _handleDioError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      return DataSource.CONNECT_TIMEOUT.getFailure();
    case DioExceptionType.sendTimeout:
      return DataSource.SEND_TIMEOUT.getFailure();
    case DioExceptionType.receiveTimeout:
      return DataSource.RECIEVE_TIMEOUT.getFailure();
    case DioExceptionType.badResponse:
      final statusCode = error.response?.statusCode ?? 0;
      final message = _extractMessage(error.response?.data) ?? _messageForCode(statusCode);
      return Failure(statusCode, message);
    case DioExceptionType.cancel:
      return DataSource.CANCEL.getFailure();
    default:
      return DataSource.DEFAULT.getFailure();
  }
}

String? _extractMessage(dynamic data) {
  try {
    if (data is Map) return data['message']?.toString();
  } catch (_) {}
  return null;
}

String _messageForCode(int code) {
  switch (code) {
    case ResponseCode.UNAUTORISED: return 'Không có quyền truy cập';
    case ResponseCode.FORBIDDEN: return 'Bị từ chối truy cập';
    case ResponseCode.NOT_FOUND: return 'Không tìm thấy tài nguyên';
    case ResponseCode.INTERNAL_SERVER_ERROR: return 'Lỗi máy chủ';
    default: return 'Đã có lỗi xảy ra';
  }
}

enum DataSource {
  SUCCESS,
  NO_CONTENT,
  BAD_REQUEST,
  FORBIDDEN,
  UNAUTORISED,
  NOT_FOUND,
  INTERNAL_SERVER_ERROR,
  CONNECT_TIMEOUT,
  CANCEL,
  RECIEVE_TIMEOUT,
  SEND_TIMEOUT,
  CACHE_ERROR,
  NO_INTERNET_CONNECTION,
  DEFAULT
}

extension DataSourceExtension on DataSource {
  Failure getFailure() {
    switch (this) {
      case DataSource.SUCCESS:
        return Failure(ResponseCode.SUCCESS, 'Thành công');
      case DataSource.NO_CONTENT:
        return Failure(ResponseCode.NO_CONTENT, 'Không có dữ liệu');
      case DataSource.BAD_REQUEST:
        return Failure(ResponseCode.BAD_REQUEST, 'Yêu cầu không hợp lệ');
      case DataSource.FORBIDDEN:
        return Failure(ResponseCode.FORBIDDEN, 'Bị từ chối truy cập');
      case DataSource.UNAUTORISED:
        return Failure(ResponseCode.UNAUTORISED, 'Không có quyền truy cập');
      case DataSource.NOT_FOUND:
        return Failure(ResponseCode.NOT_FOUND, 'Không tìm thấy tài nguyên');
      case DataSource.INTERNAL_SERVER_ERROR:
        return Failure(ResponseCode.INTERNAL_SERVER_ERROR, 'Lỗi máy chủ');
      case DataSource.CONNECT_TIMEOUT:
        return Failure(ResponseCode.CONNECT_TIMEOUT, 'Kết nối bị timeout');
      case DataSource.CANCEL:
        return Failure(ResponseCode.CANCEL, 'Yêu cầu bị huỷ');
      case DataSource.RECIEVE_TIMEOUT:
        return Failure(ResponseCode.RECIEVE_TIMEOUT, 'Nhận dữ liệu bị timeout');
      case DataSource.SEND_TIMEOUT:
        return Failure(ResponseCode.SEND_TIMEOUT, 'Gửi dữ liệu bị timeout');
      case DataSource.CACHE_ERROR:
        return Failure(ResponseCode.CACHE_ERROR, 'Lỗi đọc/ghi cache');
      case DataSource.NO_INTERNET_CONNECTION:
        return Failure(ResponseCode.NO_INTERNET_CONNECTION, 'Không có kết nối mạng');
      case DataSource.DEFAULT:
        return Failure(ResponseCode.DEFAULT, 'Đã có lỗi xảy ra');
    }
  }
}

class ResponseCode {
  static const int SUCCESS = 200;
  static const int NO_CONTENT = 201;
  static const int BAD_REQUEST = 400;
  static const int UNAUTORISED = 401;
  static const int FORBIDDEN = 403;
  static const int NOT_FOUND = 404;
  static const int INTERNAL_SERVER_ERROR = 500;

  // Local codes
  static const int CONNECT_TIMEOUT = -1;
  static const int CANCEL = -2;
  static const int RECIEVE_TIMEOUT = -3;
  static const int SEND_TIMEOUT = -4;
  static const int CACHE_ERROR = -5;
  static const int NO_INTERNET_CONNECTION = -6;
  static const int DEFAULT = -7;
}

class ApiInternalStatus {
  static const int SUCCESS = 200;
  static const int FAILURE = 400;
}

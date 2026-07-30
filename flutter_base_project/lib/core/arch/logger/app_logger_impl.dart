import 'package:logger/logger.dart';

/// Logger dùng chung toàn app — bọc package:logger để chuẩn hóa 1 điểm gọi
/// duy nhất (vd RouterLoggingObserver) thay vì mỗi nơi tự tạo Logger() riêng.
final Logger logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 100,
    colors: true,
    printEmojis: true,
  ),
);

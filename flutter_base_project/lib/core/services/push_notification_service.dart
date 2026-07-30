import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../arch/logger/app_logger_impl.dart';
import '../local/local_storage.dart';
import 'local_notification_service.dart';

/// PushNotificationService — bọc [FirebaseMessaging] của plugin
/// `firebase_messaging`
///
/// Single Responsibility: xin quyền nhận thông báo đẩy, đồng bộ FCM token
/// (lưu qua [LocalStorage]) và lắng nghe tin nhắn đến — không biết gì về
/// bloc hay màn hình cụ thể. Khi app đang mở (foreground), FCM không tự
/// hiện thông báo hệ thống nên chuyển sang [LocalNotificationService] để hiện.
abstract class PushNotificationService {
  /// Xin quyền + đồng bộ token + đăng ký lắng nghe tin nhắn (gọi 1 lần lúc
  /// app khởi động, sau khi LocalNotificationService đã init xong)
  Future<void> init();
}

class PushNotificationServiceImpl implements PushNotificationService {
  final FirebaseMessaging _messaging;
  final LocalStorage _localStorage;
  final LocalNotificationService _localNotificationService;

  PushNotificationServiceImpl({
    required LocalStorage localStorage,
    required LocalNotificationService localNotificationService,
    FirebaseMessaging? messaging,
  }) : _localStorage = localStorage,
       _localNotificationService = localNotificationService,
       _messaging = messaging ?? FirebaseMessaging.instance;

  @override
  Future<void> init() async {
    // Từng bước bọc try/catch riêng — lỗi lấy token (vd chưa có APNs token
    // trên Simulator) không được phép chặn việc đăng ký các listener bên dưới.
    try {
      await _requestPermission();
    } catch (e, stackTrace) {
      logger.e('PushNotificationService: requestPermission failed', error: e, stackTrace: stackTrace);
    }

    try {
      await _syncToken();
    } catch (e, stackTrace) {
      logger.e('PushNotificationService: syncToken failed', error: e, stackTrace: stackTrace);
    }

    _messaging.onTokenRefresh.listen(_localStorage.setFCMToken);
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    try {
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) _onMessageOpenedApp(initialMessage);
    } catch (e, stackTrace) {
      logger.e('PushNotificationService: getInitialMessage failed', error: e, stackTrace: stackTrace);
    }
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    logger.i('FCM permission status: ${settings.authorizationStatus}');
  }

  Future<void> _syncToken() async {
    // iOS/macOS: FCM cần APNs token trước, token này do OS gửi bất đồng bộ
    // sau khi xin quyền — Simulator (đa số) không nhận được token này bao giờ.
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      final apnsToken = await _waitForApnsToken();
      if (apnsToken == null) {
        logger.w(
          'APNS token chưa sẵn sàng (thường gặp trên Simulator) — bỏ qua '
          'đồng bộ FCM token lần này, sẽ tự cập nhật qua onTokenRefresh khi có.',
        );
        return;
      }
    }

    final token = await _messaging.getToken();
    if (token != null) {
      await _localStorage.setFCMToken(token);
      logger.i('FCM token synced: $token');
    }
  }

  /// Thử chờ APNs token tối đa vài giây — trả về null nếu vẫn chưa có
  /// (vd Simulator không hỗ trợ push thật) thay vì để getToken() ném lỗi.
  Future<String?> _waitForApnsToken() async {
    var apnsToken = await _messaging.getAPNSToken();
    var attempts = 0;
    while (apnsToken == null && attempts < 5) {
      await Future.delayed(const Duration(seconds: 1));
      apnsToken = await _messaging.getAPNSToken();
      attempts++;
    }
    return apnsToken;
  }

  /// Tin nhắn đến khi app đang mở — FCM không tự hiện thông báo hệ thống
  /// trong trường hợp này nên phải tự hiện qua LocalNotificationService
  void _onForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;
    _localNotificationService.show(
      id: message.hashCode,
      title: notification.title ?? '',
      body: notification.body ?? '',
      payload: message.data['route'] as String?,
    );
  }

  /// User bấm vào thông báo (từ background hoặc lúc app đã bị kill và mở lại)
  void _onMessageOpenedApp(RemoteMessage message) {
    logger.i('Notification tapped, data: ${message.data}');
    // TODO: điều hướng theo message.data (vd route tới đúng nhiệm vụ/phiếu)
    // khi có nhu cầu thực tế — hiện tại chỉ log để xác nhận luồng hoạt động.
  }
}

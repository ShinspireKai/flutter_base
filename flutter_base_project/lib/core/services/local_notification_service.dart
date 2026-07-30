import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../arch/logger/app_logger_impl.dart';
import '../l10n/app_localizations.dart';

/// LocalNotificationService — bọc [FlutterLocalNotificationsPlugin] của
/// plugin `flutter_local_notifications`
///
/// Single Responsibility: chỉ lo việc khởi tạo kênh thông báo và hiển thị
/// 1 thông báo cục bộ trên thiết bị — không biết gì về FCM hay bloc.
/// PushNotificationService dùng service này để hiển thị thông báo khi có
/// tin nhắn FCM đến lúc app đang mở (foreground) — FCM không tự hiện
/// thông báo hệ thống trong trường hợp đó.
abstract class LocalNotificationService {
  /// Khởi tạo plugin + tạo kênh thông báo mặc định (gọi 1 lần lúc app khởi động)
  Future<void> init();

  /// Hiển thị 1 thông báo cục bộ
  Future<void> show({
    required int id,
    required String title,
    required String body,
    String? payload,
  });
}

class LocalNotificationServiceImpl implements LocalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const _channelId = 'default_channel';

  // App khoá cứng locale 'zh' (xem MaterialApp.locale trong main.dart) nên
  // tra thẳng bằng lookupAppLocalizations thay vì cần BuildContext — service
  // này chạy trước khi widget tree được build.
  static final _l10n = lookupAppLocalizations(const Locale('zh'));
  static String get _channelName => _l10n.notificationChannelName;
  static String get _channelDescription => _l10n.notificationChannelDescription;

  @override
  Future<void> init() async {
    try {
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );
      const settings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );
      await _plugin.initialize(settings: settings);

      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(
            AndroidNotificationChannel(
              _channelId,
              _channelName,
              description: _channelDescription,
              importance: Importance.high,
            ),
          );
    } catch (e, stackTrace) {
      logger.e('LocalNotificationService.init failed', error: e, stackTrace: stackTrace);
    }
  }

  @override
  Future<void> show({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      final androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
      );
      const iosDetails = DarwinNotificationDetails();
      final details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );
      await _plugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: details,
        payload: payload,
      );
    } catch (e, stackTrace) {
      logger.e('LocalNotificationService.show failed', error: e, stackTrace: stackTrace);
    }
  }
}

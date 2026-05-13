/// App-wide constants
/// Tập trung tất cả magic strings và config values vào một nơi
class Constants {
  Constants._();

  // ─── API ────────────────────────────────────────────────────────────────
  static const String BASE_URL = 'https://api.example.com/';
  static const int apiTimeOut = 30; // seconds

  // ─── Auth ───────────────────────────────────────────────────────────────
  static const String token = '';

  // ─── App info ───────────────────────────────────────────────────────────
  static const String appName = 'Flutter Base';
  static const String appVersion = '1.0.0';
}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── SharedPreferences keys ───────────────────────────────────────────────
const String keyLanguageCode = '_languageCode';
const String keyFirstUserApp = '_firstUseApp';
const String keyAccessToken = '_access_token';
const String keyRefreshToken = '_refresh_token';
const String keyUserId = '_userId';
const String keyFCMToken = '_fcmToken';

/// Abstract interface cho LocalStorage
/// Dependency Inversion: tầng trên phụ thuộc vào interface này
abstract class LocalStorage {
  // ─── Auth ─────────────────────────────────────────────────────────────
  Future<void> saveAccessToken(String token);
  Future<void> saveRefreshToken(String token);
  Future<void> saveUserId(String userId);
  String get accessToken;
  String get refreshToken;
  String get userId;
  bool get isLoggedIn;

  // ─── App ──────────────────────────────────────────────────────────────
  Future<void> cacheLanguageCode(String language);
  String get languageCode;

  // ─── FCM ──────────────────────────────────────────────────────────────
  Future<void> setFCMToken(String fcmToken);
  String get fcmToken;

  // ─── Lifecycle ────────────────────────────────────────────────────────
  Future<void> clearAuthData();
  Future<void> clearAll();
}

@Injectable(as: LocalStorage)
class LocalStorageImpl extends LocalStorage {
  late SharedPreferences _sharedPreferences;
  late FlutterSecureStorage _secureStorage;

  LocalStorageImpl();

  @PostConstruct(preResolve: true)
  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _secureStorage = const FlutterSecureStorage();

    // Xoá secure storage khi app cài lần đầu (tránh stale token sau reinstall)
    final isFirstUse = _sharedPreferences.getBool(keyFirstUserApp) ?? false;
    if (!isFirstUse) {
      await _secureStorage.deleteAll();
      await _sharedPreferences.setBool(keyFirstUserApp, true);
    }
  }

  // ─── Auth ───────────────────────────────────────────────────────────────

  @override
  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: keyAccessToken, value: token);
    // Cũng lưu vào SharedPreferences cho DioFactory đọc đồng bộ
    await _sharedPreferences.setString(keyAccessToken, token);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: keyRefreshToken, value: token);
  }

  @override
  Future<void> saveUserId(String userId) async {
    await _sharedPreferences.setString(keyUserId, userId);
  }

  @override
  String get accessToken => _sharedPreferences.getString(keyAccessToken) ?? '';

  @override
  String get refreshToken =>
      _sharedPreferences.getString(keyRefreshToken) ?? '';

  @override
  String get userId => _sharedPreferences.getString(keyUserId) ?? '';

  @override
  bool get isLoggedIn => accessToken.isNotEmpty;

  // ─── App ────────────────────────────────────────────────────────────────

  @override
  Future<void> cacheLanguageCode(String language) async {
    await _sharedPreferences.setString(keyLanguageCode, language);
  }

  @override
  String get languageCode =>
      _sharedPreferences.getString(keyLanguageCode) ?? 'vi';

  // ─── FCM ────────────────────────────────────────────────────────────────

  @override
  Future<void> setFCMToken(String fcmToken) async {
    await _sharedPreferences.setString(keyFCMToken, fcmToken);
  }

  @override
  String get fcmToken => _sharedPreferences.getString(keyFCMToken) ?? '';

  // ─── Lifecycle ──────────────────────────────────────────────────────────

  @override
  Future<void> clearAuthData() async {
    await _sharedPreferences.remove(keyAccessToken);
    await _sharedPreferences.remove(keyRefreshToken);
    await _sharedPreferences.remove(keyUserId);
    await _secureStorage.delete(key: keyAccessToken);
    await _secureStorage.delete(key: keyRefreshToken);
  }

  @override
  Future<void> clearAll() async {
    await _sharedPreferences.clear();
    await _sharedPreferences.setBool(keyFirstUserApp, true);
    await _secureStorage.deleteAll();
  }
}

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

const String _keyUserData = '_cached_user_data';
const String _keyAccessToken = '_access_token';
const String _keyIsLoggedIn = '_is_logged_in';
const String _keyRememberMe = '_remember_me';

/// Abstract interface — Interface Segregation: chỉ expose local auth operations
abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();

  /// Lưu lựa chọn "Ghi nhớ đăng nhập" (记住我) của user tại lần login gần nhất
  Future<void> saveRememberMe(bool rememberMe);

  /// true chỉ khi đã login VÀ user có tick "Ghi nhớ đăng nhập"
  /// → dùng để quyết định có bỏ qua màn hình login khi mở lại app hay không
  Future<bool> isLoggedIn();
  Future<void> clearAuthData();
}

/// Implementation với SharedPreferences
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences _prefs;

  AuthLocalDataSourceImpl(this._prefs);

  @override
  Future<void> cacheUser(UserModel user) async {
    // Luôn lưu user + token — API interceptor (DioBase) đọc token từ đây
    // cho mọi request trong phiên hiện tại, bất kể có "Ghi nhớ đăng nhập" hay không.
    await _prefs.setString(_keyUserData, jsonEncode(user.toJson()));
    await _prefs.setString(_keyAccessToken, user.token);
    await _prefs.setBool(_keyIsLoggedIn, true);
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final jsonStr = _prefs.getString(_keyUserData);
    if (jsonStr == null) return null;
    return UserModel.fromJson(jsonDecode(jsonStr));
  }

  @override
  Future<void> saveRememberMe(bool rememberMe) async {
    await _prefs.setBool(_keyRememberMe, rememberMe);
  }

  @override
  Future<bool> isLoggedIn() async {
    final isLoggedIn = _prefs.getBool(_keyIsLoggedIn) ?? false;
    final rememberMe = _prefs.getBool(_keyRememberMe) ?? false;
    return isLoggedIn && rememberMe;
  }

  @override
  Future<void> clearAuthData() async {
    await _prefs.remove(_keyUserData);
    await _prefs.remove(_keyAccessToken);
    await _prefs.remove(_keyIsLoggedIn);
    await _prefs.remove(_keyRememberMe);
  }
}

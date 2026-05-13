import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

const String _keyUserData = '_cached_user_data';
const String _keyAccessToken = '_access_token';
const String _keyIsLoggedIn = '_is_logged_in';

/// Abstract interface — Interface Segregation: chỉ expose local auth operations
abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<bool> isLoggedIn();
  Future<void> clearAuthData();
}

/// Implementation với SharedPreferences
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences _prefs;

  AuthLocalDataSourceImpl(this._prefs);

  @override
  Future<void> cacheUser(UserModel user) async {
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
  Future<bool> isLoggedIn() async {
    return _prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  @override
  Future<void> clearAuthData() async {
    await _prefs.remove(_keyUserData);
    await _prefs.remove(_keyAccessToken);
    await _prefs.remove(_keyIsLoggedIn);
  }
}

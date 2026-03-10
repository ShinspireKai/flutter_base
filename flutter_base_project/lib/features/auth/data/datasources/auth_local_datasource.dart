import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

const String _keyUserData = '_cached_user_data';
const String _keyIsLoggedIn = '_is_logged_in';

/// Abstract interface cho local auth data source
abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<bool> isLoggedIn();
  Future<void> clearAuthData();
}

/// Implementation lưu user data vào SharedPreferences
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences _sharedPreferences;

  AuthLocalDataSourceImpl(this._sharedPreferences);

  @override
  Future<void> cacheUser(UserModel user) async {
    await _sharedPreferences.setString(
      _keyUserData,
      jsonEncode(user.toJson()),
    );
    await _sharedPreferences.setBool(_keyIsLoggedIn, true);
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final jsonString = _sharedPreferences.getString(_keyUserData);
    if (jsonString == null) return null;
    return UserModel.fromJson(jsonDecode(jsonString));
  }

  @override
  Future<bool> isLoggedIn() async {
    return _sharedPreferences.getBool(_keyIsLoggedIn) ?? false;
  }

  @override
  Future<void> clearAuthData() async {
    await _sharedPreferences.remove(_keyUserData);
    await _sharedPreferences.remove(_keyIsLoggedIn);
  }
}

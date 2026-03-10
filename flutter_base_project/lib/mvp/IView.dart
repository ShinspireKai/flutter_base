import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class IView {
  Future<dynamic> routePush(Widget page, {String routeName});
  void routePushAndRemoveUntil(Widget page, {String routeName});
  void showToast(String msg, {ToastGravity gravity});
  void showLoading();
  void hideLoading();
  Future<dynamic> showMsg(String msg, {int code = 1,  void Function() onFinish});
  void showCustomDialog(String title, String msg, Map<String, Function()> actions);
}

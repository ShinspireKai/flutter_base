import 'package:flutter/widgets.dart';

/// Interface cho View trong MVP pattern
/// Interface Segregation: chỉ khai báo những gì View cần expose cho Presenter
abstract class IView {
  void showLoading();
  void hideLoading();
  void showToast(String msg);
  Future<dynamic> showMsg(String? msg, {int code, void Function()? onFinish});
  Future<dynamic> routePush(Widget page, {String? routeName, Function()? action});
  void routePushAndRemoveUntil(Widget page, {String? routeName});
}

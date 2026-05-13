import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'IPresenter.dart';
import 'IView.dart';

/// BaseView — StatefulWidget gốc cho MVP pattern
abstract class BaseView extends StatefulWidget {
  const BaseView({super.key});
}

/// BaseViewState — State gốc implement IView
///
/// Cách dùng:
/// ```dart
/// class LoginPage extends BaseView {
///   const LoginPage({super.key});
///   @override
///   State<LoginPage> createState() => _LoginPageState();
/// }
///
/// class _LoginPageState extends BaseViewState<LoginPresenter, LoginPage>
///     implements ILoginView {
///   @override
///   LoginPresenter createPresenter() => LoginPresenter();
///
///   @override
///   Widget buildView(BuildContext context) => Scaffold(...);
/// }
/// ```
abstract class BaseViewState<P extends IPresenter, V extends BaseView>
    extends State<V> implements IView {
  P? _presenter;
  int _loadingCount = 0;

  P? get presenter => _presenter;

  @override
  void initState() {
    super.initState();
    _presenter = createPresenter();
    _presenter?.attachView(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      afterInit();
    });
  }

  /// Hook gọi sau khi frame đầu tiên render xong
  /// Dùng để load data lần đầu
  void afterInit() {}

  /// Subclass phải override để tạo Presenter tương ứng
  P createPresenter();

  @override
  void dispose() {
    _loadingCount = 0;
    EasyLoading.dismiss();
    _presenter?.detachView();
    _presenter = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => buildView(context);

  /// Override method này thay vì build() để tránh nhầm lẫn
  Widget buildView(BuildContext context);

  // ─── IView Implementation ───────────────────────────────────────────────

  @override
  void showLoading() {
    _loadingCount++;
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
  }

  @override
  void hideLoading() {
    if (_loadingCount > 0) _loadingCount--;
    if (_loadingCount == 0) EasyLoading.dismiss();
  }

  @override
  void showToast(String msg) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      fontSize: 16.0,
    );
  }

  @override
  Future<dynamic> showMsg(String? msg, {int code = 1, void Function()? onFinish}) {
    if (msg == null) return Future.value(null);

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          code < 0 ? 'Lỗi' : 'Thông báo',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onFinish?.call();
            },
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  @override
  Future<dynamic> routePush(
    Widget page, {
    String? routeName,
    Function()? action,
  }) {
    final result = Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => page,
        settings: RouteSettings(name: routeName),
      ),
    );
    if (action != null) result.whenComplete(action);
    return result;
  }

  @override
  void routePushAndRemoveUntil(Widget page, {String? routeName}) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => page,
        settings: RouteSettings(name: routeName),
      ),
      (route) => false,
    );
  }
}

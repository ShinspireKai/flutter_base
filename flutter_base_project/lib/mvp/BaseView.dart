import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:massageronsitetestingapp/config/MyConfig.dart';
import 'package:massageronsitetestingapp/module/dialog/MessageDialog.dart';
import 'IPresenter.dart';
import 'IView.dart';

abstract class BaseView extends StatefulWidget {}

abstract class BaseViewState<P extends IPresenter, V extends BaseView>
    extends State<V> implements IView {
  P? presenter;
  int _loadingCount = 0;

  @override
  void initState() {
    super.initState();
    presenter = createPresenter();
    presenter?.attachView(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      afterInit();
    });
  }

  void afterInit() {}

  P? createPresenter();

  P? getPresenter() {
    return presenter;
  }

  @override
  void dispose() {
    super.dispose();
    _loadingCount = 0;
    hideLoading();
    presenter?.detachView();
    presenter = null;
  }

  @override
  Future<dynamic> routePush(Widget page,
      {String? routeName, Function()? action}) {
    final instance = Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => page, settings: RouteSettings(name: routeName)));
    if (action != null) {
      instance.whenComplete(action);
    }
    return instance;
  }

  @override
  void routePushAndRemoveUntil(Widget page, {String? routeName}) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (_) => page, settings: RouteSettings(name: routeName)),
      (route) => route == null,
    );
  }

  @override
  void showToast(String msg, {ToastGravity gravity = ToastGravity.BOTTOM}) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: gravity,
        timeInSecForIosWeb: 1,
        fontSize: 16.0);
  }

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
  Future<dynamic> showMsg(String? msg,
      {int code = 1, void Function()? onFinish}) {
    String title = code < 0 ? "警告" : "提示";
    switch (code) {
      case -3:
        // if (!MyConfig.isDebug) {
        //   msg = "服务器存取发生问题";
        // }
        break;
      case 3:
        msg = null;
        break;
    }

    if (msg != null) {
      return showDialog(
          context: context,
          builder: (context) => MessageDialog(
                barrierDismissible: false,
                title: title,
                msg: msg!,
                buttons: [
                  MyDialogButton(
                      text: "确认",
                      onTap: () {
                        Navigator.of(context).pop();
                      })
                ],
              )).whenComplete(() {
        if (onFinish != null) {
          onFinish();
        }
      });
    } else {
      return Future.value(null);
    }
  }

  Future showCustomDialog(
      String title, String msg, Map<String, Function()> actions) {
    var buttons = <MyDialogButton>[];

    actions.entries.forEach((element) {
      buttons.add(MyDialogButton(text: element.key, onTap: element.value));
    });
    return showDialog(
        context: context,
        builder: (context) =>
            MessageDialog(title: title, msg: msg, buttons: buttons));
  }
}

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'BaseView.dart';
import 'IModel.dart';
import 'IPresenter.dart';
import 'IView.dart';

abstract class BasePresenter<V extends IView, M extends IModel>
    implements IPresenter {
  M? _model;
  V? _view;
  M get mvpModel => _model!;
  V get mvpView => _view!;
  late BuildContext context;

  @override
  void attachView(IView view) {
    _view = view as V;
    _model = createModel() as M;
    context = (view as BaseViewState).context;

    _model?.http = HttpBase((isLoading) {
      if (isLoading)
        mvpView.showLoading();
      else
        mvpView.hideLoading();
    }, (e) {
      String msg = e.toString();
      if (e is DioException) {
        msg = "[${e.requestOptions.uri.toString()}]${e.message}";
        if (e.response != null) {
          try {
            Map json = jsonDecode(e.response?.data);
            msg += "\n" + json["msg"];
          } catch (e) {}

          if (e.response?.statusCode == 401) {
            mvpView.showMsg(msg, code: -1).whenComplete(() {
              SharedPreferences.getInstance().then((prefs) {
                prefs.remove(MyConfig.PREF_TOKEN);
                mvpView.routePushAndRemoveUntil(LoginPage());
              });
            });
            return;
          }
        }
      }
      mvpView.showMsg(msg, code: -3);
    });
  }

  @override
  void detachView() {
    _view = null;
    _model?.dispose();
    _model = null;
  }

  V get view {
    return _view!;
  }

  M get model => _model!;

  IModel createModel();
}

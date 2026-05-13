import 'package:flutter/widgets.dart';

import 'BaseModel.dart';
import 'IModel.dart';
import 'IPresenter.dart';
import 'IView.dart';

/// BasePresenter — Presenter gốc cho toàn bộ MVP
///
/// SOLID principles:
/// - S: Chỉ quản lý vòng đời View-Model và presentation logic
/// - O: Kế thừa để mở rộng behavior
/// - D: Phụ thuộc vào IView và IModel (abstractions)
///
/// Cách dùng:
/// ```dart
/// class LoginPresenter extends BasePresenter<ILoginView, LoginModel> {
///   @override
///   IModel createModel() => LoginModel();
///
///   void doLogin(String email, String password) async {
///     final result = await mvpModel.http.execute(() => mvpModel.login(email, password));
///     if (result != null) mvpView.navigateToHome();
///   }
/// }
/// ```
abstract class BasePresenter<V extends IView, M extends BaseModel>
    implements IPresenter {
  M? _model;
  V? _view;

  M get mvpModel => _model!;
  V get mvpView => _view!;

  late BuildContext context;

  @override
  void attachView(dynamic view) {
    _view = view as V;
    context = (view as dynamic).context as BuildContext;

    _model = createModel() as M;
    _model!.http = HttpBase(
      onLoading: (isLoading) {
        if (isLoading) {
          mvpView.showLoading();
        } else {
          mvpView.hideLoading();
        }
      },
      onError: (error) {
        mvpView.showMsg(error.toString(), code: -3);
      },
    );
  }

  @override
  void detachView() {
    _model?.dispose();
    _model = null;
    _view = null;
  }

  V get view => _view!;
  M get model => _model!;
  bool get isViewAttached => _view != null;

  /// Subclass phải override để tạo Model tương ứng
  IModel createModel();
}

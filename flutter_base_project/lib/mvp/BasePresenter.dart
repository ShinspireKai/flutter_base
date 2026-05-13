import 'package:flutter/widgets.dart';

import '../core/network/dio_base.dart';
import '../core/network/failure.dart';
import 'BaseModel.dart';
import 'IModel.dart';
import 'IPresenter.dart';
import 'IView.dart';

/// BasePresenter — Presenter gốc cho toàn bộ MVP
///
/// Tự động inject [DioBase] vào Model khi attachView() được gọi.
/// DioBase đã tích hợp sẵn: auth interceptor, retry, error mapping, logging.
///
/// SOLID principles:
/// - S: Chỉ quản lý vòng đời View-Model và điều phối presentation logic
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
///     final response = await mvpModel.dio.post(
///       'auth/login',
///       data: {'email': email, 'password': password},
///     );
///     if (response != null) mvpView.navigateToHome();
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

    // Inject DioBase vào Model — loading/error tự động được handle
    _model!.dio = DioBase(
      onLoading: (isLoading) {
        if (!isViewAttached) return;
        isLoading ? mvpView.showLoading() : mvpView.hideLoading();
      },
      onError: (Failure failure) {
        if (!isViewAttached) return;
        mvpView.showMsg(failure.message, code: failure.code);
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

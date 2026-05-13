import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../mvp/BasePresenter.dart';
import '../../../../../mvp/IModel.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';
import 'i_login_view.dart';
import 'login_model.dart';

/// LoginPresenter — Presenter của MVP cho Login screen
///
/// Phân công trách nhiệm:
/// - [LoginPresenter] xử lý: navigation, dialog, side-effects (gọi view methods)
/// - [LoginBloc]      xử lý: form state (loading, error, success từ API)
///
/// Presenter đóng vai trò "coordinator" — lắng nghe BLoC state
/// rồi ra lệnh cho View làm gì tiếp theo.
///
/// SOLID:
/// - S: Chỉ điều phối giữa View và BLoC, không chứa business logic
/// - D: Phụ thuộc vào ILoginView (abstraction), không phụ thuộc LoginPage
class LoginPresenter extends BasePresenter<ILoginView, LoginModel> {
  @override
  IModel createModel() => LoginModel();

  /// Gọi khi BLoC emit LoginSuccess — Presenter ra lệnh View navigate
  void onLoginSuccess() {
    mvpView.navigateToHome();
  }

  /// Gọi khi BLoC emit LoginFailure — Presenter ra lệnh View hiện lỗi
  void onLoginFailure(String message) {
    mvpView.showErrorSnackbar(message);
    // Reset BLoC về trạng thái ban đầu để user thử lại
    final bloc = mvpView as dynamic;
    try {
      (bloc as dynamic).resetLoginBloc();
    } catch (_) {}
  }

  /// Submit login — Presenter dispatch event vào BLoC
  void submitLogin({
    required LoginBloc bloc,
    required String email,
    required String password,
  }) {
    // Lưu lại email lần cuối trong Model
    mvpModel.lastAttemptedEmail = email;

    bloc.add(LoginSubmitted(email: email, password: password));
  }

  /// Toggle hiển thị mật khẩu
  void togglePasswordVisibility(LoginBloc bloc) {
    bloc.add(const LoginPasswordVisibilityToggled());
  }
}

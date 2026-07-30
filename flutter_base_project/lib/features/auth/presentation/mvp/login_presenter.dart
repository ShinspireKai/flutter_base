import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../mvp/BasePresenter.dart';
import '../../../../../mvp/IModel.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/user_role.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
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

  /// Gọi khi BLoC emit LoginSuccess — Presenter quyết định điều hướng
  /// đến đúng Home theo role (Inspector / Contractor)
  void onLoginSuccess(UserEntity user) {
    if (user.isContractor) {
      mvpView.navigateToContractorHome();
    } else {
      mvpView.navigateToInspectorHome();
    }
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
    bool rememberMe = false,
  }) {
    // Lưu lại email lần cuối trong Model
    mvpModel.lastAttemptedEmail = email;

    bloc.add(
      LoginSubmitted(email: email, password: password, rememberMe: rememberMe),
    );
  }

  /// Toggle hiển thị mật khẩu
  void togglePasswordVisibility(LoginBloc bloc) {
    bloc.add(const LoginPasswordVisibilityToggled());
  }

  /// Submit đăng nhập bằng sinh trắc học — Presenter dispatch event vào BLoC
  void biometricLogin(
    LoginBloc bloc, {
    required String reason,
    required String failureMessage,
  }) {
    bloc.add(
      LoginBiometricRequested(reason: reason, failureMessage: failureMessage),
    );
  }
}

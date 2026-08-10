import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/l10n/app_localizations.dart';
import '../../../../../mvp/BaseView.dart';
import '../../../../core/gen/colors.gen.dart';
import '../../../../core/router/auto_route_config.dart';
import '../../../../testing/test_keys.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';
import '../widgets/login_form.dart';
import '../mvp/i_login_view.dart';
import '../mvp/login_presenter.dart';

// ─────────────────────────────────────────────────────────────────────────────
// LoginPage — BaseView (MVP View)
// ─────────────────────────────────────────────────────────────────────────────
//
// Kiến trúc kết hợp MVP + BLoC:
//
//   LoginPage (BaseView)
//     └── _LoginPageState (BaseViewState) implements ILoginView
//           ├── LoginPresenter (BasePresenter)
//           │     └── điều phối navigation & side-effects
//           └── LoginBloc (từ context)
//                 └── quản lý form state (loading / error / success)
//
// Phân công rõ ràng:
//   • Presenter → xử lý NAVIGATION, dialog, side-effects (gọi ILoginView)
//   • BLoC      → xử lý FORM STATE (loading indicator, error message, success)
//   • View      → chỉ render UI và forward action lên Presenter/BLoC
// ─────────────────────────────────────────────────────────────────────────────

@RoutePage()
class LoginPage extends BaseView {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends BaseViewState<LoginPresenter, LoginPage>
    implements ILoginView {
  // ─── MVP ──────────────────────────────────────────────────────────────────

  @override
  LoginPresenter createPresenter() => LoginPresenter();

  /// Sau khi frame đầu render, gắn BlocListener vào BLoC hiện có
  /// Presenter sẽ được gọi từ listener này
  @override
  void afterInit() {
    // Không cần load data lần đầu ở Login
  }

  // ─── ILoginView implementation ────────────────────────────────────────────

  @override
  void navigateToInspectorHome() {
    context.router.replaceAll([const InspectorHomeRoute()]);
  }

  @override
  void navigateToContractorHome() {
    // Mock demo: ticket #0523 (mã 進入代碼 284913) được seed sẵn trong
    // MaintenanceTaskRemoteDataSourceImpl để test luồng không cần SMS thật
    context.router.replaceAll([ContractorHomeRoute(ticketNo: '0523')]);
  }

  @override
  void showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
  }

  /// Helper để Presenter reset BLoC (gọi qua reflection trong Presenter)
  void resetLoginBloc() {
    context.read<LoginBloc>().add(const LoginReset());
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget buildView(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (ctx, state) {
        // Presenter là coordinator — ra lệnh cho View dựa trên BLoC state
        if (state is LoginSuccess) {
          presenter?.onLoginSuccess(state.user);
        }
        if (state is LoginFailure) {
          presenter?.onLoginFailure(state.errorMessage);
          context.read<LoginBloc>().add(const LoginReset());
        }
      },
      child: Scaffold(
        key: TestKeys.loginPageScaffold,
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.title_login_appbar,
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).unfocus(),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 64),
                  _buildHeader(),
                  const SizedBox(height: 48),
                  // LoginForm nhận presenter để submit qua đúng luồng MVP
                  LoginForm(presenter: presenter!),
                  if (kDebugMode) ...[
                    const SizedBox(height: 32),
                    _buildDivider(),
                    const SizedBox(height: 20),
                    _buildDemoHint(),
                    const SizedBox(height: 40),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Widgets ──────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withValues(alpha: 0.65),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '🧭',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColorLight,
                  height: 1.25,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            AppLocalizations.of(context)!.appTagline,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: ColorName.greenPrimary,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            AppLocalizations.of(context)!.demoInfoLabel,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).primaryColorDark,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildDemoHint() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: Theme.of(context).textTheme.bodySmall,
                children: [
                  TextSpan(text: AppLocalizations.of(context)!.demoInspectorLabel),
                  TextSpan(
                    text: 'test@example.com',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const TextSpan(text: '  /  '),
                  TextSpan(
                    text: 'password123',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  TextSpan(text: '\n${AppLocalizations.of(context)!.demoContractorLabel}'),
                  TextSpan(
                    text: 'contractor@example.com',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const TextSpan(text: '  /  '),
                  TextSpan(
                    text: 'password123',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

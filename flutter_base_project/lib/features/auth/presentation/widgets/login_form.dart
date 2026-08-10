import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspection_app/testing/test_keys.dart';
import 'package:inspection_app/util/widgets/custom_button.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/gen/colors.gen.dart';
import '../../../../util/widgets/custom_text_field.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_state.dart';
import '../mvp/login_presenter.dart';

/// LoginForm — Widget render form đăng nhập
///
/// Single Responsibility: chỉ render form và forward action lên Presenter.
/// Không chứa bất kỳ logic navigation hay side-effect nào.
///
/// Flow:
///   User nhập → User nhấn submit → Presenter.submitLogin() → BLoC dispatch
class LoginForm extends StatefulWidget {
  /// Presenter được inject từ LoginPage (BaseViewState)
  final LoginPresenter presenter;

  const LoginForm({super.key, required this.presenter});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _companyCodeCtrl = TextEditingController();
  final _accountNumberCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _companyCodeFocus = FocusNode();
  final _accountNumberFocus = FocusNode();
  final _passwordFocus = FocusNode();
  bool _rememberMe = false;

  @override
  void dispose() {
    _companyCodeCtrl.dispose();
    _accountNumberCtrl.dispose();
    _passwordCtrl.dispose();
    _companyCodeFocus.dispose();
    _accountNumberFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _submit() {
    _passwordFocus.unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      // Forward lên Presenter — đúng luồng MVP
      widget.presenter.submitLogin(
        bloc: context.read<LoginBloc>(),
        email: _accountNumberCtrl.text.trim(),
        password: _passwordCtrl.text,
        rememberMe: _rememberMe,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        final isLoading = state is LoginLoading;
        final isBiometricAvailable = state is LoginInitial
            ? state.isBiometricAvailable
            : false;

        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── 公司代碼 ──────────────────────────────────────────────────
              CustomTextField(
                key: TestKeys.loginCompanyCodeField,
                labelText: l10n.companyCodeLabel,
                hintText: l10n.companyCodeLabel,
                controller: _companyCodeCtrl,
                focusNode: _companyCodeFocus,
                enabled: !isLoading,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_accountNumberFocus),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return l10n.companyCodeRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),

              // ── 帳號 ──────────────────────────────────────────────────
              CustomTextField(
                key: TestKeys.loginAccountField,
                labelText: l10n.accountLabel,
                hintText: l10n.accountHint,
                controller: _accountNumberCtrl,
                focusNode: _accountNumberFocus,
                enabled: !isLoading,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_passwordFocus),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return l10n.accountRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),

              // ── 密碼 ───────────────────────────────────────────────
              CustomTextField(
                key: TestKeys.loginPasswordField,
                labelText: l10n.passwordLabel,
                hintText: l10n.passwordLabel,
                controller: _passwordCtrl,
                focusNode: _passwordFocus,
                enabled: !isLoading,
                keyboardType: TextInputType.visiblePassword,
                isPassword: true,
                obscureText: true,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return l10n.passwordRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),

              //── Check Remember Account ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      checkColor: Colors.white,
                      fillColor: WidgetStatePropertyAll(
                        _rememberMe ? Colors.blueAccent : Colors.white,
                      ),
                      side: const BorderSide(
                        color: ColorName.colorTextGrey,
                        width: 1,
                      ),
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: isLoading
                          ? null
                          : (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                    ),
                    Text(
                      l10n.rememberMe,
                      style: const TextStyle(color: ColorName.colorTextGrey),
                    ),
                  ],
                ),
              ),

              // ── Submit button ──────────────────────────────────────────
              CustomButton(
                key: TestKeys.loginSubmitButton,
                text: l10n.loginButton,
                isLoading: isLoading,
                elevation: 0,
                onPressed: isLoading ? null : _submit,
              ),
              const SizedBox(height: 11),
              CustomButton(
                text: l10n.biometricLoginButton,
                isOutline: true,
                isLoading: isLoading,
                elevation: 0,
                onPressed: isLoading
                    ? null
                    : () => widget.presenter.biometricLogin(
                        context.read<LoginBloc>(),
                        reason: l10n.biometricAuthReason,
                        failureMessage: l10n.biometricAuthFailed,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

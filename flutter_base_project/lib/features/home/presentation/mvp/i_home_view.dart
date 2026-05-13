import 'package:flutter/material.dart';

import '../../../../../mvp/IView.dart';

/// IHomeView — View contract cho Home screen
///
/// Interface Segregation: chỉ khai báo method cần thiết cho home.
abstract class IHomeView extends IView {
  /// Điều hướng về Login sau khi logout thành công
  void navigateToLogin();

  /// Hiển thị dialog xác nhận logout
  void showLogoutConfirmDialog({required VoidCallback onConfirm});

  /// Hiển thị snackbar lỗi
  void showErrorSnackbar(String message);
}

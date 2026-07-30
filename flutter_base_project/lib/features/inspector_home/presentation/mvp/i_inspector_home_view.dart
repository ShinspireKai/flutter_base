import 'package:flutter/material.dart';

import '../../../../../mvp/IView.dart';

/// IInspectorHomeView — View contract cho Home screen của 巡檢人員 (Inspector)
///
/// Interface Segregation: chỉ khai báo method cần thiết cho inspector home.
abstract class IInspectorHomeView extends IView {
  /// Điều hướng về Login sau khi logout thành công
  void navigateToLogin();

  /// Điều hướng tới trang「今日巡檢」
  void navigateToTodayInspection();

  /// Điều hướng tới trang「我的維修任務」
  void navigateToMaintenanceTasks();

  /// Điều hướng tới trang「待我複檢」
  void navigateToPendingRecheck();

  /// Hiển thị dialog xác nhận logout
  void showLogoutConfirmDialog({required VoidCallback onConfirm});

  /// Hiển thị snackbar lỗi
  void showErrorSnackbar(String message);

  /// Hiển thị snackbar chứa FCM token kèm nút Copy — chỉ dùng để kiểm thử push notification
  void showFcmTokenSnackbar(String token);
}

import 'package:flutter/material.dart';
import 'package:inspection_app/core/di.dart';
import 'package:inspection_app/core/local/local_storage.dart';

import '../../../../../mvp/BasePresenter.dart';
import '../../../../../mvp/IModel.dart';
import '../bloc/inspector_home_bloc.dart';
import '../bloc/inspector_home_event.dart';
import 'inspector_home_model.dart';
import 'i_inspector_home_view.dart';

/// InspectorHomePresenter — Presenter của MVP cho Home screen của 巡檢人員 (Inspector)
///
/// Phân công trách nhiệm:
/// - [InspectorHomePresenter] xử lý: navigation, dialog confirm, side-effects
/// - [InspectorHomeBloc]      xử lý: data state (loading, loaded, error, logout state)
class InspectorHomePresenter
    extends BasePresenter<IInspectorHomeView, InspectorHomeModel> {
  @override
  IModel createModel() => InspectorHomeModel();

  /// Gọi khi user nhấn nút logout — Presenter hỏi View hiện dialog trước
  void onLogoutPressed(InspectorHomeBloc bloc) {
    mvpView.showLogoutConfirmDialog(
      onConfirm: () => bloc.add(const InspectorHomeLogout()),
    );
  }

  /// Gọi khi BLoC emit InspectorHomeLoggedOut — Presenter ra lệnh View navigate
  void onLoggedOut() {
    mvpView.navigateToLogin();
  }

  /// Gọi khi user nhấn mục "今日巡檢" trên Home
  void onTodayInspectionTapped() {
    mvpView.navigateToTodayInspection();
  }

  /// Gọi khi user nhấn mục "我的維修任務" trên Home
  void onMyMaintenanceTasksTapped() {
    mvpView.navigateToMaintenanceTasks();
  }

  /// Gọi khi user nhấn mục "待複檢" trên Home
  void onPendingRecheckTapped() {
    mvpView.navigateToPendingRecheck();
  }

  /// Gọi khi BLoC emit InspectorHomeError — Presenter ra lệnh View hiện lỗi
  void onError(String message) {
    mvpView.showErrorSnackbar(message);
  }

  /// Trigger load profile
  void loadProfile(InspectorHomeBloc bloc) {
    bloc.add(const InspectorHomeLoadUserProfile());
  }

  /// Trigger refresh
  void refresh(InspectorHomeBloc bloc) {
    bloc.add(const InspectorHomeRefreshed());
  }

  /// Cập nhật tab index trong Model (UI state nhỏ)
  void selectTab(int index) {
    mvpModel.selectedTabIndex = index;
  }

  /// Hiện snackbar chứa FCM token (nếu đã có) để tester copy dùng cho việc
  /// gửi push notification thử nghiệm — chỉ phục vụ mục đích kiểm thử.
  void checkFcmToken() {
    final token = sl<LocalStorage>().fcmToken;
    if (token.isNotEmpty) {
      mvpView.showFcmTokenSnackbar(token);
    }
  }
}

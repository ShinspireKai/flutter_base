import 'package:flutter/material.dart';

import '../../../../../mvp/BasePresenter.dart';
import '../../../../../mvp/IModel.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import 'home_model.dart';
import 'i_home_view.dart';

/// HomePresenter — Presenter của MVP cho Home screen
///
/// Phân công trách nhiệm:
/// - [HomePresenter] xử lý: navigation, dialog confirm, side-effects
/// - [HomeBloc]      xử lý: data state (loading, loaded, error, logout state)
///
/// SOLID:
/// - S: Chỉ điều phối giữa View và BLoC cho Home
/// - D: Phụ thuộc vào IHomeView (abstraction)
class HomePresenter extends BasePresenter<IHomeView, HomeModel> {
  @override
  IModel createModel() => HomeModel();

  /// Gọi khi user nhấn nút logout — Presenter hỏi View hiện dialog trước
  void onLogoutPressed(HomeBloc bloc) {
    mvpView.showLogoutConfirmDialog(
      onConfirm: () => bloc.add(const HomeLogout()),
    );
  }

  /// Gọi khi BLoC emit HomeLoggedOut — Presenter ra lệnh View navigate
  void onLoggedOut() {
    mvpView.navigateToLogin();
  }

  /// Gọi khi BLoC emit HomeError — Presenter ra lệnh View hiện lỗi
  void onError(String message) {
    mvpView.showErrorSnackbar(message);
  }

  /// Trigger load profile
  void loadProfile(HomeBloc bloc) {
    bloc.add(const HomeLoadUserProfile());
  }

  /// Trigger refresh
  void refresh(HomeBloc bloc) {
    bloc.add(const HomeRefreshed());
  }

  /// Cập nhật tab index trong Model (UI state nhỏ)
  void selectTab(int index) {
    mvpModel.selectedTabIndex = index;
  }
}

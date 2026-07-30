import '../../../../../../mvp/BasePresenter.dart';
import '../../../../../../mvp/IModel.dart';
import '../../domain/entities/inspection_task_entity.dart';
import '../bloc/today_inspection_bloc.dart';
import '../bloc/today_inspection_event.dart';
import 'today_inspection_model.dart';
import 'i_today_inspection_view.dart';

/// TodayInspectionPresenter — Presenter của MVP cho trang「今日巡檢」của 巡檢人員 (Inspector)
///
/// Phân công trách nhiệm:
/// - [TodayInspectionPresenter] xử lý: side-effects (error snackbar)
/// - [TodayInspectionBloc]      xử lý: data state (loading, loaded, error)
class TodayInspectionPresenter
    extends BasePresenter<ITodayInspectionView, TodayInspectionModel> {
  @override
  IModel createModel() => TodayInspectionModel();

  /// Gọi khi BLoC emit TodayInspectionError — Presenter ra lệnh View hiện lỗi
  void onError(String message) {
    mvpView.showErrorSnackbar(message);
  }

  /// Trigger load danh sách巡檢 hôm nay
  void loadTasks(TodayInspectionBloc bloc) {
    bloc.add(const TodayInspectionLoadTasks());
  }

  /// Trigger refresh
  void refresh(TodayInspectionBloc bloc) {
    bloc.add(const TodayInspectionRefreshed());
  }

  /// User nhấn vào 1 hạng mục — điều hướng sang màn hình kiểm tra thiết bị
  void onTaskTapped(InspectionTaskEntity task) {
    mvpView.navigateToEquipmentInspection(task);
  }
}

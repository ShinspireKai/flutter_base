import '../../../../../mvp/BasePresenter.dart';
import '../../../../../mvp/IModel.dart';
import '../../domain/entities/maintenance_task_entity.dart';
import '../bloc/maintenance_task_bloc.dart';
import '../bloc/maintenance_task_event.dart';
import 'maintenance_task_model.dart';
import 'i_maintenance_task_view.dart';

/// MaintenanceTaskPresenter — Presenter của MVP cho trang「我的維修任務」của 維修人員 (Technician)
///
/// Phân công trách nhiệm:
/// - [MaintenanceTaskPresenter] xử lý: side-effects (error snackbar), điều hướng
/// - [MaintenanceTaskBloc]      xử lý: data state (loading, loaded, error)
class MaintenanceTaskPresenter
    extends BasePresenter<IMaintenanceTaskView, MaintenanceTaskModel> {
  @override
  IModel createModel() => MaintenanceTaskModel();

  /// Gọi khi BLoC emit MaintenanceTaskError — Presenter ra lệnh View hiện lỗi
  void onError(String message) {
    mvpView.showErrorSnackbar(message);
  }

  /// Trigger load danh sách維修任務
  void loadTasks(MaintenanceTaskBloc bloc) {
    bloc.add(const MaintenanceTaskLoadTasks());
  }

  /// Trigger refresh
  void refresh(MaintenanceTaskBloc bloc) {
    bloc.add(const MaintenanceTaskRefreshed());
  }

  /// User nhấn vào 1 nhiệm vụ — điều hướng sang màn hình「維修回報」/「再維修」,
  /// trừ khi nhiệm vụ đã 已完成 thì chỉ hiện thông báo
  void onTaskTapped(MaintenanceTaskEntity task) {
    if (task.status == MaintenanceTaskStatus.completed) {
      mvpView.showTaskAlreadyCompletedNotice();
      return;
    }
    mvpView.navigateToReport(task);
  }
}

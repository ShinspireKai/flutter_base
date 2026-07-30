import '../../../../../mvp/BasePresenter.dart';
import '../../../../../mvp/IModel.dart';
import '../../domain/entities/maintenance_task_entity.dart';
import '../bloc/pending_recheck_bloc.dart';
import '../bloc/pending_recheck_event.dart';
import 'pending_recheck_model.dart';
import 'i_pending_recheck_view.dart';

/// PendingRecheckPresenter — Presenter của MVP cho trang「待我複檢」của người phúc kiểm
///
/// Phân công trách nhiệm:
/// - [PendingRecheckPresenter] xử lý: side-effects (error snackbar), điều hướng
/// - [PendingRecheckBloc]      xử lý: data state (loading, loaded, error)
class PendingRecheckPresenter
    extends BasePresenter<IPendingRecheckView, PendingRecheckModel> {
  @override
  IModel createModel() => PendingRecheckModel();

  /// Gọi khi BLoC emit PendingRecheckError — Presenter ra lệnh View hiện lỗi
  void onError(String message) {
    mvpView.showErrorSnackbar(message);
  }

  /// Trigger load danh sách 待複檢
  void loadTasks(PendingRecheckBloc bloc) {
    bloc.add(const PendingRecheckLoadTasks());
  }

  /// Trigger refresh
  void refresh(PendingRecheckBloc bloc) {
    bloc.add(const PendingRecheckRefreshed());
  }

  /// User nhấn vào 1 nhiệm vụ — điều hướng sang màn hình「異常複檢」
  void onTaskTapped(MaintenanceTaskEntity task) {
    mvpView.navigateToRecheckDecision(task);
  }
}

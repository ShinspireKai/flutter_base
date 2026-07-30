import '../../../../../mvp/BasePresenter.dart';
import '../../../../../mvp/IModel.dart';
import '../../domain/entities/maintenance_task_entity.dart';
import '../bloc/maintenance_report_bloc.dart';
import '../bloc/maintenance_report_event.dart';
import 'maintenance_report_model.dart';
import 'i_maintenance_report_view.dart';

/// MaintenanceReportPresenter — Presenter của MVP cho màn hình「維修回報」(R2) / 「再維修」(R3)
///
/// Phân công trách nhiệm:
/// - [MaintenanceReportPresenter] xử lý: bottom sheet chọn nguồn ảnh, validate
///   điều kiện gửi phúc kiểm, side-effects (toast, thông báo mô phỏng), điều hướng
/// - [MaintenanceReportBloc]      xử lý: data state (task, submit)
class MaintenanceReportPresenter
    extends BasePresenter<IMaintenanceReportView, MaintenanceReportModel> {
  @override
  IModel createModel() => MaintenanceReportModel();

  /// User chỉnh sửa 完工說明
  void onCompletionNoteChanged(MaintenanceReportBloc bloc, String note) {
    bloc.add(MaintenanceReportCompletionNoteChanged(note: note));
  }

  /// User nhấn thêm ảnh — Presenter hỏi View hiện bottom sheet chọn nguồn ảnh
  void onAddPhotoTapped(MaintenanceReportBloc bloc) {
    mvpView.showPhotoSourcePicker(
      onSelected: (fromCamera) => bloc.add(
        MaintenanceReportPhotoCaptureRequested(
          source: fromCamera
              ? MaintenancePhotoSource.camera
              : MaintenancePhotoSource.gallery,
        ),
      ),
    );
  }

  /// User nhấn「更新進度」
  void onProgressUpdatePressed(MaintenanceReportBloc bloc) {
    bloc.add(const MaintenanceReportProgressUpdateRequested());
  }

  /// User nhấn「完成，送複檢」/「完成，再送複檢」— chỉ cho gửi khi đã nhập完工說明
  void onSubmitPressed(MaintenanceReportBloc bloc, MaintenanceTaskEntity task) {
    if ((task.completionNote ?? '').trim().isEmpty) {
      mvpView.showCompletionNoteRequiredWarning();
      return;
    }
    bloc.add(const MaintenanceReportSubmitted());
  }

  /// Gọi khi BLoC emit MaintenanceReportProgressSaved
  void onProgressSaved() {
    mvpView.showProgressSavedToast();
  }

  /// Gọi khi BLoC emit MaintenanceReportSentForRecheck
  void onSentForRecheck() {
    mvpView.showSentForRecheckToast();
    mvpView.navigateBackToList();
  }

  /// Gọi khi BLoC emit MaintenanceReportError
  void onError(String message) {
    mvpView.showErrorSnackbar(message);
  }
}

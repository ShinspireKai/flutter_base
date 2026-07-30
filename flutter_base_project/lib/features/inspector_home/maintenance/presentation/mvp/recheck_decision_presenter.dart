import '../../../../../mvp/BasePresenter.dart';
import '../../../../../mvp/IModel.dart';
import '../bloc/recheck_decision_bloc.dart';
import '../bloc/recheck_decision_event.dart';
import 'recheck_decision_model.dart';
import 'i_recheck_decision_view.dart';

/// RecheckDecisionPresenter — Presenter của MVP cho màn hình「異常複檢」(C2)
///
/// Phân công trách nhiệm:
/// - [RecheckDecisionPresenter] xử lý: validate điều kiện gửi複檢結果, side-effects
///   (toast, snackbar), điều hướng
/// - [RecheckDecisionBloc]      xử lý: data state (lựa chọn, ghi chú, submit)
class RecheckDecisionPresenter
    extends BasePresenter<IRecheckDecisionView, RecheckDecisionModel> {
  @override
  IModel createModel() => RecheckDecisionModel();

  /// User chọn kết quả phúc kiểm (toggle 通過/不通過)
  void onResultChanged(RecheckDecisionBloc bloc, RecheckResult result) {
    bloc.add(RecheckDecisionResultChanged(result));
  }

  /// User chỉnh sửa 複檢說明
  void onNoteChanged(RecheckDecisionBloc bloc, String note) {
    bloc.add(RecheckDecisionNoteChanged(note: note));
  }

  /// User nhấn「送出複檢」— chỉ cho gửi khi đã nhập 複檢說明
  void onSubmitPressed(RecheckDecisionBloc bloc, String note) {
    if (note.trim().isEmpty) {
      mvpView.showRecheckNoteRequiredWarning();
      return;
    }
    bloc.add(const RecheckDecisionSubmitted());
  }

  /// Gọi khi BLoC emit RecheckDecisionSubmitCompleted
  void onSubmitCompleted(RecheckResult result) {
    mvpView.showSubmitCompletedToast(approved: result == RecheckResult.approved);
    mvpView.navigateBackToList();
  }

  /// Gọi khi BLoC emit RecheckDecisionError
  void onError(String message) {
    mvpView.showErrorSnackbar(message);
  }
}

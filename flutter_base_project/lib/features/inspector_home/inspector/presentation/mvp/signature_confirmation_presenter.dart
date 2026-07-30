import '../../../../../mvp/BasePresenter.dart';
import '../../../../../mvp/IModel.dart';
import '../../domain/entities/inspection_route_entity.dart';
import '../bloc/equipment_inspection_bloc.dart';
import '../bloc/equipment_inspection_event.dart';
import 'signature_confirmation_model.dart';
import 'i_signature_confirmation_view.dart';

/// SignatureConfirmationPresenter — Presenter của MVP cho màn hình「簽名確認」
///
/// Dùng chung [EquipmentInspectionBloc] với màn hình danh sách kiểm tra
/// (được truyền thẳng vào trang) — gửi báo cáo qua đúng bloc đã tải checklist.
class SignatureConfirmationPresenter
    extends BasePresenter<ISignatureConfirmationView, SignatureConfirmationModel> {
  @override
  IModel createModel() => SignatureConfirmationModel();

  /// User nhấn 「確認送出」— chỉ cho gửi khi đã ký xác nhận
  void onConfirmPressed(
    EquipmentInspectionBloc bloc, {
    required bool hasSignature,
  }) {
    if (!hasSignature) {
      mvpView.showSignatureRequiredWarning();
      return;
    }
    bloc.add(const EquipmentInspectionSubmitted());
  }

  /// Gọi khi BLoC emit EquipmentInspectionSubmitSuccess
  void onSubmitSuccess(InspectionRouteEntity route) {
    mvpView.onSubmitSuccess(route);
  }

  /// Gọi khi BLoC emit EquipmentInspectionError
  void onError(String message) {
    mvpView.showErrorSnackbar(message);
  }
}

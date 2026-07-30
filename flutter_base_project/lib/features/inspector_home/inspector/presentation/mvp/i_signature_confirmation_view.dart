import '../../../../../mvp/IView.dart';
import '../../domain/entities/inspection_route_entity.dart';

/// ISignatureConfirmationView — View contract cho màn hình「簽名確認」
abstract class ISignatureConfirmationView extends IView {
  /// Hiển thị snackbar lỗi
  void showErrorSnackbar(String message);

  /// Chưa ký — nhắc người dùng ký xác nhận trước khi gửi
  void showSignatureRequiredWarning();

  /// Gửi báo cáo thành công — điều hướng sang màn hình「巡檢完成」
  void onSubmitSuccess(InspectionRouteEntity route);
}

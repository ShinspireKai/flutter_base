import '../../../../../mvp/BasePresenter.dart';
import '../../../../../mvp/IModel.dart';
import '../../../inspector_home/maintenance/domain/entities/maintenance_task_entity.dart';
import '../bloc/contractor_home_bloc.dart';
import '../bloc/contractor_home_event.dart';
import 'contractor_home_model.dart';
import 'i_contractor_home_view.dart';

/// ContractorHomePresenter — Presenter của MVP cho màn hình「維修單回報」(V1)
///
/// Phân công trách nhiệm:
/// - [ContractorHomePresenter] xử lý: navigation, side-effects
/// - [ContractorHomeBloc]      xử lý: data state (loading, ticket, verify)
class ContractorHomePresenter
    extends BasePresenter<IContractorHomeView, ContractorHomeModel> {
  @override
  IModel createModel() => ContractorHomeModel();

  /// Gọi khi user nhập 進入代碼
  void onCodeChanged(ContractorHomeBloc bloc, String code) {
    bloc.add(ContractorHomeCodeChanged(code));
  }

  /// Gọi khi user nhấn 確認進入
  void onConfirmPressed(ContractorHomeBloc bloc) {
    bloc.add(const ContractorHomeConfirmPressed());
  }

  /// Gọi khi BLoC emit ContractorHomeVerified — Presenter ra lệnh View navigate
  void onVerified(MaintenanceTaskEntity ticket) {
    mvpView.navigateToRepairReport(ticket);
  }
}

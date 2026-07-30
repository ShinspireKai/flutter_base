import '../../../../../mvp/BasePresenter.dart';
import '../../../../../mvp/IModel.dart';
import '../../domain/entities/inspection_checklist_item_entity.dart';
import '../../domain/entities/inspection_route_entity.dart';
import '../bloc/equipment_inspection_bloc.dart';
import '../bloc/equipment_inspection_event.dart';
import 'equipment_inspection_model.dart';
import 'i_equipment_inspection_view.dart';

/// EquipmentInspectionPresenter — Presenter của MVP cho màn hình「B1 設備巡檢」
///
/// Phân công trách nhiệm:
/// - [EquipmentInspectionPresenter] xử lý: dialog/bottom sheet chọn mức độ,
///   ghi chú, nguồn ảnh; validate điều kiện gửi báo cáo; điều hướng
/// - [EquipmentInspectionBloc]      xử lý: data state (checklist, submit)
class EquipmentInspectionPresenter
    extends BasePresenter<IEquipmentInspectionView, EquipmentInspectionModel> {
  @override
  IModel createModel() => EquipmentInspectionModel();

  /// Trigger load checklist của tuyến kiểm tra
  void loadChecklist(EquipmentInspectionBloc bloc, String routeId) {
    bloc.add(EquipmentInspectionLoadChecklist(routeId: routeId));
  }

  /// User chọn 正常 / 異常 cho một hạng mục
  void onItemStatusSelected(
    EquipmentInspectionBloc bloc,
    String itemId,
    InspectionItemStatus status,
  ) {
    bloc.add(
      EquipmentInspectionItemStatusChanged(itemId: itemId, status: status),
    );
  }

  /// User chọn mức độ nghiêm trọng (低 / 中 / 高) cho hạng mục 異常
  void onSeveritySelected(
    EquipmentInspectionBloc bloc,
    String itemId,
    InspectionSeverity severity,
  ) {
    bloc.add(
      EquipmentInspectionSeverityChanged(itemId: itemId, severity: severity),
    );
  }

  /// User nhấn ghi chú — Presenter hỏi View hiện dialog nhập text
  void onNoteTapped(
    EquipmentInspectionBloc bloc,
    InspectionChecklistItemEntity item,
  ) {
    mvpView.showNoteDialog(
      initialNote: item.note,
      onSubmit: (note) =>
          bloc.add(EquipmentInspectionNoteChanged(itemId: item.id, note: note)),
    );
  }

  /// User nhấn 「拍照記錄」— Presenter hỏi View hiện bottom sheet chọn nguồn ảnh
  void onCapturePhotoTapped(
    EquipmentInspectionBloc bloc,
    InspectionChecklistItemEntity item,
  ) {
    mvpView.showPhotoSourcePicker(
      onSelected: (fromCamera) => bloc.add(
        EquipmentInspectionPhotoCaptureRequested(
          itemId: item.id,
          source: fromCamera
              ? InspectionPhotoSource.camera
              : InspectionPhotoSource.gallery,
        ),
      ),
    );
  }

  /// User nhấn 「拍照記錄」của 1 hạng mục 異常 — mở màn hình bổ sung ảnh/mức độ/ghi chú
  void onOpenPhotoRecordTapped(EquipmentInspectionBloc bloc, String itemId) {
    mvpView.navigateToPhotoRecord(bloc, itemId);
  }

  /// User nhấn 「送出巡檢報告」— chỉ cho sang bước ký tên khi đã hoàn thành hết
  void onSubmitPressed(EquipmentInspectionBloc bloc, InspectionRouteEntity route) {
    if (!route.isAllCompleted) {
      mvpView.showIncompleteChecklistWarning(
        route.totalCount - route.completedCount,
      );
      return;
    }
    mvpView.navigateToSignatureConfirmation(bloc);
  }

  /// Gọi khi BLoC emit EquipmentInspectionError
  void onError(String message) {
    mvpView.showErrorSnackbar(message);
  }
}

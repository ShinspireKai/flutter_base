import '../../../../../mvp/BasePresenter.dart';
import '../../../../../mvp/IModel.dart';
import '../../domain/entities/inspection_checklist_item_entity.dart';
import '../bloc/equipment_inspection_bloc.dart';
import '../bloc/equipment_inspection_event.dart';
import 'photo_record_model.dart';
import 'i_photo_record_view.dart';

/// PhotoRecordPresenter — Presenter của MVP cho màn hình「拍照記錄」
///
/// Dùng chung [EquipmentInspectionBloc] với màn hình danh sách kiểm tra
/// (được truyền thẳng vào trang, không tạo bloc mới) để mọi thay đổi
/// (ảnh, mức độ, ghi chú) phản ánh ngay khi quay lại checklist.
class PhotoRecordPresenter
    extends BasePresenter<IPhotoRecordView, PhotoRecordModel> {
  @override
  IModel createModel() => PhotoRecordModel();

  /// User nhấn ô "+" trong lưới ảnh — hỏi View hiện bottom sheet chọn nguồn ảnh
  void onAddPhotoTapped(EquipmentInspectionBloc bloc, String itemId) {
    mvpView.showPhotoSourcePicker(
      onSelected: (fromCamera) => bloc.add(
        EquipmentInspectionPhotoCaptureRequested(
          itemId: itemId,
          source: fromCamera
              ? InspectionPhotoSource.camera
              : InspectionPhotoSource.gallery,
        ),
      ),
    );
  }

  /// User nhấn nút 「開啟相機」— mở thẳng camera, không qua bottom sheet
  void onOpenCameraPressed(EquipmentInspectionBloc bloc, String itemId) {
    bloc.add(
      EquipmentInspectionPhotoCaptureRequested(
        itemId: itemId,
        source: InspectionPhotoSource.camera,
      ),
    );
  }

  /// User chọn mức độ bất thường (高 / 中 / 低)
  void onSeveritySelected(
    EquipmentInspectionBloc bloc,
    String itemId,
    InspectionSeverity severity,
  ) {
    bloc.add(
      EquipmentInspectionSeverityChanged(itemId: itemId, severity: severity),
    );
  }

  /// User nhấn 「完成，回檢查表」— lưu ghi chú rồi quay lại checklist
  void onCompletePressed(
    EquipmentInspectionBloc bloc,
    String itemId,
    String note,
  ) {
    bloc.add(EquipmentInspectionNoteChanged(itemId: itemId, note: note));
    mvpView.popBack();
  }
}

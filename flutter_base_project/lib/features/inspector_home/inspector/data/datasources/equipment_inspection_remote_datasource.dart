import '../../domain/entities/inspection_checklist_item_entity.dart';
import '../../domain/entities/inspection_route_entity.dart';
import '../models/inspection_checklist_item_model.dart';
import '../models/inspection_route_model.dart';

/// Abstract interface cho EquipmentInspection remote data source
abstract class EquipmentInspectionRemoteDataSource {
  Future<InspectionRouteModel> getChecklist(String routeId);

  Future<bool> submitReport(InspectionRouteEntity route);
}

/// Mock implementation cho demo — dữ liệu tuyến「B1 設備巡檢」
class EquipmentInspectionRemoteDataSourceImpl
    implements EquipmentInspectionRemoteDataSource {
  @override
  Future<InspectionRouteModel> getChecklist(String routeId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    return InspectionRouteModel(
      id: routeId,
      name: 'B1 設備巡檢',
      location: 'B1 機房區',
      items: const [
        InspectionChecklistItemModel(
          id: 'item_01',
          index: 1,
          name: '灑水系統壓力',
          status: InspectionItemStatus.normal,
        ),
        InspectionChecklistItemModel(
          id: 'item_02',
          index: 2,
          name: '緊急照明測試',
          status: InspectionItemStatus.normal,
        ),
        InspectionChecklistItemModel(
          id: 'item_03',
          index: 3,
          name: '電梯機房通風',
          status: InspectionItemStatus.normal,
        ),
        InspectionChecklistItemModel(
          id: 'item_04',
          index: 4,
          name: '發電機油位',
          status: InspectionItemStatus.normal,
        ),
        InspectionChecklistItemModel(
          id: 'item_05',
          index: 5,
          name: '配電盤標示',
          status: InspectionItemStatus.normal,
        ),
        InspectionChecklistItemModel(
          id: 'item_06',
          index: 6,
          name: '逃生通道暢通',
          status: InspectionItemStatus.normal,
        ),
        InspectionChecklistItemModel(
          id: 'item_07',
          index: 7,
          name: '電盤溫度',
          status: InspectionItemStatus.abnormal,
          severity: InspectionSeverity.high,
          note: '右側電盤溫度偏高',
          photoPaths: ['mock/photo_1.jpg', 'mock/photo_2.jpg'],
        ),
        InspectionChecklistItemModel(
          id: 'item_08',
          index: 8,
          name: '消防栓完好',
          status: InspectionItemStatus.normal,
        ),
        InspectionChecklistItemModel(
          id: 'item_09',
          index: 9,
          name: '排水溝暢通',
        ),
        InspectionChecklistItemModel(
          id: 'item_10',
          index: 10,
          name: '監控攝影機運作',
        ),
      ],
    );
  }

  @override
  Future<bool> submitReport(InspectionRouteEntity route) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1000));
    return true;
  }
}

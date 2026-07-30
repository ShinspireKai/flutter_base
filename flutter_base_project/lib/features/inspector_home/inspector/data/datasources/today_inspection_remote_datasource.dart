import '../../domain/entities/inspection_task_entity.dart';
import '../models/inspection_task_model.dart';

/// Abstract interface cho TodayInspection remote data source
abstract class TodayInspectionRemoteDataSource {
  Future<List<InspectionTaskModel>> getTodayInspections();
}

/// Mock implementation cho demo
class TodayInspectionRemoteDataSourceImpl
    implements TodayInspectionRemoteDataSource {
  @override
  Future<List<InspectionTaskModel>> getTodayInspections() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    final today = DateTime.now();
    DateTime at(int hour, int minute) =>
        DateTime(today.year, today.month, today.day, hour, minute);

    return [
      InspectionTaskModel(
        id: 'task_001',
        name: 'B1 設備巡檢',
        location: 'B1 機房區',
        scheduledTime: at(8, 00),
        status: InspectionTaskStatus.completed,
      ),
      InspectionTaskModel(
        id: 'task_002',
        name: '1-3F 公區',
        location: '1-3F',
        scheduledTime: at(10, 0),
        status: InspectionTaskStatus.completed,
      ),
      InspectionTaskModel(
        id: 'task_003',
        name: '4-6F 公區',
        location: '4-6F',
        scheduledTime: at(10, 30),
        status: InspectionTaskStatus.pending,
      ),
      InspectionTaskModel(
        id: 'task_004',
        name: 'B1 配電室',
        location: '地下室 B1',
        scheduledTime: at(11, 0),
        status: InspectionTaskStatus.overdue,
      ),
      InspectionTaskModel(
        id: 'task_005',
        name: '5F 空調機房',
        location: '5樓 機房',
        scheduledTime: at(14, 0),
        status: InspectionTaskStatus.pending,
      ),
    ];
  }
}

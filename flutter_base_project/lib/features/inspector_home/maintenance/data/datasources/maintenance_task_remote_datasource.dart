import '../../domain/entities/maintenance_task_entity.dart';
import '../models/maintenance_task_model.dart';

/// Abstract interface cho MaintenanceTask remote data source
abstract class MaintenanceTaskRemoteDataSource {
  Future<List<MaintenanceTaskModel>> getMaintenanceTasks();

  /// Cập nhật 1 nhiệm vụ (tiến độ / trạng thái / kết quả phúc kiểm)
  Future<void> updateMaintenanceTask(MaintenanceTaskModel task);

  /// Tra cứu nhiệm vụ theo 報修單 số (dùng cho luồng SMS + OTP của 外包廠商)
  Future<MaintenanceTaskModel?> getTaskByTicketNo(String ticketNo);

  /// Xác thực 進入代碼 (OTP) gửi kèm SMS — trả về true nếu đúng mã và còn hạn
  Future<bool> verifyTicketEntryCode(String ticketNo, String code);
}

/// Mock implementation cho demo — giữ state trong bộ nhớ (đây là
/// registerLazySingleton nên state sống suốt phiên app, giúp R1 phản ánh
/// đúng thay đổi sau khi quay về từ màn hình「維修回報」/「再維修」)
class MaintenanceTaskRemoteDataSourceImpl
    implements MaintenanceTaskRemoteDataSource {
  late final List<MaintenanceTaskModel> _tasks = _buildSeedTasks();

  /// 進入代碼 (OTP) theo 報修單 số — gửi kèm SMS khi phiếu được 派工 (mock demo)
  static const Map<String, String> _entryCodesByTicketNo = {'0523': '284913'};

  List<MaintenanceTaskModel> _buildSeedTasks() {
    final today = DateTime.now();
    DateTime onDay(int dayOffset) =>
        DateTime(today.year, today.month, today.day - dayOffset);
    DateTime onDayAt(int dayOffset, int hour, int minute) =>
        DateTime(today.year, today.month, today.day - dayOffset, hour, minute);

    return [
      MaintenanceTaskModel(
        id: 'maintenance_001',
        name: 'B1 電盤溫度偏高',
        location: 'B1 設備巡檢・#7',
        category: '電盤溫度',
        priority: MaintenanceTaskPriority.high,
        status: MaintenanceTaskStatus.pendingRecheck,
        assignedDate: onDay(0),
        reporterName: '林先生',
        reportedAt: onDayAt(0, 8, 32),
        reportDescription: '右側電盤溫度偏高',
        reportPhotoPaths: const [
          'mock/report_photo_1.jpg',
          'mock/report_photo_2.jpg',
        ],
        completionNote: '已更換散熱風扇',
        completionPhotoPaths: const ['mock/completion_photo_1.jpg'],
        completedAt: onDayAt(0, 14, 20),
      ),
      MaintenanceTaskModel(
        id: 'maintenance_002',
        name: '3F 天花板滲水',
        location: '1-3F 公區',
        category: '天花板滲水',
        priority: MaintenanceTaskPriority.medium,
        status: MaintenanceTaskStatus.pending,
        assignedDate: onDay(1),
        completionNote: '已更換防水膠條，滲水已止',
      ),
      MaintenanceTaskModel(
        id: 'maintenance_003',
        name: '2F 走道燈不亮',
        location: '1-3F 公區',
        category: '照明設備',
        priority: MaintenanceTaskPriority.medium,
        status: MaintenanceTaskStatus.pendingRecheck,
        assignedDate: onDay(0),
        reporterName: '陳小姐',
        reportedAt: onDayAt(0, 9, 0),
        reportDescription: '走道感應燈不會自動亮起',
        completionNote: '已更換感應器',
        completedAt: onDayAt(0, 13, 5),
      ),
      MaintenanceTaskModel(
        id: 'maintenance_004',
        name: 'B1 電盤溫度偏高',
        location: 'B1 設備巡檢・#7',
        category: '電盤溫度',
        priority: MaintenanceTaskPriority.high,
        status: MaintenanceTaskStatus.inProgress,
        assignedDate: onDay(1),
        reworkRound: 1,
        rejectionReason: '複檢不通過：溫度仍偏高，請更換壓縮機後再送複檢',
        rejectionReviewer: '林先生',
        rejectionAt: onDayAt(0, 16, 0),
        completionNote: '已更換壓縮機，溫度已恢復正常',
      ),
      MaintenanceTaskModel(
        id: 'maintenance_ext_0523',
        name: 'B1 電盤溫度偏高',
        location: 'B1 設備巡檢',
        category: '電盤溫度',
        priority: MaintenanceTaskPriority.high,
        status: MaintenanceTaskStatus.inProgress,
        assignedDate: DateTime(today.year, 5, 25, 9, 10),
        ticketNo: '0523',
        isExternalAssignment: true,
        reporterName: '大同機電',
        reportedAt: DateTime(today.year, 5, 25, 9, 10),
        reportDescription: '右側電盤溫度偏高',
        reportPhotoPaths: const [
          'mock/report_photo_1.jpg',
          'mock/report_photo_2.jpg',
        ],
        completionNote: '已更換散熱風扇，電盤溫度恢復正常',
      ),
    ];
  }

  @override
  Future<List<MaintenanceTaskModel>> getMaintenanceTasks() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    return List.unmodifiable(_tasks);
  }

  @override
  Future<void> updateMaintenanceTask(MaintenanceTaskModel task) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index == -1) return;
    _tasks[index] = task;
  }

  @override
  Future<MaintenanceTaskModel?> getTaskByTicketNo(String ticketNo) async {
    await Future.delayed(const Duration(milliseconds: 600));
    for (final task in _tasks) {
      if (task.ticketNo == ticketNo) return task;
    }
    return null;
  }

  @override
  Future<bool> verifyTicketEntryCode(String ticketNo, String code) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _entryCodesByTicketNo[ticketNo] == code;
  }
}

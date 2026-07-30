import '../models/inspector_profile_model.dart';

/// Abstract interface cho InspectorHome remote data source
abstract class InspectorHomeRemoteDataSource {
  Future<InspectorProfileModel> getUserProfile();
}

/// Mock implementation cho demo
class InspectorHomeRemoteDataSourceImpl
    implements InspectorHomeRemoteDataSource {
  @override
  Future<InspectorProfileModel> getUserProfile() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    return InspectorProfileModel(
      id: 'usr_001',
      name: '林先生',
      email: 'test@example.com',
      avatarUrl: null,
      jobTitle: '巡檢人員',
      joinedDate: DateTime(2024, 1, 15),
    );
  }
}

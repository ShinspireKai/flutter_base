import '../models/user_profile_model.dart';

/// Abstract interface cho Home remote data source
abstract class HomeRemoteDataSource {
  Future<UserProfileModel> getUserProfile();
}

/// Mock implementation cho demo
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  @override
  Future<UserProfileModel> getUserProfile() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    return UserProfileModel(
      id: 'usr_001',
      name: 'Nguyễn Văn A',
      email: 'test@example.com',
      avatarUrl: null,
      jobTitle: 'Flutter Developer',
      joinedDate: DateTime(2024, 1, 15),
    );
  }
}

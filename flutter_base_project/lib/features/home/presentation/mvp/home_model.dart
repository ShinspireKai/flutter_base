import '../../../../../mvp/BaseModel.dart';

/// HomeModel — tầng Model của MVP cho Home
///
/// Lưu trạng thái UI nhỏ không thuộc BLoC:
/// ví dụ: tab đang active, scroll position, cache nhỏ.
class HomeModel extends BaseModel {
  int selectedTabIndex = 0;

  @override
  void dispose() {
    selectedTabIndex = 0;
    super.dispose();
  }
}

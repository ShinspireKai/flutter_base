import '../../../../../mvp/BaseModel.dart';

/// InspectorHomeModel — tầng Model của MVP cho Home của 巡檢人員 (Inspector)
///
/// Lưu trạng thái UI nhỏ không thuộc BLoC:
/// ví dụ: tab đang active, scroll position, cache nhỏ.
class InspectorHomeModel extends BaseModel {
  int selectedTabIndex = 0;

  @override
  void dispose() {
    selectedTabIndex = 0;
    super.dispose();
  }
}

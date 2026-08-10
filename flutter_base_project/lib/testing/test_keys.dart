import 'package:flutter/widgets.dart';

/// TestKeys — nơi khai báo tập trung mọi [Key] gắn lên widget chỉ để phục vụ
/// test (integration_test/, patrol), không phục vụ logic UI.
///
/// Vì sao cần tập trung một chỗ thay vì rải `Key('...')` trong từng widget:
/// - Tránh trùng tên Key giữa các feature khác nhau (2 màn hình vô tình cùng
///   đặt `Key('submit_button')` sẽ khiến Finder ăn nhầm widget).
/// - `integration_test/pages/*_page_object.dart` chỉ cần import 1 file này
///   thay vì biết chuỗi Key nằm rải rác ở đâu trong `lib/features/`.
/// - Đổi tên Key chỉ sửa 1 chỗ, không phải tìm-và-thay trên nhiều file.
///
/// Quy ước đặt tên: `<feature>_<widget>` (snake_case, giống chuỗi Key gốc đã
/// dùng trong project trước đây) để không phải đổi Key hiện có khi migrate.
///
/// Khi thêm màn hình/feature mới cần test theo Key, thêm hằng số mới vào đây
/// rồi gắn vào đúng widget trong `lib/features/`, thay vì viết `Key('...')`
/// trực tiếp trong widget.
abstract final class TestKeys {
  // ─── Auth / LoginPage ───────────────────────────────────────────────────
  static const loginPageScaffold = Key('login_page_scaffold');
  static const loginCompanyCodeField = Key('login_company_code_field');
  static const loginAccountField = Key('login_account_field');
  static const loginPasswordField = Key('login_password_field');
  static const loginSubmitButton = Key('login_submit_button');

  // ─── InspectorHome ──────────────────────────────────────────────────────
  static const inspectorHomePageScaffold = Key(
    'inspector_home_page_scaffold',
  );
}

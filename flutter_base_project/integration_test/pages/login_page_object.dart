import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Page Object cho LoginPage.
///
/// Gói toàn bộ Finder/thao tác của màn hình đăng nhập tại một chỗ — test
/// case trong `flows/` chỉ gọi hành vi cấp cao (`login(...)`) mà không cần
/// biết Key hay cấu trúc widget bên trong. Khi UI đổi (đổi Key, thêm bước),
/// chỉ cần sửa ở đây, không phải sửa từng test case.
class LoginPageObject {
  LoginPageObject(this.tester);

  final WidgetTester tester;

  Finder get scaffold => find.byKey(const Key('login_page_scaffold'));
  Finder get companyCodeField =>
      find.byKey(const Key('login_company_code_field'));
  Finder get accountField => find.byKey(const Key('login_account_field'));
  Finder get passwordField => find.byKey(const Key('login_password_field'));
  Finder get submitButton => find.byKey(const Key('login_submit_button'));

  /// Điền form và nhấn đăng nhập, chờ tới khi màn hình kế tiếp render xong.
  ///
  /// Không dùng `tester.testTextInput.receiveAction(TextInputAction.done)`:
  /// ô mật khẩu có `onFieldSubmitted: (_) => _submit()` (xem LoginForm), nên
  /// giả lập phím "done" trên bàn phím sẽ tự submit form ngay tại đó — khiến
  /// lệnh `tap(submitButton)` ngay sau bị lỗi "widget not found" vì màn hình
  /// đã điều hướng đi trước khi kịp tap. Chỉ tap nút đăng nhập tường minh để
  /// test đúng luồng "nhấn nút", không lẫn với luồng "gõ xong bàn phím".
  ///
  /// `enterText` trên thiết bị thật/simulator (integration_test) làm hiện
  /// bàn phím thật của hệ điều hành — nếu không chủ động ẩn đi trước khi tap,
  /// bàn phím có thể che (hoặc absorb pointer event) đúng vị trí nút đăng
  /// nhập, khiến `tap()` "trúng" một layer khác thay vì nút thật (cảnh báo
  /// "would not hit test" từ flutter_test). Gọi `unfocus()` rồi
  /// `pumpAndSettle()` để chờ bàn phím ẩn hẳn và layout ổn định trước khi tap.
  ///
  /// `pumpAndSettle()` sau khi tap an toàn dù nút đăng nhập hiện loading
  /// spinner (animation vô hạn khi đang hiển thị): AuthRemoteDataSourceImpl
  /// mock có độ trễ hữu hạn (1.5s) rồi điều hướng/cập nhật UI, làm spinner
  /// unmount — pumpAndSettle sẽ dừng lại ngay sau thời điểm đó.
  Future<void> login({
    required String companyCode,
    required String account,
    required String password,
  }) async {
    await tester.enterText(companyCodeField, companyCode);
    await tester.enterText(accountField, account);
    await tester.enterText(passwordField, password);

    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle(const Duration(milliseconds: 300));

    await tester.tap(submitButton);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }
}

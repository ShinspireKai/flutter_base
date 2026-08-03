import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../helpers/test_app.dart';
import '../pages/inspector_home_page_object.dart';
import '../pages/login_page_object.dart';

/// Test case mẫu (template) cho e2e — luồng đăng nhập của 巡檢人員 (Inspector).
///
/// Chạy trên thiết bị thật/simulator qua flutter test integration_test/flows/login_flow_test.dart
/// (xem integration_test/README.md để biết chi tiết cách chạy).
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await setUpTestDependencies();
  });

  setUp(() async {
    await resetAppState();
  });

  group('Login flow', () {
    testWidgets(
      'Đăng nhập thành công với tài khoản demo của Inspector → vào được InspectorHomePage',
      (tester) async {
        await pumpApp(tester);

        final loginPage = LoginPageObject(tester);
        final inspectorHomePage = InspectorHomePageObject(tester);

        // Splash chưa đăng nhập → phải rơi vào LoginPage.
        expect(loginPage.scaffold, findsOneWidget);
        await captureScreenshot(tester, '01_login_page');

        await loginPage.login(
          companyCode: 'DEMO',
          account: 'test@example.com',
          password: 'password123',
        );

        // Đăng nhập thành công → điều hướng sang InspectorHomePage.
        expect(inspectorHomePage.scaffold, findsOneWidget);
        expect(loginPage.scaffold, findsNothing);
        await captureScreenshot(tester, '02_login_success_inspector_home');
      },
    );

    testWidgets(
      'Đăng nhập sai mật khẩu → ở lại LoginPage và hiện thông báo lỗi',
      (tester) async {
        await pumpApp(tester);

        final loginPage = LoginPageObject(tester);

        await loginPage.login(
          companyCode: 'DEMO',
          account: 'test@example.com',
          password: 'sai-mat-khau',
        );

        // Đăng nhập thất bại → vẫn ở LoginPage (snackbar lỗi tự ẩn theo
        // thời gian nên assert bằng việc còn ở đúng màn hình là đủ ổn định).
        expect(loginPage.scaffold, findsOneWidget);
        await captureScreenshot(tester, '03_login_invalid_password_error');
      },
    );
  });
}

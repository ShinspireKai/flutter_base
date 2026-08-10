import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import 'package:inspection_app/testing/fixtures/auth_fixtures.dart';

import '../helpers/test_app.dart';
import '../pages/inspector_home_page_object.dart';
import '../pages/login_page_object.dart';

/// Test case mẫu (template) cho e2e — luồng đăng nhập của 巡檢人員 (Inspector).
///
/// Viết bằng Patrol (`patrolTest` + `PatrolIntegrationTester $`) thay vì
/// `testWidgets` thuần của `flutter_test` — xem `integration_test/README.md`
/// mục "Patrol" để biết lý do và cách chạy (`patrol test` / `flutter test`).
///
/// `patrolTest` tự gọi `IntegrationTestWidgetsFlutterBinding.ensureInitialized()`
/// bên trong, nên KHÔNG cần tự gọi lại như khi dùng `testWidgets`.
void main() {
  setUpAll(() async {
    await setUpTestDependencies();
  });

  setUp(() async {
    await resetAppState();
  });

  group('Login flow', () {
    patrolTest(
      'Đăng nhập thành công với tài khoản demo của Inspector → vào được InspectorHomePage',
      ($) async {
        await pumpApp($);

        final loginPage = LoginPageObject($);
        final inspectorHomePage = InspectorHomePageObject($);

        // Splash chưa đăng nhập → phải rơi vào LoginPage.
        expect(loginPage.scaffold, findsOneWidget);
        await captureScreenshot($, '01_login_page');

        await loginPage.login(
          companyCode: AuthFixtures.demoCompanyCode,
          account: AuthFixtures.demoInspectorEmail,
          password: AuthFixtures.demoInspectorPassword,
        );

        // Đăng nhập thành công → điều hướng sang InspectorHomePage.
        expect(inspectorHomePage.scaffold, findsOneWidget);
        expect(loginPage.scaffold, findsNothing);
        await captureScreenshot($, '02_login_success_inspector_home');
      },
    );

    patrolTest(
      'Đăng nhập sai mật khẩu → ở lại LoginPage và hiện thông báo lỗi',
      ($) async {
        await pumpApp($);

        final loginPage = LoginPageObject($);

        await loginPage.login(
          companyCode: AuthFixtures.demoCompanyCode,
          account: AuthFixtures.demoInspectorEmail,
          password: 'sai-mat-khau',
        );

        // Đăng nhập thất bại → vẫn ở LoginPage (snackbar lỗi tự ẩn theo
        // thời gian nên assert bằng việc còn ở đúng màn hình là đủ ổn định).
        expect(loginPage.scaffold, findsOneWidget);
        await captureScreenshot($, '03_login_invalid_password_error');
      },
    );
  });
}

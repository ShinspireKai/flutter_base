import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:inspection_app/core/di.dart';
import 'package:inspection_app/core/di/features_di.dart';
import 'package:inspection_app/core/router/guard/init_guard.dart';
import 'package:inspection_app/features/auth/domain/usecases/check_login_status_usecase.dart';
import 'package:inspection_app/main.dart';

/// Đăng ký DI (GetIt) một lần cho toàn bộ file test — gọi trong `setUpAll`.
///
/// Không gọi `main()` thật của app: `main()` còn init Firebase, push
/// notification permission và deep link listener, những thứ cần thiết bị
/// thật/mock riêng và không thuộc phạm vi UI e2e (permission dialog của hệ
/// điều hành có thể treo test). Ta chỉ cần DI + `MyApp` để lái luồng UI.
///
/// Vẫn phải gọi `InitGuard.markReady()` như `main()` làm — router có
/// `InitGuard` chặn MỌI điều hướng (kể cả route đầu tiên) cho tới khi hàm
/// này được gọi; bỏ qua bước này sẽ khiến app đứng ở màn hình trắng vĩnh
/// viễn dù không có lỗi/spinner nào để `pumpAndSettle()` phát hiện.
///
/// Idempotent: gọi nhiều lần trong cùng 1 test process (nhiều `setUpAll`
/// của nhiều flow) sẽ không đăng ký trùng vào GetIt.
Future<void> setUpTestDependencies() async {
  if (sl.isRegistered<CheckLoginStatusUseCase>()) return;
  await configureDependencies();
  await setupFeaturesDI(sl);
  InitGuard.markReady();
}

/// Xoá sạch SharedPreferences trước mỗi test — đảm bảo app luôn khởi động
/// ở trạng thái "chưa đăng nhập" (splash → LoginPage), không phụ thuộc vào
/// dữ liệu phiên trước để lại trên cùng thiết bị/simulator.
Future<void> resetAppState() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  _androidSurfaceConverted = false;
}

/// Dựng `MyApp` và chờ splash (`MainAppPage`) điều hướng xong tới màn hình
/// đầu tiên (LoginPage nếu `resetAppState()` đã được gọi trước đó).
Future<void> pumpApp(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  // Splash chờ 800ms trước khi kiểm tra login status (xem MainAppPage) rồi
  // mới replace route — pumpAndSettle để chờ toàn bộ chuỗi này hoàn tất.
  await tester.pumpAndSettle(const Duration(milliseconds: 900));
}

bool _androidSurfaceConverted = false;

/// Chụp màn hình hiện tại và đặt tên `name` — chỉ có tác dụng khi chạy qua
/// `flutter drive` (xem `test_driver/integration_test.dart`): driver sẽ ghi
/// các ảnh này ra `integration_test/reports/<run>/screenshots/*.png` và gom
/// vào `report.html` sau khi test chạy xong.
///
/// Khi chạy bằng `flutter test` (không qua driver), lệnh vẫn thực thi nhưng
/// ảnh chụp không được driver nào lấy ra để ghi file — dùng để debug tại
/// chỗ là chính, muốn có report ảnh phải chạy qua `flutter drive`.
///
/// Android yêu cầu convert surface sang image trước lần chụp đầu tiên của
/// mỗi test (`convertFlutterSurfaceToImage`) — các platform khác bỏ qua.
/// Nền tảng không hỗ trợ chụp màn hình (vd desktop) sẽ log cảnh báo thay vì
/// làm fail cả test, vì ảnh chụp chỉ là bằng chứng đính kèm, không phải
/// assertion của test case.
Future<void> captureScreenshot(WidgetTester tester, String name) async {
  final binding = IntegrationTestWidgetsFlutterBinding.instance;
  try {
    if (Platform.isAndroid && !_androidSurfaceConverted) {
      await binding.convertFlutterSurfaceToImage();
      await tester.pumpAndSettle();
      _androidSurfaceConverted = true;
    }
    await binding.takeScreenshot(name);
  } catch (e) {
    debugPrint('captureScreenshot("$name") skipped — not supported here: $e');
  }
}

import 'dart:io';
import 'dart:typed_data';

import 'package:integration_test/integration_test_driver.dart';

/// Driver entrypoint bắt buộc khi chạy e2e bằng `flutter drive` thay vì
/// `flutter test` — cần cho target Web và cho CI/device farm (vd. Firebase
/// Test Lab) không hỗ trợ `flutter test integration_test/...` trực tiếp.
///
/// Ngoài chạy test, entrypoint này còn xuất **báo cáo hình ảnh**: mọi lệnh
/// `captureScreenshot(tester, name)` gọi trong `integration_test/flows/*`
/// (xem `integration_test/helpers/test_app.dart`) được driver gom lại và
/// ghi ra `integration_test/reports/<run>/` — xem
/// `integration_test/README.md` mục "Báo cáo hình ảnh/video".
///
/// Cách dùng:
///   flutter drive \
///     --driver=test_driver/integration_test.dart \
///     --target=integration_test/flows/login_flow_test.dart \
///     -d `device-id`
Future<void> main() => integrationDriver(responseDataCallback: _writeScreenshotReport);

Future<void> _writeScreenshotReport(Map<String, dynamic>? data) async {
  final screenshots = (data?['screenshots'] as List<dynamic>?) ?? const <dynamic>[];

  final runStamp = DateTime.now().toIso8601String().replaceAll(RegExp('[:.]'), '-');
  final reportDir = Directory('integration_test/reports/$runStamp');
  final screenshotsDir = Directory('${reportDir.path}/screenshots');
  await screenshotsDir.create(recursive: true);

  final savedFiles = <String>[];
  for (final raw in screenshots) {
    final entry = (raw as Map<dynamic, dynamic>).cast<String, dynamic>();
    final name = entry['screenshotName'] as String;
    final bytes = (entry['bytes'] as List<dynamic>).cast<int>();
    final fileName = '$name.png';
    await File('${screenshotsDir.path}/$fileName').writeAsBytes(Uint8List.fromList(bytes));
    savedFiles.add(fileName);
  }

  await File('${reportDir.path}/report.html').writeAsString(_buildReportHtml(runStamp, savedFiles));

  if (savedFiles.isEmpty) {
    stdout.writeln(
      'Không có screenshot nào được chụp — flow test có gọi captureScreenshot(...) không?',
    );
  } else {
    stdout.writeln('Đã ghi báo cáo ảnh e2e vào ${reportDir.path}/report.html');
  }
}

String _buildReportHtml(String runStamp, List<String> fileNames) {
  final figures = fileNames
      .map(
        (f) => '<figure>'
            '<img src="screenshots/$f" loading="lazy">'
            '<figcaption>$f</figcaption>'
            '</figure>',
      )
      .join('\n');

  return '''
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>E2E screenshot report — $runStamp</title>
<style>
  body { font-family: -apple-system, sans-serif; background: #111; color: #eee; padding: 24px; }
  h1 { font-size: 20px; }
  .gallery { display: flex; flex-wrap: wrap; gap: 16px; }
  figure { margin: 0; text-align: center; background: #1c1c1c; padding: 10px; border-radius: 10px; }
  img { max-width: 260px; max-height: 520px; border-radius: 6px; display: block; }
  figcaption { margin-top: 8px; font-size: 12px; color: #aaa; }
</style>
</head>
<body>
  <h1>E2E screenshot report</h1>
  <p>Run: $runStamp — ${fileNames.length} screenshot(s)</p>
  <div class="gallery">
    $figures
  </div>
</body>
</html>
''';
}

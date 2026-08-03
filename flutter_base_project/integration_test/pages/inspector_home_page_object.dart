import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Page Object cho InspectorHomePage — trang chủ của 巡檢人員 (Inspector)
/// sau khi đăng nhập thành công.
class InspectorHomePageObject {
  InspectorHomePageObject(this.tester);

  final WidgetTester tester;

  Finder get scaffold => find.byKey(const Key('inspector_home_page_scaffold'));
}

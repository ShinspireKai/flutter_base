import 'package:patrol/patrol.dart';

import 'package:inspection_app/testing/test_keys.dart';

/// Page Object cho InspectorHomePage — trang chủ của 巡檢人員 (Inspector)
/// sau khi đăng nhập thành công.
class InspectorHomePageObject {
  InspectorHomePageObject(this.$);

  final PatrolIntegrationTester $;

  PatrolFinder get scaffold => $(TestKeys.inspectorHomePageScaffold);
}

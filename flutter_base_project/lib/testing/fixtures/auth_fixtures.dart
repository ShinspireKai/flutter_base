/// AuthFixtures — dữ liệu demo dùng chung giữa mock datasource (tầng data,
/// xem `AuthRemoteDataSourceImpl`) và test (integration_test/, patrol).
///
/// Một nguồn sự thật duy nhất: mock datasource seed đúng những tài khoản này,
/// còn test/flow đăng nhập bằng đúng những tài khoản này — sửa mật khẩu/role
/// demo chỉ cần sửa 1 chỗ, không phải đồng bộ tay giữa `lib/` và
/// `integration_test/`.
abstract final class AuthFixtures {
  // ─── 巡檢人員 (Inspector) ────────────────────────────────────────────────
  static const demoInspectorEmail = 'test@example.com';
  static const demoInspectorPassword = 'password123';
  static const demoInspectorId = 'usr_001';
  static const demoInspectorName = '林先生';
  static const demoInspectorRole = '巡檢人員';

  // ─── 維修人員 / 外包廠商 (Contractor) ────────────────────────────────────
  static const demoContractorEmail = 'contractor@example.com';
  static const demoContractorPassword = 'password123';
  static const demoContractorId = 'usr_002';
  static const demoContractorName = '林先生 2';
  static const demoContractorRole = 'contractor';

  /// Mã công ty demo hiển thị trên LoginPage — không được mock datasource
  /// kiểm tra giá trị (chỉ bắt buộc nhập, xem `LoginForm`), giữ ở đây để
  /// test không phải hardcode chuỗi tuỳ ý.
  static const demoCompanyCode = 'DEMO';
}

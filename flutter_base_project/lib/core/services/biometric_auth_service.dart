import 'package:local_auth/local_auth.dart';

/// BiometricAuthService — bọc [LocalAuthentication] của plugin `local_auth`
///
/// Single Responsibility: chỉ lo việc hỏi hệ điều hành xác thực sinh trắc học
/// (vân tay / Face ID / khuôn mặt) — không biết gì về user, token hay bloc.
abstract class BiometricAuthService {
  /// Thiết bị có hỗ trợ và đã thiết lập sinh trắc học hay không
  Future<bool> get isAvailable;

  /// Yêu cầu hệ điều hành hiển thị màn hình xác thực sinh trắc học
  /// Trả về `true` nếu xác thực thành công, `false` nếu thất bại/huỷ
  Future<bool> authenticate({required String reason});
}

class BiometricAuthServiceImpl implements BiometricAuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  Future<bool> get isAvailable async {
    try {
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      return canCheckBiometrics && isDeviceSupported;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> authenticate({required String reason}) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } catch (_) {
      return false;
    }
  }
}

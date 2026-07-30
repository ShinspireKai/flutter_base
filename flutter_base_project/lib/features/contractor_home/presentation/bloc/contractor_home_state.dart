import 'package:equatable/equatable.dart';

import '../../../inspector_home/maintenance/domain/entities/maintenance_task_entity.dart';

/// ContractorHome States — 「維修單回報」màn hình xác thực OTP không cần
/// tài khoản dành cho 外包廠商 (nhà thầu ngoài), vào từ link SMS/Email.
abstract class ContractorHomeState extends Equatable {
  const ContractorHomeState();

  @override
  List<Object?> get props => [];
}

/// Chưa có số phiếu (không phải vào từ link SMS/Email hợp lệ)
class ContractorHomeMissingTicket extends ContractorHomeState {
  const ContractorHomeMissingTicket();
}

/// Đang tra cứu 報修單 theo số phiếu trong URL
class ContractorHomeLoading extends ContractorHomeState {
  const ContractorHomeLoading();
}

/// Không tìm thấy 報修單 tương ứng số phiếu
class ContractorHomeTicketNotFound extends ContractorHomeState {
  const ContractorHomeTicketNotFound();
}

/// Đã tải được 報修單 — sẵn sàng cho user nhập 進入代碼
class ContractorHomeLoaded extends ContractorHomeState {
  final MaintenanceTaskEntity ticket;
  final String code;
  final bool isVerifying;
  final bool hasInvalidCodeError;

  const ContractorHomeLoaded({
    required this.ticket,
    this.code = '',
    this.isVerifying = false,
    this.hasInvalidCodeError = false,
  });

  ContractorHomeLoaded copyWith({
    String? code,
    bool? isVerifying,
    bool? hasInvalidCodeError,
  }) {
    return ContractorHomeLoaded(
      ticket: ticket,
      code: code ?? this.code,
      isVerifying: isVerifying ?? this.isVerifying,
      hasInvalidCodeError: hasInvalidCodeError ?? this.hasInvalidCodeError,
    );
  }

  @override
  List<Object?> get props => [ticket, code, isVerifying, hasInvalidCodeError];
}

/// 進入代碼 xác thực thành công — trigger điều hướng sang「維修回報」
class ContractorHomeVerified extends ContractorHomeState {
  final MaintenanceTaskEntity ticket;

  const ContractorHomeVerified(this.ticket);

  @override
  List<Object?> get props => [ticket];
}

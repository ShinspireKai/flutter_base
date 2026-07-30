import 'package:equatable/equatable.dart';

/// ContractorHome Events — 「維修單回報」màn hình xác thực OTP không cần
/// tài khoản dành cho 外包廠商 (nhà thầu ngoài), vào từ link SMS/Email.
abstract class ContractorHomeEvent extends Equatable {
  const ContractorHomeEvent();

  @override
  List<Object?> get props => [];
}

/// Tra cứu 報修單 theo số phiếu trích từ URL (vd `?no=0523`)
class ContractorHomeTicketRequested extends ContractorHomeEvent {
  final String ticketNo;

  const ContractorHomeTicketRequested(this.ticketNo);

  @override
  List<Object?> get props => [ticketNo];
}

/// User nhập 進入代碼 (OTP)
class ContractorHomeCodeChanged extends ContractorHomeEvent {
  final String code;

  const ContractorHomeCodeChanged(this.code);

  @override
  List<Object?> get props => [code];
}

/// User nhấn 確認進入
class ContractorHomeConfirmPressed extends ContractorHomeEvent {
  const ContractorHomeConfirmPressed();
}

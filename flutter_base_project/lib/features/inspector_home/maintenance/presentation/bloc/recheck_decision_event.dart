import 'package:equatable/equatable.dart';

/// RecheckDecision Events — màn hình「異常複檢」(C2)
abstract class RecheckDecisionEvent extends Equatable {
  const RecheckDecisionEvent();

  @override
  List<Object?> get props => [];
}

/// Kết quả phúc kiểm — 通過 (đạt) hoặc 不通過 (không đạt)
enum RecheckResult { approved, rejected }

/// User chọn kết quả phúc kiểm (toggle 通過/不通過)
class RecheckDecisionResultChanged extends RecheckDecisionEvent {
  final RecheckResult result;

  const RecheckDecisionResultChanged(this.result);

  @override
  List<Object?> get props => [result];
}

/// User chỉnh sửa 複檢說明
class RecheckDecisionNoteChanged extends RecheckDecisionEvent {
  final String note;

  const RecheckDecisionNoteChanged({required this.note});

  @override
  List<Object?> get props => [note];
}

/// User nhấn「送出複檢」(đã được Presenter xác nhận đã nhập 複檢說明)
class RecheckDecisionSubmitted extends RecheckDecisionEvent {
  const RecheckDecisionSubmitted();
}

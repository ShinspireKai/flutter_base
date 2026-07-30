import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../inspector_home/maintenance/domain/usecases/get_maintenance_task_by_ticket_no_usecase.dart';
import '../../../inspector_home/maintenance/domain/usecases/verify_ticket_entry_code_usecase.dart';
import 'contractor_home_event.dart';
import 'contractor_home_state.dart';

/// ContractorHomeBloc — quản lý state màn hình「維修單回報」(V1), luồng
/// xác thực OTP không cần tài khoản dành cho 外包廠商 (nhà thầu ngoài).
///
/// Events → States:
///   ContractorHomeTicketRequested → ContractorHomeLoading → ContractorHomeLoaded | ContractorHomeTicketNotFound
///   ContractorHomeCodeChanged     → ContractorHomeLoaded(code: ...)
///   ContractorHomeConfirmPressed  → ContractorHomeLoaded(isVerifying: true) → ContractorHomeVerified | ContractorHomeLoaded(errorMessage: ...)
class ContractorHomeBloc
    extends Bloc<ContractorHomeEvent, ContractorHomeState> {
  final GetMaintenanceTaskByTicketNoUseCase _getTaskByTicketNoUseCase;
  final VerifyTicketEntryCodeUseCase _verifyTicketEntryCodeUseCase;

  ContractorHomeBloc({
    required GetMaintenanceTaskByTicketNoUseCase getTaskByTicketNoUseCase,
    required VerifyTicketEntryCodeUseCase verifyTicketEntryCodeUseCase,
  })  : _getTaskByTicketNoUseCase = getTaskByTicketNoUseCase,
        _verifyTicketEntryCodeUseCase = verifyTicketEntryCodeUseCase,
        super(const ContractorHomeMissingTicket()) {
    on<ContractorHomeTicketRequested>(_onTicketRequested);
    on<ContractorHomeCodeChanged>(_onCodeChanged);
    on<ContractorHomeConfirmPressed>(_onConfirmPressed);
  }

  Future<void> _onTicketRequested(
    ContractorHomeTicketRequested event,
    Emitter<ContractorHomeState> emit,
  ) async {
    emit(const ContractorHomeLoading());
    final result = await _getTaskByTicketNoUseCase(
      GetMaintenanceTaskByTicketNoParams(ticketNo: event.ticketNo),
    );
    result.fold(
      (failure) => emit(const ContractorHomeTicketNotFound()),
      (ticket) => emit(ContractorHomeLoaded(ticket: ticket)),
    );
  }

  void _onCodeChanged(
    ContractorHomeCodeChanged event,
    Emitter<ContractorHomeState> emit,
  ) {
    final current = state;
    if (current is ContractorHomeLoaded) {
      emit(current.copyWith(code: event.code, hasInvalidCodeError: false));
    }
  }

  Future<void> _onConfirmPressed(
    ContractorHomeConfirmPressed event,
    Emitter<ContractorHomeState> emit,
  ) async {
    final current = state;
    if (current is! ContractorHomeLoaded) return;

    emit(current.copyWith(isVerifying: true, hasInvalidCodeError: false));
    final result = await _verifyTicketEntryCodeUseCase(
      VerifyTicketEntryCodeParams(
        ticketNo: current.ticket.ticketNo!,
        code: current.code,
      ),
    );
    result.fold(
      (failure) => emit(current.copyWith(isVerifying: false)),
      (isValid) {
        if (isValid) {
          emit(ContractorHomeVerified(current.ticket));
        } else {
          emit(
            current.copyWith(isVerifying: false, hasInvalidCodeError: true),
          );
        }
      },
    );
  }
}

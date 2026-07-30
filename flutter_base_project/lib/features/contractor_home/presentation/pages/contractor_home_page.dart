import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../mvp/BaseView.dart';
import '../../../../core/di.dart';
import '../../../../core/gen/colors.gen.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/auto_route_config.dart';
import '../../../../util/widgets/common_app_bar.dart';
import '../../../../util/widgets/custom_text_field.dart';
import '../../../inspector_home/maintenance/domain/entities/maintenance_task_entity.dart';
import '../../../inspector_home/maintenance/domain/usecases/get_maintenance_task_by_ticket_no_usecase.dart';
import '../../../inspector_home/maintenance/domain/usecases/verify_ticket_entry_code_usecase.dart';
import '../bloc/contractor_home_bloc.dart';
import '../bloc/contractor_home_event.dart';
import '../bloc/contractor_home_state.dart';
import '../mvp/contractor_home_presenter.dart';
import '../mvp/i_contractor_home_view.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ContractorHomePage — BaseView (MVP View) cho「維修單回報」(V1)
//
// Điểm vào đầu tiên cho 維修人員 / 外包廠商 (nhà thầu ngoài): mở từ link
// SMS/Email chứa sẵn số phiếu (?no=0523), nhập 進入代碼 (OTP) nhận qua SMS
// để xác thực — không cần tài khoản. Xác thực xong điều hướng thẳng sang
// 「維修回報」của đúng phiếu đó.
// ─────────────────────────────────────────────────────────────────────────────

@RoutePage()
class ContractorHomePage extends BaseView {
  final String? ticketNo;

  const ContractorHomePage({super.key, this.ticketNo});

  @override
  State<ContractorHomePage> createState() => _ContractorHomePageState();
}

class _ContractorHomePageState
    extends BaseViewState<ContractorHomePresenter, ContractorHomePage>
    implements IContractorHomeView {
  late final ContractorHomeBloc _bloc = ContractorHomeBloc(
    getTaskByTicketNoUseCase: sl<GetMaintenanceTaskByTicketNoUseCase>(),
    verifyTicketEntryCodeUseCase: sl<VerifyTicketEntryCodeUseCase>(),
  );
  late final TextEditingController _codeController = TextEditingController();
  late final FocusNode _codeFocusNode = FocusNode();

  // ─── MVP ──────────────────────────────────────────────────────────────────

  @override
  ContractorHomePresenter createPresenter() => ContractorHomePresenter();

  @override
  void afterInit() {
    final ticketNo = widget.ticketNo;
    if (ticketNo != null && ticketNo.isNotEmpty) {
      _bloc.add(ContractorHomeTicketRequested(ticketNo));
    }
  }

  @override
  void dispose() {
    _bloc.close();
    _codeController.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }

  // ─── IContractorHomeView implementation ───────────────────────────────────

  @override
  void navigateToRepairReport(MaintenanceTaskEntity ticket) {
    final PageRouteInfo route = ticket.reworkRound > 0
        ? MaintenanceReworkRoute(task: ticket)
        : MaintenanceReportRoute(task: ticket);
    context.router.push(route);
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget buildView(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocProvider.value(
        value: _bloc,
        child: BlocListener<ContractorHomeBloc, ContractorHomeState>(
          listener: (ctx, state) {
            if (state is ContractorHomeVerified) {
              presenter?.onVerified(state.ticket);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.contractorEntryTitle),
              titleTextStyle: TextStyle(
                color: ColorName.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            body: SafeArea(
              child: BlocBuilder<ContractorHomeBloc, ContractorHomeState>(
                builder: (context, state) {
                  if (state is ContractorHomeMissingTicket) {
                    return _buildMessageView(
                      icon: Icons.link_off_rounded,
                      message: AppLocalizations.of(
                        context,
                      )!.contractorEntryMissingTicket,
                    );
                  }
                  if (state is ContractorHomeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is ContractorHomeTicketNotFound) {
                    return _buildMessageView(
                      icon: Icons.search_off_rounded,
                      message: AppLocalizations.of(
                        context,
                      )!.contractorEntryTicketNotFound,
                    );
                  }
                  if (state is ContractorHomeLoaded) {
                    return _buildForm(state);
                  }
                  // ContractorHomeVerified — điều hướng đang diễn ra qua listener
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageView({required IconData icon, required String message}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 52, color: ColorName.colorTextGrey),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: ColorName.colorTextGrey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(ContractorHomeLoaded state) {
    final l10n = AppLocalizations.of(context)!;
    final ticket = state.ticket;
    final isConfirmEnabled = state.code.length == 6 && !state.isVerifying;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInstructionBlock(ticket.ticketNo!),
          const SizedBox(height: 20),
          _buildTicketInfoTable(ticket),
          const SizedBox(height: 24),
          CustomTextField(
            labelText: l10n.contractorEntryCodeLabel,
            labelTextStyle: TextStyle(
              fontSize: 16,
              color: ColorName.colorTextGrey,
            ),
            controller: _codeController,
            focusNode: _codeFocusNode,
            hintText: l10n.contractorEntryCodeHint,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            onChanged: (value) => presenter?.onCodeChanged(_bloc, value.trim()),
            onFieldSubmitted: (_) {
              _codeFocusNode.unfocus();
              if (isConfirmEnabled) presenter?.onConfirmPressed(_bloc);
            },
          ),
          if (state.hasInvalidCodeError) ...[
            const SizedBox(height: 8),
            Text(
              l10n.contractorEntryInvalidCode,
              style: TextStyle(fontSize: 13, color: ColorName.redDanger),
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: isConfirmEnabled
                  ? () {
                      _codeFocusNode.unfocus();
                      presenter?.onConfirmPressed(_bloc);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorName.bluePrimary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: ColorName.bluePrimary.withValues(
                  alpha: 0.4,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: state.isVerifying
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      l10n.contractorEntryConfirmButton,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.contractorEntryFootnote,
            style: TextStyle(fontSize: 12, color: ColorName.colorTextGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionBlock(String ticketNo) {
    final l10n = AppLocalizations.of(context)!;
    final baseStyle = TextStyle(fontSize: 13, color: ColorName.colorTextGrey);
    final example = l10n.contractorEntryInstructionExample(ticketNo);
    final needle = 'no=$ticketNo';
    final needleIndex = example.indexOf(needle);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColorName.bgAddPhoto,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.contractorEntryInstructionLine1, style: baseStyle),
          const SizedBox(height: 6),
          needleIndex == -1
              ? Text(example, style: baseStyle)
              : RichText(
                  text: TextSpan(
                    style: baseStyle,
                    children: [
                      TextSpan(text: example.substring(0, needleIndex)),
                      TextSpan(
                        text: example.substring(
                          needleIndex,
                          needleIndex + needle.length,
                        ),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(
                        text: example.substring(needleIndex + needle.length),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildTicketInfoTable(MaintenanceTaskEntity ticket) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: ColorName.bgInforBox,
        border: Border.all(color: ColorName.borderOutline),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _buildTicketInfoRow(
            l10n.contractorEntryTicketNoLabel,
            '#${ticket.ticketNo}',
          ),
          _buildTicketInfoRow(l10n.contractorEntryIssueLabel, ticket.name),

          _buildTicketInfoRow(
            l10n.contractorEntryAssignedContractorLabel,
            ticket.reporterName ?? '',
          ),
        ],
      ),
    );
  }

  Widget _buildTicketInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, color: ColorName.colorTextGrey),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

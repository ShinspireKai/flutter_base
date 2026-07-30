import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspection_app/core/di.dart';
import 'package:inspection_app/core/gen/colors.gen.dart';
import 'package:inspection_app/core/router/auto_route_config.dart';
import 'package:inspection_app/util/widgets/dashed_border_painter.dart';

import '../../../../../../mvp/BaseView.dart';
import '../../../../../core/l10n/app_localizations.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../auth/domain/usecases/get_cached_user_usecase.dart';
import '../../domain/entities/inspection_route_entity.dart';
import '../bloc/equipment_inspection_bloc.dart';
import '../bloc/equipment_inspection_state.dart';
import '../widgets/signature_pad.dart';
import '../mvp/signature_confirmation_presenter.dart';
import '../mvp/i_signature_confirmation_view.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SignatureConfirmationPage — BaseView (MVP View) cho màn hình「簽名確認」
// Trang cuối cùng của quy trình tuần tra thiết bị, mở khi nhấn「送出巡檢報告」
// trong màn hình「B1 設備巡檢」— dùng chung EquipmentInspectionBloc được
// truyền vào để gửi báo cáo qua đúng bloc đã tải checklist.
// ─────────────────────────────────────────────────────────────────────────────

@RoutePage()
class SignatureConfirmationPage extends BaseView {
  final EquipmentInspectionBloc bloc;

  const SignatureConfirmationPage({super.key, required this.bloc});

  @override
  State<SignatureConfirmationPage> createState() =>
      _SignatureConfirmationPageState();
}

class _SignatureConfirmationPageState
    extends
        BaseViewState<SignatureConfirmationPresenter, SignatureConfirmationPage>
    implements ISignatureConfirmationView {
  final _signatureController = SignaturePadController();
  String? _signerName;

  @override
  SignatureConfirmationPresenter createPresenter() =>
      SignatureConfirmationPresenter();

  @override
  void afterInit() {
    _loadSignerName();
  }

  Future<void> _loadSignerName() async {
    final result = await sl<GetCachedUserUseCase>()(NoParams());
    result.fold((_) => null, (user) {
      if (mounted) setState(() => _signerName = user.name);
    });
  }

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  // ─── ISignatureConfirmationView implementation ────────────────────────────

  @override
  void showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  @override
  void showSignatureRequiredWarning() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.signatureRequiredWarning),
          backgroundColor: Colors.orange.shade700,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  @override
  void onSubmitSuccess(InspectionRouteEntity route) {
    context.router.push(
      InspectionCompletedRoute(route: route, submittedAt: DateTime.now()),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget buildView(BuildContext context) {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocListener<EquipmentInspectionBloc, EquipmentInspectionState>(
        listener: (ctx, state) {
          if (state is EquipmentInspectionError) {
            presenter?.onError(state.message);
          }
          if (state is EquipmentInspectionSubmitSuccess) {
            presenter?.onSubmitSuccess(state.route);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.signatureConfirmationTitle,
              style: const TextStyle(color: Colors.white),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: BlocBuilder<EquipmentInspectionBloc, EquipmentInspectionState>(
            builder: (context, state) {
              if (state is! EquipmentInspectionLoaded) {
                return const Center(child: CircularProgressIndicator());
              }
              final isSubmitting = state.isSubmitting;
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSummaryCard(state.route),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.inspectorSignatureLabel,
                        style: TextStyle(
                          fontSize: 16,
                          color: ColorName.colorTextGrey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(child: _buildSignatureArea()),
                      const SizedBox(height: 10),
                      _buildSignerRow(),
                      const SizedBox(height: 20),
                      _buildConfirmButton(isSubmitting: isSubmitting),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(InspectionRouteEntity route) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorName.bgInforBox,
        border: Border.all(color: ColorName.borderOutline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildSummaryRow(AppLocalizations.of(context)!.routeLabel, route.name),
          SizedBox(height: 20),
          _buildSummaryRow(
            AppLocalizations.of(context)!.completedItemsLabel,
            '${route.completedCount} / ${route.totalCount}',
          ),
          SizedBox(height: 20),
          _buildSummaryRow(
            AppLocalizations.of(context)!.abnormalItemsLabel,
            AppLocalizations.of(context)!.abnormalCountUnit(route.abnormalCount),
            valueColor: route.abnormalCount > 0 ? Colors.red.shade600 : null,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, color: ColorName.greenPrimary),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: valueColor ?? ColorName.greenPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSignatureArea() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: DashedBorderPainter(
                color: ColorName.borderOutline,
                radius: 12,
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _signatureController,
            builder: (context, _) {
              return _signatureController.isEmpty
                  ? Text(
                      AppLocalizations.of(context)!.signHerePlaceholder,
                      style: TextStyle(
                        fontSize: 15,
                        color: ColorName.colorTextGrey,
                      ),
                    )
                  : const SizedBox.shrink();
            },
          ),
          Positioned.fill(
            child: SignaturePad(controller: _signatureController),
          ),
        ],
      ),
    );
  }

  Widget _buildSignerRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _signerName ?? '...',
          style: const TextStyle(fontSize: 15, color: ColorName.colorTextGrey),
        ),
        TextButton(
          onPressed: _signatureController.clear,
          child: Text(
            AppLocalizations.of(context)!.clearAndResign,
            style: TextStyle(
              color: ColorName.colorTextGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmButton({required bool isSubmitting}) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: isSubmitting
            ? null
            : () => presenter?.onConfirmPressed(
                widget.bloc,
                hasSignature: !_signatureController.isEmpty,
              ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade600,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.green.shade200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isSubmitting
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: Colors.white,
                ),
              )
            : Text(
                AppLocalizations.of(context)!.confirmSubmit,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
      ),
    );
  }
}

import 'dart:math' show pi;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inspection_app/core/gen/colors.gen.dart';
import 'package:inspection_app/core/router/auto_route_config.dart';
import 'package:inspection_app/util/widgets/common_app_bar.dart';

import '../../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/inspection_route_entity.dart';

// ─────────────────────────────────────────────────────────────────────────────
// InspectionCompletedPage — màn hình「巡檢完成」
// Trang cuối cùng của quy trình tuần tra thiết bị, hiển thị sau khi
// 「簽名確認」gửi báo cáo thành công. Logic rất đơn giản (chỉ 1 nút quay về)
// nên không dùng MVP đầy đủ — tương tự MainAppPage trong main.dart.
// ─────────────────────────────────────────────────────────────────────────────

@RoutePage()
class InspectionCompletedPage extends StatefulWidget {
  final InspectionRouteEntity route;
  final DateTime submittedAt;

  const InspectionCompletedPage({
    super.key,
    required this.route,
    required this.submittedAt,
  });

  @override
  State<InspectionCompletedPage> createState() =>
      _InspectionCompletedPageState();
}

class _InspectionCompletedPageState extends State<InspectionCompletedPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..forward();

  /// Pha 1: vòng tròn xoay tiến trình (giống loading) quét dần thành hình tròn
  late final Animation<double> _sweepAnimation = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.0, 0.55, curve: Curves.easeInOut),
  );

  /// Pha 2: sau khi quét xong, nền tròn được tô đầy màu xanh
  late final Animation<double> _fillAnimation = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.55, 0.78, curve: Curves.easeOut),
  );

  /// Pha 3: dấu check hiện ra sau cùng
  late final Animation<double> _checkScale = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.78, 1.0, curve: Curves.easeOutBack),
  );

  late final Animation<double> _checkOpacity = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.78, 0.95, curve: Curves.easeIn),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ─── Widgets ──────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final route = widget.route;
    return Scaffold(
      appBar: CommonAppBar(
        title: AppLocalizations.of(context)!.inspectionCompletedTitle,
        showBackButton: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              _buildSuccessIcon(),
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.reportSubmittedMessage,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: ColorName.greenPrimary,
                ),
              ),
              const SizedBox(height: 28),
              _buildSummaryCard(route),
              const SizedBox(height: 10),
              _buildBackButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return SizedBox(
      width: 96,
      height: 96,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(96, 96),
                painter: _SuccessCirclePainter(
                  sweepProgress: _sweepAnimation.value,
                  fillProgress: _fillAnimation.value,
                ),
              ),
              child!,
            ],
          );
        },
        child: FadeTransition(
          opacity: _checkOpacity,
          child: ScaleTransition(
            scale: _checkScale,
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 56,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(InspectionRouteEntity route) {
    final hasAbnormal = route.abnormalCount > 0;
    final time =
        '${widget.submittedAt.hour.toString().padLeft(2, '0')}:${widget.submittedAt.minute.toString().padLeft(2, '0')}';

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
            AppLocalizations.of(context)!.completedLabel,
            '${route.completedCount} / ${route.totalCount}',
          ),
          SizedBox(height: 20),
          _buildSummaryRow(
            AppLocalizations.of(context)!.abnormalLabel,
            hasAbnormal
                ? AppLocalizations.of(context)!.abnormalCountReported(route.abnormalCount)
                : AppLocalizations.of(context)!.abnormalCountUnit(route.abnormalCount),
            valueColor: hasAbnormal ? Colors.red.shade600 : null,
          ),
          SizedBox(height: 20),
          _buildSummaryRow(AppLocalizations.of(context)!.submittedAtLabel, time),
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

  Widget _buildBackButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: () => context.router.popUntil(
          (route) => route.settings.name == TodayInspectionRoute.name,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorName.bluePrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          AppLocalizations.of(context)!.backToTodayInspection,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

/// Vẽ vòng tròn trạng thái thành công theo 2 pha:
/// 1. Vòng cung xanh quét dần theo [sweepProgress] (giống tiến trình xử lý)
/// 2. Sau khi quét đủ 1 vòng, nền tròn được tô đầy theo [fillProgress]
class _SuccessCirclePainter extends CustomPainter {
  final double sweepProgress;
  final double fillProgress;

  const _SuccessCirclePainter({
    required this.sweepProgress,
    required this.fillProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    const strokeWidth = 6.0;

    final trackPaint = Paint()
      ..color = ColorName.borderOutline
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius - strokeWidth / 2, trackPaint);

    if (sweepProgress > 0) {
      final sweepPaint = Paint()
        ..color = Colors.green.shade600
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        -pi / 2,
        2 * pi * sweepProgress,
        false,
        sweepPaint,
      );
    }

    if (fillProgress > 0) {
      final fillPaint = Paint()..color = Colors.green.shade600;
      canvas.drawCircle(
        center,
        (radius - strokeWidth) * fillProgress,
        fillPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SuccessCirclePainter oldDelegate) =>
      oldDelegate.sweepProgress != sweepProgress ||
      oldDelegate.fillProgress != fillProgress;
}

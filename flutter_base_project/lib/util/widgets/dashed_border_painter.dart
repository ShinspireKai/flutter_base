import 'package:flutter/material.dart';

/// DashedBorderPainter — vẽ viền đứt khúc (dashed) quanh hình chữ nhật bo góc
///
/// Dùng với `CustomPaint(painter: DashedBorderPainter(...))`, thường đặt
/// trong `Positioned.fill` bên trong `Stack` để phủ đúng kích thước khung cha.
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radius;
  final double dashWidth;
  final double dashGap;

  const DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.radius = 12,
    this.dashWidth = 6,
    this.dashGap = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(radius),
    );

    final dashedPath = _dashPath(Path()..addRRect(rrect));
    canvas.drawPath(dashedPath, paint);
  }

  Path _dashPath(Path source) {
    final dashedPath = Path();
    for (final metric in source.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        dashedPath.addPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          Offset.zero,
        );
        distance = next + dashGap;
      }
    }
    return dashedPath;
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.radius != radius ||
      oldDelegate.dashWidth != dashWidth ||
      oldDelegate.dashGap != dashGap;
}

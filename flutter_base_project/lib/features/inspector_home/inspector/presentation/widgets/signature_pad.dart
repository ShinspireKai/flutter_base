import 'package:flutter/material.dart';

/// SignaturePadController — quản lý nét vẽ chữ ký (không phụ thuộc UI)
///
/// `null` trong danh sách điểm đánh dấu ranh giới giữa 2 nét vẽ (nhấc bút)
class SignaturePadController extends ChangeNotifier {
  final List<Offset?> _points = [];

  List<Offset?> get points => List.unmodifiable(_points);

  bool get isEmpty => _points.every((point) => point == null);

  void addPoint(Offset point) {
    _points.add(point);
    notifyListeners();
  }

  void endStroke() {
    if (_points.isNotEmpty && _points.last != null) {
      _points.add(null);
      notifyListeners();
    }
  }

  void clear() {
    _points.clear();
    notifyListeners();
  }
}

/// SignaturePad — khung ký tên điện tử bằng ngón tay/bút cảm ứng/chuột
class SignaturePad extends StatelessWidget {
  final SignaturePadController controller;

  const SignaturePad({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      // CustomPaint không tự clip theo kích thước — nếu không có ClipRect,
      // kéo tay nhanh ra ngoài khung khi đang ký sẽ vẽ tràn ra ngoài Container cha.
      child: GestureDetector(
        onPanStart: (details) => controller.addPoint(details.localPosition),
        onPanUpdate: (details) => controller.addPoint(details.localPosition),
        onPanEnd: (_) => controller.endStroke(),
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            return CustomPaint(
              painter: _SignaturePainter(controller.points),
              size: Size.infinite,
            );
          },
        ),
      ),
    );
  }
}

class _SignaturePainter extends CustomPainter {
  final List<Offset?> points;

  _SignaturePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < points.length - 1; i++) {
      final current = points[i];
      final next = points[i + 1];
      if (current != null && next != null) {
        canvas.drawLine(current, next, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SignaturePainter oldDelegate) =>
      oldDelegate.points != points;
}

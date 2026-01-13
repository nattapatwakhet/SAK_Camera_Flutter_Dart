import 'package:flutter/material.dart';

class FocusReticlePainter extends CustomPainter {
  final Color color;

  FocusReticlePainter({this.color = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final double w = size.width;
    final double h = size.height;
    final double inner = 5; // ความยาวเส้นด้านใน
    // final double outer = 18; // ความยาวเส้นด้านนอก

    // === กรอบสี่เหลี่ยมหลัก ===
    final rect = Rect.fromLTRB(0, 0, w, h);
    canvas.drawRect(rect, paint);

    // === เส้นกลาง 4 ด้าน (ด้านบน / ล่าง / ซ้าย / ขวา) ===
    // Top
    canvas.drawLine(
      Offset(w / 2, 0),
      Offset(w / 2, inner),
      paint,
    );

    // Bottom
    canvas.drawLine(
      Offset(w / 2, h),
      Offset(w / 2, h - inner),
      paint,
    );

    // Left
    canvas.drawLine(
      Offset(0, h / 2),
      Offset(inner, h / 2),
      paint,
    );

    // Right
    canvas.drawLine(
      Offset(w, h / 2),
      Offset(w - inner, h / 2),
      paint,
    );

    // === กากบาทตรงกลาง ===
    const double cross = 5;

    // เส้นแนวตั้งกลาง
    canvas.drawLine(
      Offset(w / 2, h / 2 - cross / 2),
      Offset(w / 2, h / 2 + cross / 2),
      paint,
    );

    // เส้นแนวนอนกลาง
    canvas.drawLine(
      Offset(w / 2 - cross / 2, h / 2),
      Offset(w / 2 + cross / 2, h / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(FocusReticlePainter oldDelegate) => true;
}

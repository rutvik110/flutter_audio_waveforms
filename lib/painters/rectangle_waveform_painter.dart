import 'dart:ui';

import 'package:flutter/material.dart';

class RectangleWaveformPainter extends CustomPainter {
  RectangleWaveformPainter({
    required this.samples,
    required this.sliderValue,
  });
  final List<double> samples;
  final int sliderValue;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0
      ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFff3400),
            Color(0xFFff6d00),
            // Color(0xFFFFB5A0),
          ],
          stops: [
            0,
            1,
          ]).createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Color(0xFFb1cad5)
      ..strokeWidth = 0.2;

    List<Offset> offsets = [];
    final double width = size.width / samples.length;

    for (var i = 0; i < samples.length; i++) {
      final double x = i == samples.length - 1 ? size.width : width * i;
      final double y = samples[i] * size.height;
      final double x2 =
          i + 1 == samples.length ? width * (i * 2) : width * (i + 1);
      final double y2 = i + 1 == samples.length
          ? samples[i] * size.height
          : samples[i + 1] * size.height;

      canvas.drawRect(Rect.fromLTRB(x, 0, x2, y2 == 0 ? 1 : y2), paint);
      canvas.drawRect(Rect.fromLTRB(x, 0, x2, y2 == 0 ? 1 : y2), strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

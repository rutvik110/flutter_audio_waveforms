import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter_audio_waveforms/waveforms/waveform_painters_ab.dart';

class RectangleInActiveWaveformPainter extends InActiveWaveformPainter {
  RectangleInActiveWaveformPainter({
    Color color = Colors.white,
    Gradient? gradient,
    required List<double> samples,
  }) : super(
          samples: samples,
          color: color,
          gradient: gradient,
        );

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(0, size.height / 2);

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0
      ..color = color
      ..shader = gradient?.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Color(0xFFb1cad5)
      ..strokeWidth = 0.2;

    final double rectangelWidth = size.width / samples.length;

    for (var i = 0; i < samples.length; i++) {
      final double x = rectangelWidth * i;
      final double y = samples[i];

      canvas.drawRect(
        Rect.fromLTWH(x, 0, rectangelWidth, y),
        paint,
      );
      canvas.drawRect(
        Rect.fromLTWH(x, 0, rectangelWidth, y),
        strokePaint,
      );
    }
  }
}

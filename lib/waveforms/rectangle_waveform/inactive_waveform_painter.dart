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
    List<double> processedSamples =
        samples.map((e) => e * size.height).toList();
    final maxNum =
        processedSamples.reduce((a, b) => math.max(a.abs(), b.abs()));
    final double multiplier = math.pow(maxNum, -1).toDouble();

    List<double> processedSamples2 =
        processedSamples.map((e) => e * multiplier * size.height / 2).toList();

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0
      ..color = Colors.white;
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Color(0xFFb1cad5)
      ..strokeWidth = 0.2;

    final double rectangelWidth = size.width / processedSamples2.length;

    for (var i = 0; i < processedSamples2.length; i++) {
      final double x = rectangelWidth * i;
      final double y = processedSamples2[i];

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

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/waveforms/waveform_painters_ab.dart';

class PolygonActiveWaveformPainter extends ActiveWaveformPainter {
  PolygonActiveWaveformPainter({
    required Color color,
    Gradient? gradient,
    required List<double> samples,
    required int activeIndex,
    required List<double> activeSamples,
  }) : super(
            samples: samples,
            color: color,
            gradient: gradient,
            activeIndex: activeIndex,
            activeSamples: activeSamples);

  @override
  void paint(Canvas canvas, Size size) {
    final continousActivePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..shader = gradient?.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );
    final double width = size.width / samples.length;

    final path = Path();

    for (var i = 0; i < activeSamples.length; i++) {
      final double x = width * i;
      final double y = activeSamples[i];

      path.lineTo(x, y);
    }
    final centeredPath = path.shift(Offset(0, size.height / 2));
    canvas.drawPath(centeredPath, continousActivePaint);
  }
}

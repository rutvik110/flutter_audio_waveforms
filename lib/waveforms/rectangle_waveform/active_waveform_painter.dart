import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/waveforms/waveform_painters_ab.dart';

class RectangleActiveWaveformPainter extends ActiveWaveformPainter {
  RectangleActiveWaveformPainter({
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
    canvas.translate(0, size.height / 2);

    final activeTrackPaint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 1
      ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFff3400),
            Color(0xFFff6d00),
          ],
          stops: [
            0,
            1,
          ]).createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );
    final double rectangelWidth = size.width / samples.length;

    List<double> movingPointsList =
        List.generate(activeIndex, (index) => activeSamples[index]);

    for (var i = 0; i < movingPointsList.length; i++) {
      final double x = rectangelWidth * i;
      //make y abs to have one sided waveform
      final double y = activeSamples[i];

      canvas.drawRect(
        Rect.fromLTWH(x, 0, rectangelWidth, y),
        activeTrackPaint,
      );
    }
  }
}

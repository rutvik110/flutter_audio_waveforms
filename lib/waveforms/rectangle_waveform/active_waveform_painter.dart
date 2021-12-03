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

    final continousActivePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..shader = gradient?.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );
    final double width = size.width / samples.length;

    List<double> movingPointsList =
        List.generate(activeIndex, (index) => samples[index]);
    List<Offset> activeOffsets = [];

    for (var i = 0; i < movingPointsList.length; i++) {
      final double x = width * i;
      final double y = movingPointsList[i];

      activeOffsets.add(Offset(x, y));
    }
    canvas.drawPoints(PointMode.polygon, activeOffsets, continousActivePaint);
  }
}

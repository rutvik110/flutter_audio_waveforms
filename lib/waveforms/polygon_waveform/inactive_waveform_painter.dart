import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter_audio_waveforms/waveforms/waveform_painters_ab.dart';

class PolygonInActiveWaveformPainter extends InActiveWaveformPainter {
  PolygonInActiveWaveformPainter({
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
      ..style = PaintingStyle.stroke
      ..color = color
      ..shader = gradient?.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    List<Offset> offsets = [];
    final double width = size.width / samples.length;

    for (var i = 0; i < samples.length; i++) {
      final double x = width * i;
      final double y = samples[i];
      offsets.add(Offset(x, y));
    }

    canvas.drawPoints(PointMode.polygon, offsets, paint);
  }

  @override
  bool shouldRepaint(covariant PolygonInActiveWaveformPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return samples.length != oldDelegate.samples.length;
  }
}

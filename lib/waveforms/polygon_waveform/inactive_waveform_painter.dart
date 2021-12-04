import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/helpers/waveform_align.dart';
import 'dart:ui';

import 'package:flutter_audio_waveforms/waveforms/waveform_painters_ab.dart';

class PolygonInActiveWaveformPainter extends InActiveWaveformPainter {
  PolygonInActiveWaveformPainter({
    Color color = Colors.white,
    Gradient? gradient,
    required List<double> samples,
    required WaveformAlign waveformAlign,
  }) : super(
          samples: samples,
          color: color,
          gradient: gradient,
          waveformAlign: waveformAlign,
        );

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..shader = gradient?.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    final double width = size.width / samples.length;
    final path = Path();

    for (var i = 0; i < samples.length; i++) {
      final double x = width * i;
      final double y = samples[i];
      path.lineTo(x, y);
    }
    final shiftedPath = path.shift(Offset(0, size.height / 2));
    canvas.drawPath(shiftedPath, paint);
  }
}

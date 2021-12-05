import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/helpers/waveform_align.dart';
import 'package:flutter_audio_waveforms/waveforms/waveform_painters_ab.dart';

class PolygonActiveWaveformPainter extends ActiveWaveformPainter {
  PolygonActiveWaveformPainter({
    required Color color,
    Gradient? gradient,
    required List<double> samples,
    required int activeIndex,
    required List<double> activeSamples,
    required WaveformAlign waveformAlign,
    required this.style,
    required double sampleWidth,
  }) : super(
          samples: samples,
          color: color,
          gradient: gradient,
          activeIndex: activeIndex,
          activeSamples: activeSamples,
          waveformAlign: waveformAlign,
          sampleWidth: sampleWidth,
        );
  final PaintingStyle style;
  @override
  void paint(Canvas canvas, Size size) {
    final continousActivePaint = Paint()
      ..style = style
      ..color = color
      ..shader = gradient?.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    final path = Path();
    List<double> active = samples.sublist(0, activeIndex);
    bool isStroked = style == PaintingStyle.stroke;
    for (var i = 0; i < active.length; i++) {
      final double x = sampleWidth * i;
      final double y = active[i];
      if (isStroked) {
        path.lineTo(x, y);
      } else {
        if (i == active.length - 1) {
          path.lineTo(x, 0);
        } else {
          path.lineTo(x, y);
        }
      }
    }

    final alignPosition = waveformAlign.getAlignPosition(size.height);

    final shiftedPath = path.shift(Offset(0, alignPosition));

    canvas.drawPath(shiftedPath, continousActivePaint);
  }
}

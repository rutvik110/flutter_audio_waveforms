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
    required this.style,
    required double sampleWidth,
  }) : super(
          samples: samples,
          color: color,
          gradient: gradient,
          waveformAlign: waveformAlign,
          sampleWidth: sampleWidth,
        );

  final PaintingStyle style;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = style
      ..color = color
      ..shader = gradient?.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    final path = Path();

    for (var i = 0; i < samples.length; i++) {
      final double x = sampleWidth * i;
      final double y = samples[i];
      path.lineTo(x, y);
    }

    final alignPosition = waveformAlign.getAlignPosition(size.height);

    final shiftedPath = path.shift(Offset(0, alignPosition));

    canvas.drawPath(shiftedPath, paint);
  }
}

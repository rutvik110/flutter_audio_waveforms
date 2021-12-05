import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/helpers/waveform_align.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter_audio_waveforms/waveforms/waveform_painters_ab.dart';

class RectangleInActiveWaveformPainter extends InActiveWaveformPainter {
  RectangleInActiveWaveformPainter({
    Color color = Colors.white,
    Gradient? gradient,
    required List<double> samples,
    required WaveformAlign waveformAlign,
    required double sampleWidth,
    required this.borderColor,
    required this.borderWidth,
  }) : super(
          samples: samples,
          color: color,
          gradient: gradient,
          waveformAlign: waveformAlign,
          sampleWidth: sampleWidth,
        );
  final double borderWidth;
  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color
      ..shader = gradient?.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = borderColor
      ..strokeWidth = borderWidth;

    final alignPosition = waveformAlign.getAlignPosition(size.height);

    for (var i = 0; i < samples.length; i++) {
      final double x = sampleWidth * i;
      final double y = samples[i];

      canvas.drawRect(
        Rect.fromLTWH(x, alignPosition, sampleWidth, y),
        paint,
      );
      canvas.drawRect(
        Rect.fromLTWH(x, alignPosition, sampleWidth, y),
        strokePaint,
      );
    }
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_audio_waveforms/waveforms/waveform_painters_ab.dart';

class SquigglyWaveformPainter extends ActiveInActiveWaveformPainter {
  SquigglyWaveformPainter({
    required Color activeColor,
    required List<double> samples,
    required Color inactiveColor,
    required double activeRatio,
  }) : super(
            samples: samples,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            activeRatio: activeRatio);

  @override
  void paint(Canvas canvas, Size size) {
    final double pointWidth = size.width / samples.length;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..shader = LinearGradient(
          begin: const Alignment(-1.001, 0.0),
          end: const Alignment(1.001, 0.0),
          colors: [
            activeColor,
            inactiveColor
          ],
          stops: [
            activeRatio,
            0,
          ]).createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    final waveFormPath = Path();

    for (var i = 0; i < samples.length; i++) {
      final value = samples[i];
      final double x = pointWidth * i;
      final double x2 = pointWidth * (i + 1);
      final double y2 = i.isEven ? -value : value;
      final double diameter = x2 - x;
      final double radius = diameter / 2;
      waveFormPath.lineTo(x, y2);
      waveFormPath.lineTo(x, i.isEven ? y2 - diameter : y2 + diameter);
      waveFormPath.addArc(
        Rect.fromCircle(
          center: Offset(x2 - radius, i.isEven ? y2 - diameter : y2 + diameter),
          radius: radius,
        ),
        -math.pi,
        i.isEven ? math.pi : -math.pi,
      );
      waveFormPath.lineTo(x2, y2);
    }

    final centeredPath = waveFormPath.shift(Offset(0, size.height / 2));
    canvas.drawPath(centeredPath, paint);
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;

class SquigglyWaveformPainter extends CustomPainter {
  SquigglyWaveformPainter({
    required this.samples,
    required this.xAudioPosition,
    required this.sliderValue,
    required this.color,
    this.shader,
    this.strokeWidth = 1.0,
  });
  final List<double> samples;
  final int xAudioPosition;
  final double sliderValue;
  final Color color;
  final Shader? shader;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    List<double> processedSamples =
        samples.map((e) => e.abs() * size.height).toList();
    final maxNum = processedSamples.reduce(math.max);
    final double multiplier = math.pow(maxNum, -1).toDouble();

    List<double> processedSamples2 =
        processedSamples.map((e) => e * multiplier * size.height / 2).toList();
    final double pointWidth = size.width / samples.length;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..shader = LinearGradient(
          begin: Alignment(-1.001, 0.0),
          end: Alignment(1.001, 0.0),
          colors: [
            Color(0xFFff3400),
            Colors.blue
          ],
          stops: [
            sliderValue,
            0,
          ]).createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    final waveFormPath = Path();

    waveFormPath.moveTo(0, size.height / 2);
    for (var i = 0; i < processedSamples2.length; i++) {
      final value = processedSamples2[i];
      final double x = pointWidth * i;
      final double x2 = pointWidth * (i + 1);
      final double y2 =
          i.isEven ? -value + size.height / 2 : value + size.height / 2;
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
    canvas.drawPath(waveFormPath, paint);
  }

  @override
  bool shouldRepaint(covariant SquigglyWaveformPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

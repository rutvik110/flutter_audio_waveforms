import 'dart:ui';

import 'package:flutter/material.dart';

class RoundedWaveformPainter extends CustomPainter {
  RoundedWaveformPainter({
    required this.samples,
    required this.sliderValue,
    required this.color,
    this.shader,
    this.strokeWidth = 1.0,
  });
  final List<double> samples;
  final int sliderValue;
  final Color color;
  final Shader? shader;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width / samples.length;
    //fix the strokewidth issue
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..shader = shader;

    //  painter for continuous path
    final continousActivePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..shader = shader;

    final waveFormPath = Path();
    for (var i = 0; i < samples.length; i++) {
      final value = samples[i];
      final double x = width * i;
      const double y = 0;
      final double x2 = width * (i + 1);
      final double y2 = i.isEven ? -value * size.height : value * size.height;

      final double diameter = x2 - x;
      final double radius = diameter / 2;
      waveFormPath.lineTo(x, y);
      waveFormPath.lineTo(x, y2);
      waveFormPath.quadraticBezierTo(
          x2 - radius, i.isEven ? y2 - diameter : y2 + diameter, x2, y2);
      waveFormPath.lineTo(x2, y2);
    }
    canvas.drawPath(waveFormPath, paint);

    //either move active track to its separate painter or make it a separate pain function
    //active track
    List<double> movingPointsList =
        List.generate(sliderValue, (index) => samples[index]);
    final activePath = Path();

    for (var i = 0; i < movingPointsList.length; i++) {
      final double x = width * i;
      const double y = 0;
      final double x2 = width * (i + 1);
      final double y2 = i.isEven
          ? -movingPointsList[i] * size.height
          : movingPointsList[i] * size.height;
      final double diameter = x2 - x;
      final double radius = diameter / 2;
      activePath.lineTo(x, y);
      activePath.lineTo(x, y2);
      activePath.quadraticBezierTo(
          x2 - radius, i.isEven ? y2 - diameter : y2 + diameter, x2, y2);
      activePath.lineTo(x2, y2);
    }
    canvas.drawPath(activePath, continousActivePaint);
  }

  @override
  bool shouldRepaint(covariant RoundedWaveformPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

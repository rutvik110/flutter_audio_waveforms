import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;

class PolygonWaveformPainter extends CustomPainter {
  PolygonWaveformPainter({
    required this.samples,
    required this.sliderValue,
    required this.color,
    this.shader,
  });
  final List<double> samples;
  final int sliderValue;
  final Color color;
  final Shader? shader;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(0, size.height / 2);
    List<double> processedSamples =
        samples.map((e) => e * size.height).toList();

    final maxNum =
        processedSamples.reduce((a, b) => math.max(a.abs(), b.abs()));
    final double multiplier = math.pow(maxNum, -1).toDouble();

    List<double> processedSamples2 =
        processedSamples.map((e) => e * multiplier * size.height / 2).toList();
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..shader = shader;

    List<Offset> offsets = [];
    final double width = size.width / samples.length;

    for (var i = 0; i < processedSamples2.length; i++) {
      final double x = width * i;
      final double y = processedSamples2[i];

      offsets.add(Offset(x, y));
    }

    canvas.drawPoints(PointMode.polygon, offsets, paint);

    //Active track
    //  painter for continuous path
    final continousActivePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.red
      ..shader = shader;
    List<double> movingPointsList =
        List.generate(sliderValue, (index) => processedSamples2[index]);
    List<Offset> activeOffsets = [];

    for (var i = 0; i < movingPointsList.length; i++) {
      final double x = width * i;
      final double y = movingPointsList[i];

      activeOffsets.add(Offset(x, y));
    }
    canvas.drawPoints(PointMode.polygon, activeOffsets, continousActivePaint);
  }

  @override
  bool shouldRepaint(covariant PolygonWaveformPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

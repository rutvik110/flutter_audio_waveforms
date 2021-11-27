import 'dart:ui';

import 'package:flutter/material.dart';

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
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..shader = shader;

    List<Offset> offsets = [];
    final double width = size.width / samples.length;

    for (var i = 0; i < samples.length; i++) {
      final double x = i == samples.length - 1 ? size.width : width * i;
      final double y = i == samples.length - 1 ? 0 : samples[i] * size.height;

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
        List.generate(sliderValue, (index) => samples[index]);
    List<Offset> activeOffsets = [];

    for (var i = 0; i < movingPointsList.length; i++) {
      final double x = i == samples.length - 1 ? size.width : width * i;
      final double y = i == samples.length - 1 ? 0 : samples[i] * size.height;

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

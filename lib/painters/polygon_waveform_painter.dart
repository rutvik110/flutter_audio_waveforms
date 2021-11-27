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
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0
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
  }

  @override
  bool shouldRepaint(covariant PolygonWaveformPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return samples != oldDelegate.samples;
  }
}

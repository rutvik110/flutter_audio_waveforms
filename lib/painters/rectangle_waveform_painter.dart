import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;

class RectangleWaveformPainter extends CustomPainter {
  RectangleWaveformPainter({
    required this.samples,
    required this.sliderValue,
  });
  final List<double> samples;
  final int sliderValue;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(0, size.height / 2);
    List<double> processedSamples =
        samples.map((e) => e * size.height).toList();
    final maxNum = processedSamples.reduce(math.max);
    final double multiplier = math.pow(maxNum, -1).toDouble();

    List<double> processedSamples2 =
        processedSamples.map((e) => e * multiplier * size.height / 2).toList();

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0
      ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Colors.white
          ],
          stops: [
            0,
            1,
          ]).createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Color(0xFFb1cad5)
      ..strokeWidth = 0.2;

    final double rectangelWidth = size.width / processedSamples2.length;

    for (var i = 0; i < processedSamples2.length; i++) {
      final double x = rectangelWidth * i;
      final double y = processedSamples2[i];

      canvas.drawRect(
        Rect.fromLTWH(x, 0, rectangelWidth, y == 0 ? 1 : y),
        paint,
      );
      canvas.drawRect(
        Rect.fromLTWH(x, 0, rectangelWidth, y == 0 ? 1 : y),
        strokePaint,
      );
    }
    // final activeTrackPaint = Paint()
    //   ..style = PaintingStyle.fill
    //   ..strokeWidth = 1
    //   ..shader = const LinearGradient(
    //       begin: Alignment.topCenter,
    //       end: Alignment.bottomCenter,
    //       colors: [
    //         Color(0xFFff3400),
    //         Color(0xFFff6d00),
    //       ],
    //       stops: [
    //         0,
    //         1,
    //       ]).createShader(
    //     Rect.fromLTWH(0, 0, size.width, size.height),
    //   );

    // List<double> movingPointsList =
    //     List.generate(sliderValue, (index) => processedSamples2[index]);

    // for (var i = 0; i < movingPointsList.length; i++) {
    //   final double x = rectangelWidth * i;
    //   //make y abs to have one sided waveform
    //   final double y = processedSamples2[i];

    //   canvas.drawRect(Rect.fromLTWH(x, 0, rectangelWidth, y == 0 ? 1 : y),
    //       activeTrackPaint);
    // }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

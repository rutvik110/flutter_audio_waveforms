import 'dart:ui';

import 'package:flutter/material.dart';

abstract class WaveformPainter extends CustomPainter {
  WaveformPainter({
    required this.samples,
    required this.color,
    required this.gradient,
  });

  final List<double> samples;
  final Color color;
  final Gradient? gradient;
}

abstract class ActiveWaveformPainter extends WaveformPainter {
  ActiveWaveformPainter({
    required Color color,
    required Gradient? gradient,
    required List<double> samples,
    required this.activeIndex,
    required this.activeSamples,
  }) : super(samples: samples, color: color, gradient: gradient);

  final int activeIndex;
  final List<double> activeSamples;

  @override
  bool shouldRepaint(covariant ActiveWaveformPainter oldDelegate) {
    // TODO: implement shouldRepaint

    return activeSamples.length != oldDelegate.activeSamples.length;
  }
}

abstract class InActiveWaveformPainter extends WaveformPainter {
  InActiveWaveformPainter({
    required Color color,
    required Gradient? gradient,
    required List<double> samples,
  }) : super(samples: samples, color: color, gradient: gradient);

  @override
  bool shouldRepaint(covariant InActiveWaveformPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return samples.length != oldDelegate.samples.length;
  }
}

abstract class ActiveInActiveWaveformPainter extends WaveformPainter {
  ActiveInActiveWaveformPainter({
    required Color color,
    required Gradient? gradient,
    required List<double> samples,
    required this.activeIndex,
    required this.activeSamples,
    required this.inactiveColor,
    this.inactiveGradient,
  }) : super(samples: samples, color: color, gradient: gradient);

  final int activeIndex;
  final Color inactiveColor;
  final Gradient? inactiveGradient;
  final List<double> activeSamples;
}

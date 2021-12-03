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
    return samples.length != oldDelegate.samples.length;
  }
}

abstract class ActiveInActiveWaveformPainter extends WaveformPainter {
  ActiveInActiveWaveformPainter({
    required this.activeColor,
    required List<double> samples,
    required this.inactiveColor,
    required this.activeRatio,
  }) : super(samples: samples, color: activeColor, gradient: null);

  final Color inactiveColor;
  final Color activeColor;
  final double activeRatio;

  @override
  bool shouldRepaint(covariant ActiveInActiveWaveformPainter oldDelegate) {
    return activeRatio != oldDelegate.activeRatio;
  }
}

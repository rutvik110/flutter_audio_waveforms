import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/helpers/waveform_align.dart';

abstract class WaveformPainter extends CustomPainter {
  WaveformPainter({
    required this.samples,
    required this.color,
    required this.gradient,
    required this.waveformAlign,
    required this.sampleWidth,
  });

  final List<double> samples;
  final Color color;
  final Gradient? gradient;
  final WaveformAlign waveformAlign;
  final double sampleWidth;
}

abstract class ActiveWaveformPainter extends WaveformPainter {
  ActiveWaveformPainter({
    required Color color,
    required Gradient? gradient,
    required List<double> samples,
    required double sampleWidth,
    required this.activeSamples,
    required WaveformAlign waveformAlign,
  }) : super(
          samples: samples,
          color: color,
          gradient: gradient,
          waveformAlign: waveformAlign,
          sampleWidth: sampleWidth,
        );

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
    required WaveformAlign waveformAlign,
    required double sampleWidth,
  }) : super(
          samples: samples,
          color: color,
          gradient: gradient,
          waveformAlign: waveformAlign,
          sampleWidth: sampleWidth,
        );

  @override
  bool shouldRepaint(covariant InActiveWaveformPainter oldDelegate) {
    return samples.length != oldDelegate.samples.length;
  }
}

abstract class ActiveInActiveWaveformPainter extends WaveformPainter {
  ActiveInActiveWaveformPainter({
    required this.activeColor,
    required List<double> samples,
    required double sampleWidth,
    required this.inactiveColor,
    required this.activeRatio,
    WaveformAlign waveformAlign = WaveformAlign.center,
  }) : super(
          samples: samples,
          color: activeColor,
          gradient: null,
          waveformAlign: waveformAlign,
          sampleWidth: sampleWidth,
        );

  final Color inactiveColor;
  final Color activeColor;
  final double activeRatio;

  @override
  bool shouldRepaint(covariant ActiveInActiveWaveformPainter oldDelegate) {
    return activeRatio != oldDelegate.activeRatio;
  }
}

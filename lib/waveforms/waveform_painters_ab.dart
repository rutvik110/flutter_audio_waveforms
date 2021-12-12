import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/helpers/waveform_align.dart';

///A base class that all types of waveforms extend to.
abstract class WaveformPainter extends CustomPainter {
  // ignore: public_member_api_docs
  WaveformPainter({
    required this.samples,
    required this.color,
    required this.gradient,
    required this.waveformAlign,
    required this.sampleWidth,
  });

  ///The samples to be drawn.
  final List<double> samples;

  ///The color of the waveform.
  final Color color;

  ///The gradient of the waveform.
  final Gradient? gradient;

  ///The alignment of the waveform.
  final WaveformAlign waveformAlign;

  ///The width of each sample.
  final double sampleWidth;
}

/// A base class extending to [WaveformPainter] for Active Waveforms
abstract class ActiveWaveformPainter extends WaveformPainter {
  // ignore: public_member_api_docs
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

  ///The active samples to be drawn.
  final List<double> activeSamples;

  @override
  bool shouldRepaint(covariant ActiveWaveformPainter oldDelegate) {
    return activeSamples.length != oldDelegate.activeSamples.length;
  }
}

/// A base class that extends to [WaveformPainter] for Inactive Waveforms
abstract class InActiveWaveformPainter extends WaveformPainter {
  // ignore: public_member_api_docs
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

///A base class that extends to [WaveformPainter] for Waveforms that are both
///Active and Inactive.
abstract class ActiveInActiveWaveformPainter extends WaveformPainter {
  // ignore: public_member_api_docs
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

  ///The color of the active waveform.
  final Color inactiveColor;

  ///The color of the inactive waveform.
  final Color activeColor;

  ///The ratio of the elapsed Duration to the max Duration.
  final double activeRatio;

  @override
  bool shouldRepaint(covariant ActiveInActiveWaveformPainter oldDelegate) {
    return activeRatio != oldDelegate.activeRatio;
  }
}

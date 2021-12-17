import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/src/util/check_samples_equality.dart';
import 'package:flutter_audio_waveforms/src/util/waveform_alignment.dart';

/// A Painter class that all the types of Waveform Painters extend to.
/// The memebers of this class are essential to paint any type of waveform.
abstract class WaveformPainter extends CustomPainter {
  /// Constructor for the WaveformPainter.
  WaveformPainter({
    required this.samples,
    required this.color,
    required this.gradient,
    required this.waveformAlignment,
    required this.sampleWidth,
  });

  /// Samples that are used to paint the waveform.
  final List<double> samples;

  /// Color of the waveform.
  final Color color;

  /// Gradient of the waveform.
  final Gradient? gradient;

  /// Alignment of the waveform.
  final WaveformAlignment waveformAlignment;

  /// Width of each sample.
  final double sampleWidth;
}

/// A Painter class that all other ActiveWaveform Painters extend to.
/// The members declared in this class are essential to draw ActiveWaveforms.
/// This types of waveform painters draws the active part of the waveform of
/// the audio being played.

abstract class ActiveWaveformPainter extends WaveformPainter {
  // ignore: public_member_api_docs
  ActiveWaveformPainter({
    required Color color,
    required Gradient? gradient,
    required List<double> samples,
    required double sampleWidth,
    required this.activeSamples,
    required WaveformAlignment waveformAlignment,
  }) : super(
          samples: samples,
          color: color,
          gradient: gradient,
          waveformAlignment: waveformAlignment,
          sampleWidth: sampleWidth,
        );

  ///The active samples used to paint the waveform.
  final List<double> activeSamples;

  /// Whether the waveform should be rePainted or not.
  @override
  bool shouldRepaint(covariant ActiveWaveformPainter oldDelegate) {
    return activeSamples.length != oldDelegate.activeSamples.length;
  }
}

/// A Painter class that all other InActiveWaveform Painters extend to.
/// This types of waveform painters draws the whole waveform of the audio
/// being played.
abstract class InActiveWaveformPainter extends WaveformPainter {
  // ignore: public_member_api_docs
  InActiveWaveformPainter({
    required Color color,
    required Gradient? gradient,
    required List<double> samples,
    required WaveformAlignment waveformAlignment,
    required double sampleWidth,
  }) : super(
          samples: samples,
          color: color,
          gradient: gradient,
          waveformAlignment: waveformAlignment,
          sampleWidth: sampleWidth,
        );

  /// Whether the waveform should be rePainted or not.
  @override
  bool shouldRepaint(covariant InActiveWaveformPainter oldDelegate) {
    return !checkforSamplesEquality(samples, oldDelegate.samples);
  }
}

/// A Painter class that all other ActiveInActiveWaveform Painters extend to.
/// The members of this class are essential to draw any waveform that manages
/// the painting of both active and inActive waveform within itself.
abstract class ActiveInActiveWaveformPainter extends WaveformPainter {
  // ignore: public_member_api_docs
  ActiveInActiveWaveformPainter({
    required this.activeColor,
    required List<double> samples,
    required double sampleWidth,
    required this.inactiveColor,
    required this.activeRatio,
    WaveformAlignment waveformAlignment = WaveformAlignment.center,
  }) : super(
          samples: samples,
          color: activeColor,
          gradient: null,
          waveformAlignment: waveformAlignment,
          sampleWidth: sampleWidth,
        );

  ///The color of the active waveform.
  final Color inactiveColor;

  ///The color of the inactive waveform.
  final Color activeColor;

  ///The ratio of the elapsedDuration to the maxDuration.
  final double activeRatio;

  /// Whether the waveform should be rePainted or not.
  @override
  bool shouldRepaint(covariant ActiveInActiveWaveformPainter oldDelegate) {
    return activeRatio != oldDelegate.activeRatio;
  }
}

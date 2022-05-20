import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/src/core/audio_waveform.dart';
import 'package:flutter_audio_waveforms/src/core/waveform_painters_ab.dart';
import 'package:flutter_audio_waveforms/src/waveforms/squiggly_waveform/active_inactive_waveform_painter.dart';

/// [SquigglyWaveform] paints a squiggly waveform.
/// The painter for this waveform is of the type [ActiveInActiveWaveformPainter]
///
/// {@tool snippet}
/// Example :
/// ```dart
/// SquigglyWaveform(
///   maxDuration: maxDuration,
///   elapsedDuration: elapsedDuration,
///   samples: samples,
///   height: 300,
///   width: MediaQuery.of(context).size.width,
/// )
///```
/// {@end-tool}
class SquigglyWaveform extends AudioWaveform {
  // ignore: public_member_api_docs
  SquigglyWaveform({
    super.key,
    required super.samples,
    required super.height,
    required super.width,
    super.maxDuration,
    super.elapsedDuration,
    this.activeColor = Colors.red,
    this.inactiveColor = Colors.blue,
    this.strokeWidth = 1.0,
    super.showActiveWaveform = true,
    super.absolute = false,
    super.invert = false,
  }) : assert(strokeWidth >= 0, "strokeWidth can't be negative.");

  /// The color of the active portion of the waveform.
  final Color activeColor;

  /// The color of the inactive portion of the waveform.
  final Color inactiveColor;

  /// The stroke width of the waveform.
  final double strokeWidth;

  @override
  AudioWaveformState<SquigglyWaveform> createState() =>
      _SquigglyWaveformState();
}

class _SquigglyWaveformState extends AudioWaveformState<SquigglyWaveform> {
  @override
  void processSamples() {
    final rawSamples = widget.samples;
    // ignore: omit_local_variable_types
    List<double> processedSamples =
        rawSamples.map((e) => e.abs() * widget.height).toList();

    final maxNum =
        processedSamples.reduce((a, b) => math.max(a.abs(), b.abs()));

    if (maxNum > 0) {
      final multiplier = math.pow(maxNum, -1).toDouble();
      final finalHeight = absolute ? widget.height : widget.height / 2;
      final finalMultiplier = multiplier * finalHeight;

      processedSamples = processedSamples
          .map(
            (e) => e * finalMultiplier,
          )
          .toList();
    }
    updateProcessedSamples(processedSamples);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.samples.isEmpty) {
      return const SizedBox.shrink();
    }
    final processedSamples = this.processedSamples;
    final activeRatio = this.activeRatio;
    final waveformAlignment = this.waveformAlignment;

    return CustomPaint(
      size: Size(widget.width, widget.height),
      isComplex: true,
      painter: SquigglyWaveformPainter(
        samples: processedSamples,
        activeColor: widget.activeColor,
        inactiveColor: widget.inactiveColor,
        activeRatio: activeRatio,
        waveformAlignment: waveformAlignment,
        absolute: widget.absolute,
        invert: widget.invert,
        strokeWidth: widget.strokeWidth,
        sampleWidth: sampleWidth,
      ),
    );
  }
}

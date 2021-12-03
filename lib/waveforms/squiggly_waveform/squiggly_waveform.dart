import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/audio_waveform.dart';
import 'package:flutter_audio_waveforms/waveforms/squiggly_waveform/active_inactive_waveform_painter.dart';

class SquigglyeWaveform extends AudioWaveform {
  const SquigglyeWaveform({
    Key? key,
    required List<double> samples,
    required double height,
    required double width,
    required Duration maxDuration,
    required Duration elapsedDuration,
    this.activeColor,
    this.inactiveColor,
    this.activeGradient,
    this.inactiveGradient,
  }) : super(
          key: key,
          samples: samples,
          height: height,
          width: width,
          maxDuration: maxDuration,
          elapsedDuration: elapsedDuration,
          absolute: true,
        );
  final Color? activeColor;
  final Color? inactiveColor;
  final Gradient? activeGradient;
  final Gradient? inactiveGradient;

  @override
  AudioWaveformState<SquigglyeWaveform> createState() =>
      _SquigglyeWaveformState();
}

class _SquigglyeWaveformState extends AudioWaveformState<SquigglyeWaveform> {
  @override
  Widget build(BuildContext context) {
    final processedSamples = this.processedSamples;
    final activeRatio =
        elapsedDuration.inMilliseconds / maxDuration.inMilliseconds;
    return CustomPaint(
      size: Size(widget.width, widget.height),
      willChange: true,
      painter: SquigglyWaveformPainter(
        samples: processedSamples,
        activeColor: widget.activeColor ?? Colors.red,
        inactiveColor: widget.inactiveColor ?? Colors.blue,
        activeRatio: activeRatio,
      ),
    );
  }
}

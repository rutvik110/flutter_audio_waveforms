import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/audio_waveform_stateful_ab.dart';
import 'package:flutter_audio_waveforms/waveforms/squiggly_waveform/active_inactive_waveform_painter.dart';

class SquigglyWaveform extends AudioWaveform {
  const SquigglyWaveform({
    Key? key,
    required List<double> samples,
    required double height,
    required double width,
    required Duration maxDuration,
    required Duration elapsedDuration,
    this.activeColor,
    this.inactiveColor,
    bool showActiveWaveform = true,
  }) : super(
          key: key,
          samples: samples,
          height: height,
          width: width,
          maxDuration: maxDuration,
          elapsedDuration: elapsedDuration,
          absolute: true,
          showActiveWaveform: showActiveWaveform,
        );
  final Color? activeColor;
  final Color? inactiveColor;

  @override
  AudioWaveformState<SquigglyWaveform> createState() =>
      _SquigglyWaveformState();
}

class _SquigglyWaveformState extends AudioWaveformState<SquigglyWaveform> {
  @override
  Widget build(BuildContext context) {
    if (widget.samples.isEmpty) {
      return const SizedBox.shrink();
    }

    final List<double> processedSamples = this.processedSamples;
    final double activeRatio = this.showActiveWaveform
        ? elapsedDuration.inMilliseconds / maxDuration.inMilliseconds
        : 0;

    return CustomPaint(
      size: Size(widget.width, widget.height),
      isComplex: true,
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

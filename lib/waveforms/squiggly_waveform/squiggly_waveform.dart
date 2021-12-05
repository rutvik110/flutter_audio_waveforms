import 'dart:math' as math;
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
    this.strokeWidth = 1.0,
    bool showActiveWaveform = true,
    bool absolute = false,
    bool invert = false,
  }) : super(
          key: key,
          samples: samples,
          height: height,
          width: width,
          maxDuration: maxDuration,
          elapsedDuration: elapsedDuration,
          absolute: absolute,
          invert: invert,
          showActiveWaveform: showActiveWaveform,
        );
  final Color? activeColor;
  final Color? inactiveColor;
  final double strokeWidth;

  @override
  AudioWaveformState<SquigglyWaveform> createState() =>
      _SquigglyWaveformState();
}

class _SquigglyWaveformState extends AudioWaveformState<SquigglyWaveform> {
  @override
  void processSamples(List<double> samples) {
    List<double> processedSamples =
        samples.map((e) => e.abs() * widget.height).toList();

    final maxNum =
        processedSamples.reduce((a, b) => math.max(a.abs(), b.abs()));
    final double multiplier = math.pow(maxNum, -1).toDouble();
    final finaHeight = absolute ? widget.height : widget.height / 2;
    processedSamples = processedSamples
        .map(
          (e) => e * multiplier * finaHeight,
        )
        .toList();

    updateProcessedSamples(processedSamples);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.samples.isEmpty) {
      return const SizedBox.shrink();
    }
    final List<double> processedSamples = this.processedSamples;
    final double activeRatio = showActiveWaveform
        ? elapsedDuration.inMilliseconds / maxDuration.inMilliseconds
        : 0;
    final waveformAlign = this.waveformAlign;

    return CustomPaint(
      size: Size(widget.width, widget.height),
      isComplex: true,
      painter: SquigglyWaveformPainter(
        samples: processedSamples,
        activeColor: widget.activeColor ?? Colors.red,
        inactiveColor: widget.inactiveColor ?? Colors.blue,
        activeRatio: activeRatio,
        waveformAlign: waveformAlign,
        absolute: widget.absolute,
        invert: widget.invert,
        strokeWidth: widget.strokeWidth,
        sampleWidth: sampleWidth,
      ),
    );
  }
}

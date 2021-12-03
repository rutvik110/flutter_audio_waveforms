import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/audio_waveform.dart';
import 'package:flutter_audio_waveforms/waveforms/polygon_waveform/active_waveform_painter.dart';
import 'package:flutter_audio_waveforms/waveforms/polygon_waveform/inactive_waveform_painter.dart';
import 'package:flutter_audio_waveforms/waveforms/rectangle_waveform/active_waveform_painter.dart';
import 'package:flutter_audio_waveforms/waveforms/rectangle_waveform/inactive_waveform_painter.dart';

class RectangleWaveform extends AudioWaveform {
  const RectangleWaveform({
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
        );
  final Color? activeColor;
  final Color? inactiveColor;
  final Gradient? activeGradient;
  final Gradient? inactiveGradient;

  @override
  AudioWaveformState<RectangleWaveform> createState() =>
      _RectangleWaveformState();
}

class _RectangleWaveformState extends AudioWaveformState<RectangleWaveform> {
  @override
  Widget build(BuildContext context) {
    final processedSamples = this.processedSamples;
    final activeSamples = this.activeSamples;
    final activeIndex = this.activeIndex;
    return Stack(
      children: [
        RepaintBoundary(
          child: CustomPaint(
            size: Size(widget.width, widget.height),
            painter: RectangleInActiveWaveformPainter(
              samples: processedSamples,
              color: widget.inactiveColor ?? Colors.blue,
              gradient: widget.inactiveGradient,
            ),
          ),
        ),
        CustomPaint(
          size: Size(widget.width, widget.height),
          painter: RectangleActiveWaveformPainter(
            samples: processedSamples,
            activeIndex: activeIndex,
            color: widget.activeColor ?? Colors.red,
            activeSamples: activeSamples,
            gradient: widget.activeGradient,
          ),
        ),
      ],
    );
  }
}

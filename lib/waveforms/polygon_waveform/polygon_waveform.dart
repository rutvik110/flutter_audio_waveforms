import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/audio_waveform.dart';
import 'package:flutter_audio_waveforms/waveforms/polygon_waveform/active_waveform_painter.dart';
import 'package:flutter_audio_waveforms/waveforms/polygon_waveform/inactive_waveform_painter.dart';

class PolygonWaveform extends AudioWaveform {
  const PolygonWaveform({
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
  AudioWaveformState<PolygonWaveform> createState() => _PolygonWaveformState();
}

class _PolygonWaveformState extends AudioWaveformState<PolygonWaveform> {
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
            painter: PolygonInActiveWaveformPainter(
              samples: processedSamples,
              color: widget.inactiveColor ?? Colors.blue,
              gradient: widget.inactiveGradient,
            ),
          ),
        ),
        CustomPaint(
          size: Size(widget.width, widget.height),
          painter: PolygonActiveWaveformPainter(
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

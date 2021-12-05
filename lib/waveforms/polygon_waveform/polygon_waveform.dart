import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/audio_waveform_stateful_ab.dart';
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
    this.paintingStyle = PaintingStyle.stroke,
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
          showActiveWaveform: showActiveWaveform,
          absolute: absolute,
          invert: invert,
        );
  final Color? activeColor;
  final Color? inactiveColor;
  final Gradient? activeGradient;
  final Gradient? inactiveGradient;
  final PaintingStyle paintingStyle;

  @override
  AudioWaveformState<PolygonWaveform> createState() => _PolygonWaveformState();
}

class _PolygonWaveformState extends AudioWaveformState<PolygonWaveform> {
  @override
  Widget build(BuildContext context) {
    if (widget.samples.isEmpty) {
      return const SizedBox.shrink();
    }
    final processedSamples = this.processedSamples;
    final activeSamples = this.activeSamples;

    final activeIndex = this.activeIndex;
    final showActiveWaveform = this.showActiveWaveform;
    final sampleWidth = this.sampleWidth;

    return Stack(
      children: [
        RepaintBoundary(
          child: CustomPaint(
            size: Size(widget.width, widget.height),
            isComplex: true,
            painter: PolygonInActiveWaveformPainter(
              samples: processedSamples,
              paintingStyle: widget.paintingStyle,
              color: widget.inactiveColor ?? Colors.blue,
              gradient: widget.inactiveGradient,
              waveformAlign: widget.waveformAlign,
              sampleWidth: sampleWidth,
            ),
          ),
        ),
        if (showActiveWaveform)
          CustomPaint(
            isComplex: true,
            size: Size(widget.width, widget.height),
            painter: PolygonActiveWaveformPainter(
              samples: processedSamples,
              paintingStyle: widget.paintingStyle,
              activeIndex: activeIndex,
              color: widget.activeColor ?? Colors.red,
              activeSamples: activeSamples,
              gradient: widget.activeGradient,
              waveformAlign: widget.waveformAlign,
              sampleWidth: sampleWidth,
            ),
          ),
      ],
    );
  }
}

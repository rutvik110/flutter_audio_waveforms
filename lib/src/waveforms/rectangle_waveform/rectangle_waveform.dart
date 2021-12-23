import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';
import 'package:flutter_audio_waveforms/src/core/audio_waveform.dart';
import 'package:flutter_audio_waveforms/src/waveforms/rectangle_waveform/active_waveform_painter.dart';
import 'package:flutter_audio_waveforms/src/waveforms/rectangle_waveform/inactive_waveform_painter.dart';

/// [RectangleWaveform] paints a waveform where each sample is represented as
/// rectangle block. It's inspired by the @soundcloud audio track on web.
///
/// {@tool snippet}
/// Example :
/// ```dart
/// RectangleWaveform(
///   maxDuration: maxDuration,
///   elapsedDuration: elapsedDuration,
///   samples: samples,
///   height: 300,
///   width: MediaQuery.of(context).size.width,
/// )
///```
/// {@end-tool}
class RectangleWaveform extends AudioWaveform {
  // ignore: public_member_api_docs
  RectangleWaveform({
    Key? key,
    required List<double> samples,
    required double height,
    required double width,
    required Duration maxDuration,
    required Duration elapsedDuration,
    this.activeColor = Colors.red,
    this.inactiveColor = Colors.blue,
    this.activeGradient,
    this.inactiveGradient,
    this.borderWidth = 1.0,
    this.activeBorderColor = Colors.white,
    this.inactiveBorderColor = Colors.white,
    bool showActiveWaveform = true,
    bool absolute = false,
    bool invert = false,
  })  : assert(
          borderWidth >= 0 && borderWidth <= 1.0,
          "BorderWidth must be between 0 and 1",
        ),
        super(
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

  /// The color of the active waveform.
  final Color activeColor;

  /// The color of the inactive waveform.
  final Color inactiveColor;

  /// The gradient of the active waveform.
  final Gradient? activeGradient;

  /// The gradient of the inactive waveform.
  final Gradient? inactiveGradient;

  /// The width of the border of the waveform.
  final double borderWidth;

  /// The color of the active waveform border.
  final Color activeBorderColor;

  /// The color of the inactive waveform border.
  final Color inactiveBorderColor;

  @override
  AudioWaveformState<RectangleWaveform> createState() =>
      _RectangleWaveformState();
}

class _RectangleWaveformState extends AudioWaveformState<RectangleWaveform> {
  @override
  Widget build(BuildContext context) {
    if (widget.samples.isEmpty) {
      return const SizedBox.shrink();
    }
    final processedSamples = this.processedSamples;
    final activeSamples = this.activeSamples;
    final showActiveWaveform = this.showActiveWaveform;
    final waveformAlignment = this.waveformAlignment;
    final sampleWidth = this.sampleWidth;

    return Stack(
      children: [
        RepaintBoundary(
          child: CustomPaint(
            size: Size(widget.width, widget.height),
            isComplex: true,
            painter: RectangleInActiveWaveformPainter(
              samples: processedSamples,
              color: widget.inactiveColor,
              gradient: widget.inactiveGradient,
              waveformAlignment: waveformAlignment,
              borderColor: widget.inactiveBorderColor,
              borderWidth: widget.borderWidth,
              sampleWidth: sampleWidth,
            ),
          ),
        ),
        if (showActiveWaveform)
          RepaintBoundary(
            child: CustomPaint(
              size: Size(widget.width, widget.height),
              isComplex: true,
              painter: RectangleActiveWaveformPainter(
                color: widget.activeColor,
                activeSamples: activeSamples,
                gradient: widget.activeGradient,
                waveformAlignment: waveformAlignment,
                borderColor: widget.activeBorderColor,
                borderWidth: widget.borderWidth,
                sampleWidth: sampleWidth,
              ),
            ),
          ),
      ],
    );
  }
}

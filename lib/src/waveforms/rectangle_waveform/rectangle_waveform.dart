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
    super.key,
    required super.samples,
    required super.height,
    required super.width,
    super.maxDuration,
    super.elapsedDuration,
    this.activeColor = Colors.red,
    this.inactiveColor = Colors.blue,
    this.activeGradient,
    this.inactiveGradient,
    this.borderWidth = 1.0,
    this.activeBorderColor = Colors.white,
    this.inactiveBorderColor = Colors.white,
    super.showActiveWaveform = true,
    super.absolute = false,
    super.invert = false,
    this.isRoundedRectangle = false,
    this.isCentered = false,
  }) : assert(
          borderWidth >= 0 && borderWidth <= 1.0,
          'BorderWidth must be between 0 and 1',
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

  /// If true then rounded rectangles are drawn instead of regular rectangles.
  final bool isRoundedRectangle;

  /// If true then rectangles are centered along the Y-axis with respect to
  /// their center along their height.
  ///
  /// If [absolute] is true then this would've no effect.
  final bool isCentered;

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
              isRoundedRectangle: widget.isRoundedRectangle,
              isCentered: widget.isCentered,
            ),
          ),
        ),
        if (showActiveWaveform)
          CustomPaint(
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
              isRoundedRectangle: widget.isRoundedRectangle,
              isCentered: widget.isCentered,
            ),
          ),
      ],
    );
  }
}

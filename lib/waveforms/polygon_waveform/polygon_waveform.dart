import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';
import 'package:flutter_audio_waveforms/waveforms/polygon_waveform/active_waveform_painter.dart';
import 'package:flutter_audio_waveforms/waveforms/polygon_waveform/inactive_waveform_painter.dart';

/// [PolygonWaveform] paints the standard waveform that is used for audio
/// waveforms, a sharp continuous line joining the points of a waveform.
///
/// Example :
///
///
///
///
///
///
class PolygonWaveform extends AudioWaveform {
  // ignore: public_member_api_docs
  const PolygonWaveform({
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
    this.style = PaintingStyle.stroke,
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

  /// active waveform color
  final Color activeColor;

  /// inactive waveform color
  final Color inactiveColor;

  /// active waveform gradient
  final Gradient? activeGradient;

  /// inactive waveform gradient
  final Gradient? inactiveGradient;

  /// waveform style
  final PaintingStyle style;

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
              style: widget.style,
              color: widget.inactiveColor,
              gradient: widget.inactiveGradient,
              waveformAlignment: widget.waveformAlignment,
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
              style: widget.style,
              color: widget.activeColor,
              activeSamples: activeSamples,
              gradient: widget.activeGradient,
              waveformAlignment: widget.waveformAlignment,
              sampleWidth: sampleWidth,
            ),
          ),
      ],
    );
  }
}

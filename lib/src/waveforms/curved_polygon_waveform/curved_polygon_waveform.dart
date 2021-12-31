import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/src/core/audio_waveform.dart';
import 'package:flutter_audio_waveforms/src/core/waveform_painters_ab.dart';
import 'package:flutter_audio_waveforms/src/waveforms/curved_polygon_waveform/active_inactive_waveform_painter.dart';

/// [CurvedPolygonWaveform] paints a squiggly waveform.
/// The painter for this waveform is of the type [ActiveInActiveWaveformPainter]
///
/// {@tool snippet}
/// Example :
/// ```dart
/// CurvedPolygonWaveform(
///   maxDuration: maxDuration,
///   elapsedDuration: elapsedDuration,
///   samples: samples,
///   height: 300,
///   width: MediaQuery.of(context).size.width,
/// )
///```
/// {@end-tool}
class CurvedPolygonWaveform extends AudioWaveform {
  // ignore: public_member_api_docs
  CurvedPolygonWaveform({
    Key? key,
    required List<double> samples,
    required double height,
    required double width,
    required Duration maxDuration,
    required Duration elapsedDuration,
    this.activeColor = Colors.red,
    this.inactiveColor = Colors.blue,
    this.strokeWidth = 1.0,
    this.style = PaintingStyle.stroke,
    bool showActiveWaveform = true,
    bool absolute = false,
    bool invert = false,
  })  : assert(strokeWidth >= 0, "strokeWidth can't be negative."),
        super(
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

  /// The color of the active portion of the waveform.
  final Color activeColor;

  /// The color of the inactive portion of the waveform.
  final Color inactiveColor;

  /// The stroke width of the waveform.
  final double strokeWidth;

  /// waveform style
  final PaintingStyle style;

  @override
  AudioWaveformState<CurvedPolygonWaveform> createState() =>
      _SquigglyWaveformState();
}

class _SquigglyWaveformState extends AudioWaveformState<CurvedPolygonWaveform> {
  @override
  Widget build(BuildContext context) {
    if (widget.samples.isEmpty) {
      return const SizedBox.shrink();
    }
    final processedSamples = this.processedSamples;
    final activeRatio = showActiveWaveform
        ? elapsedDuration.inMilliseconds / maxDuration.inMilliseconds
        : 0.0;
    final waveformAlignment = this.waveformAlignment;

    return RepaintBoundary(
      child: CustomPaint(
        size: Size(widget.width, widget.height),
        isComplex: true,
        painter: CurvedPolygonActiveInActiveWaveformPainter(
          samples: processedSamples,
          activeColor: widget.activeColor,
          inactiveColor: widget.inactiveColor,
          activeRatio: activeRatio,
          waveformAlignment: waveformAlignment,
          strokeWidth: widget.strokeWidth,
          sampleWidth: sampleWidth,
          style: widget.style,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/audio_waveform.dart';
import 'package:flutter_audio_waveforms/waveforms/polygon_waveform/polygon_waveform_painter.dart';

class PolygonWaveform extends AudioWaveform {
  const PolygonWaveform({
    Key? key,
    required List<double> samples,
    required double height,
    required double width,
    required Duration maxDuration,
    required Duration elapsedDuration,
  }) : super(
          key: key,
          samples: samples,
          height: height,
          width: width,
          maxDuration: maxDuration,
          elapsedDuration: elapsedDuration,
        );

  @override
  AudioWaveformState<PolygonWaveform> createState() => _PolygonWaveformState();
}

class _PolygonWaveformState extends AudioWaveformState<PolygonWaveform> {
  @override
  Widget build(BuildContext context) {
    final processedSamples = this.processedSamples;
    final activeIndex = this.activeIndex;
    return CustomPaint(
      size: Size(widget.width, widget.height),
      painter: PolygonWaveformPainter(
        samples: processedSamples,
        activeIndex: activeIndex,
        color: Colors.blue,
      ),
    );
  }
}

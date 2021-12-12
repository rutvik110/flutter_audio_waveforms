import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/helpers/waveform_alignment.dart';
import 'package:flutter_audio_waveforms/waveforms/waveform_painters_ab.dart';

/// Rectangle Active Waveform Painter
class RectangleActiveWaveformPainter extends ActiveWaveformPainter {
  // ignore: public_member_api_docs
  RectangleActiveWaveformPainter({
    required Color color,
    Gradient? gradient,
    required List<double> samples,
    required List<double> activeSamples,
    required WaveformAlignment waveformAlignment,
    required this.borderColor,
    required this.borderWidth,
    required double sampleWidth,
  }) : super(
          samples: samples,
          color: color,
          gradient: gradient,
          activeSamples: activeSamples,
          waveformAlignment: waveformAlignment,
          sampleWidth: sampleWidth,
        );

  /// width of the border
  final double borderWidth;

  /// color of the border
  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final activeTrackPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = color
      ..shader = gradient?.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = borderColor
      ..strokeWidth = borderWidth;

    final alignPosition = waveformAlignment.getAlignPosition(size.height);

    for (var i = 0; i < activeSamples.length; i++) {
      final x = sampleWidth * i;
      final y = activeSamples[i];

      canvas
        ..drawRect(
          Rect.fromLTWH(x, alignPosition, sampleWidth, y),
          activeTrackPaint,
        )
        ..drawRect(
          Rect.fromLTWH(x, alignPosition, sampleWidth, y),
          strokePaint,
        );
    }
  }
}

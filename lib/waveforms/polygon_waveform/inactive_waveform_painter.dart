import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/helpers/waveform_alignment.dart';
import 'dart:ui';
import 'package:flutter_audio_waveforms/waveforms/waveform_painters_ab.dart';

///InActive Waveform Painter
class PolygonInActiveWaveformPainter extends InActiveWaveformPainter {
  // ignore: public_member_api_docs
  PolygonInActiveWaveformPainter({
    Color color = Colors.white,
    Gradient? gradient,
    required List<double> samples,
    required WaveformAlignment waveformAlignment,
    required this.style,
    required double sampleWidth,
  }) : super(
          samples: samples,
          color: color,
          gradient: gradient,
          waveformAlignment: waveformAlignment,
          sampleWidth: sampleWidth,
        );

  ///Style of the waveform
  final PaintingStyle style;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = style
      ..color = color
      ..shader = gradient?.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    final path = Path();

    for (var i = 0; i < samples.length; i++) {
      final x = sampleWidth * i;
      final y = samples[i];
      path.lineTo(x, y);
    }

    final alignPosition = waveformAlignment.getAlignPosition(size.height);

    final shiftedPath = path.shift(Offset(0, alignPosition));

    canvas.drawPath(shiftedPath, paint);
  }
}

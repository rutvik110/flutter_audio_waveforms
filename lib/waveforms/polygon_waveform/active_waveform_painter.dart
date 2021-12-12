import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/helpers/waveform_align.dart';
import 'package:flutter_audio_waveforms/waveforms/waveform_painters_ab.dart';

///Polygon Active Waveform painter
class PolygonActiveWaveformPainter extends ActiveWaveformPainter {
  // ignore: public_member_api_docs
  PolygonActiveWaveformPainter({
    required Color color,
    Gradient? gradient,
    required List<double> samples,
    required List<double> activeSamples,
    required WaveformAlignment waveformAlignment,
    required this.style,
    required double sampleWidth,
  }) : super(
          samples: samples,
          color: color,
          gradient: gradient,
          activeSamples: activeSamples,
          waveformAlignment: waveformAlignment,
          sampleWidth: sampleWidth,
        );

  ///Style of the waveform
  final PaintingStyle style;
  @override
  void paint(Canvas canvas, Size size) {
    final continousActivePaint = Paint()
      ..style = style
      ..color = color
      ..shader = gradient?.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    final path = Path();
    final isStroked = style == PaintingStyle.stroke;

    for (var i = 0; i < activeSamples.length; i++) {
      final x = sampleWidth * i;
      final y = activeSamples[i];
      if (isStroked) {
        path.lineTo(x, y);
      } else {
        if (i == activeSamples.length - 1) {
          path.lineTo(x, 0);
        } else {
          path.lineTo(x, y);
        }
      }
    }

    final alignPosition = waveformAlignment.getAlignPosition(size.height);

    final shiftedPath = path.shift(Offset(0, alignPosition));

    canvas.drawPath(shiftedPath, continousActivePaint);
  }
}

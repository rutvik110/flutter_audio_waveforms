import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/src/core/waveform_painters_ab.dart';
import 'package:flutter_audio_waveforms/src/util/waveform_alignment.dart';
import 'package:flutter_audio_waveforms/src/waveforms/polygon_waveform/polygon_waveform.dart';

///InActiveWaveformPainter for the [PolygonWaveform]
class CurvedPolygonActiveInActiveWaveformPainter
    extends ActiveInActiveWaveformPainter {
  // ignore: public_member_api_docs
  CurvedPolygonActiveInActiveWaveformPainter({
    required super.samples,
    required super.waveformAlignment,
    required super.sampleWidth,
    required super.activeRatio,
    required super.inactiveColor,
    required super.activeColor,
    required super.strokeWidth,
    required super.style,
  });

  @override
  // ignore: long-method
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = style
      ..color = color
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..shader = LinearGradient(
        begin: const Alignment(-1.001, 0),
        end: const Alignment(1.001, 0),
        colors: [
          activeColor,
          inactiveColor,
        ],
        stops: [activeRatio, 0],
      ).createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    final path = Path();

    final bezierSamplesList = <double>[];
    for (var i = 0; i < samples.length; i++) {
      final currentPoint = samples[i];
      final nextPoint = i + 1 > samples.length - 1 ? 0.0 : samples[i + 1];
      bezierSamplesList.add(currentPoint);
      // Addition of this two average points helps to get that curved effect.
      final averagePoint = (nextPoint + currentPoint) / 2;
      bezierSamplesList.add(averagePoint);
      final averagePoint2 = (nextPoint + averagePoint) / 2;
      bezierSamplesList.add(averagePoint2);
    }

    bezierSamplesList.add(0);
    final updatedWidth = size.width / bezierSamplesList.length;

    for (var i = 0; i < bezierSamplesList.length; i += 3) {
      final x = updatedWidth * i;
      final y = bezierSamplesList[i];
      final doNotDrawPath = i + 1 > bezierSamplesList.length - 1 ||
          i + 2 > bezierSamplesList.length - 1 ||
          i + 3 > bezierSamplesList.length - 1;

      if (!doNotDrawPath) {
        final x1 = updatedWidth * (i + 1);
        final y1 = bezierSamplesList[i + 1];
        final x2 = updatedWidth * (i + 2);
        final y2 = bezierSamplesList[i + 2];

        path.cubicTo(x, y, x1, y1, x2, y2);
      }
    }

    //Gets the [alignPosition] depending on [waveformAlignment]
    final alignPosition = waveformAlignment.getAlignPosition(size.height);

    //Shifts the path along y-axis by amount of [alignPosition]
    final shiftedPath = path.shift(Offset(0, alignPosition));

    canvas.drawPath(shiftedPath, paint);
  }
}

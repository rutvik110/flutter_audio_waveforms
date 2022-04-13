import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/src/core/waveform_painters_ab.dart';
import 'package:flutter_audio_waveforms/src/util/waveform_alignment.dart';
import 'package:flutter_audio_waveforms/src/waveforms/rectangle_waveform/rectangle_waveform.dart';

///InActiveWaveformPainter for the [RectangleWaveform].
class RectangleInActiveWaveformPainter extends InActiveWaveformPainter {
  // ignore: public_member_api_docs
  RectangleInActiveWaveformPainter({
    Color color = Colors.white,
    Gradient? gradient,
    required List<double> samples,
    required WaveformAlignment waveformAlignment,
    required double sampleWidth,
    required Color borderColor,
    required double borderWidth,
    required this.isRoundedRectangle,
  }) : super(
          samples: samples,
          color: color,
          gradient: gradient,
          waveformAlignment: waveformAlignment,
          sampleWidth: sampleWidth,
          borderColor: borderColor,
          borderWidth: borderWidth,
          style: PaintingStyle.fill,
        );

  final bool isRoundedRectangle;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = style
      ..color = color
      ..shader = gradient?.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = borderColor
      ..strokeWidth = borderWidth;
    //Gets the [alignPosition] depending on [waveformAlignment]
    final alignPosition = waveformAlignment.getAlignPosition(size.height);

    if (isRoundedRectangle) {
      drawRoundedRectangles(
        canvas,
        alignPosition,
        paint,
        borderPaint,
      );
    } else {
      drawRegularRectangles(
        canvas,
        alignPosition,
        paint,
        borderPaint,
      );
    }
  }

  void drawRegularRectangles(
    Canvas canvas,
    double alignPosition,
    Paint paint,
    Paint borderPaint,
  ) {
    for (var i = 0; i < samples.length; i++) {
      final x = sampleWidth * i;
      final y = samples[i];
      //Draws the filled rectangles of the waveform.
      canvas
        ..drawRect(
          Rect.fromLTWH(x, alignPosition, sampleWidth, y),
          paint,
        )
        //Draws the border for the rectangles of the waveform.
        ..drawRect(
          Rect.fromLTWH(x, alignPosition, sampleWidth, y),
          borderPaint,
        );
    }
  }

  void drawRoundedRectangles(
    Canvas canvas,
    double alignPosition,
    Paint paint,
    Paint borderPaint,
  ) {
    for (var i = 0; i < samples.length; i++) {
      if (i.isEven) {
        final x = sampleWidth * i;
        final y = samples[i];
        //Draws the filled rectangles of the waveform.
        canvas
          ..drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(x, alignPosition - y, sampleWidth, y * 2),
              const Radius.circular(100),
            ),
            paint,
          )
          //Draws the border for the rectangles of the waveform.
          ..drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(x, alignPosition - y, sampleWidth, y * 2),
              const Radius.circular(100),
            ),
            borderPaint,
          );
      }
    }
  }

  @override
  bool shouldRepaint(covariant RectangleInActiveWaveformPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return getShouldRepaintValue(oldDelegate) ||
        isRoundedRectangle != oldDelegate.isRoundedRectangle;
  }
}

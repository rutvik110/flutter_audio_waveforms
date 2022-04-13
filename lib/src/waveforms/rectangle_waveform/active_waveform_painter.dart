import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/src/core/waveform_painters_ab.dart';
import 'package:flutter_audio_waveforms/src/util/waveform_alignment.dart';
import 'package:flutter_audio_waveforms/src/waveforms/rectangle_waveform/rectangle_waveform.dart';

///ActiveWaveformPainter for the [RectangleWaveform]
class RectangleActiveWaveformPainter extends ActiveWaveformPainter {
  // ignore: public_member_api_docs
  RectangleActiveWaveformPainter({
    required Color color,
    required List<double> activeSamples,
    required WaveformAlignment waveformAlignment,
    required double sampleWidth,
    required Color borderColor,
    required double borderWidth,
    required this.isRoundedRectangle,
    Gradient? gradient,
  }) : super(
          color: color,
          gradient: gradient,
          activeSamples: activeSamples,
          waveformAlignment: waveformAlignment,
          sampleWidth: sampleWidth,
          borderColor: borderColor,
          borderWidth: borderWidth,
          style: PaintingStyle.fill,
        );
  final bool isRoundedRectangle;

  @override
  void paint(Canvas canvas, Size size) {
    final activeTrackPaint = Paint()
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
        activeTrackPaint,
        borderPaint,
      );
    } else {
      drawRegularRectangles(
        canvas,
        alignPosition,
        activeTrackPaint,
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
    for (var i = 0; i < activeSamples.length; i++) {
      final x = sampleWidth * i;
      final y = activeSamples[i];
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
    for (var i = 0; i < activeSamples.length; i++) {
      if (i.isEven) {
        final x = sampleWidth * i;
        final y = activeSamples[i];
        //Draws the filled rectangles of the waveform.
        canvas
          ..drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(x, alignPosition - y, sampleWidth, y * 2),
              Radius.circular(x),
            ),
            paint,
          )
          //Draws the border for the rectangles of the waveform.
          ..drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(x, alignPosition - y, sampleWidth, y * 2),
              Radius.circular(x),
            ),
            borderPaint,
          );
      }
    }
  }

  @override
  bool shouldRepaint(covariant RectangleActiveWaveformPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return getShouldRepaintValue(oldDelegate) ||
        isRoundedRectangle != oldDelegate.isRoundedRectangle;
  }
}

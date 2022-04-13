// ignore_for_file: public_member_api_docs

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
    required this.isCentered,
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
  final bool isCentered;

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
        waveformAlignment,
        isCentered,
      );
    } else {
      drawRegularRectangles(
        canvas,
        alignPosition,
        paint,
        borderPaint,
        waveformAlignment,
        isCentered,
      );
    }
  }

  // ignore: long-parameter-list
  void drawRegularRectangles(
    Canvas canvas,
    double alignPosition,
    Paint paint,
    Paint borderPaint,
    WaveformAlignment waveformAlignment,
    bool isCentered,
  ) {
    for (var i = 0; i < samples.length; i++) {
      final x = sampleWidth * i;
      final isAbsolute = waveformAlignment != WaveformAlignment.center;
      final y = isCentered && !isAbsolute ? samples[i] * 2 : samples[i];
      final positionFromTop =
          isCentered && !isAbsolute ? alignPosition - y / 2 : alignPosition;
      //Draws the filled rectangles of the waveform.
      canvas
        ..drawRect(
          Rect.fromLTWH(x, positionFromTop, sampleWidth, y),
          paint,
        )
        //Draws the border for the rectangles of the waveform.
        ..drawRect(
          Rect.fromLTWH(x, positionFromTop, sampleWidth, y),
          borderPaint,
        );
    }
  }

  // ignore: long-parameter-list
  void drawRoundedRectangles(
    Canvas canvas,
    double alignPosition,
    Paint paint,
    Paint borderPaint,
    WaveformAlignment waveformAlignment,
    bool isCentered,
  ) {
    for (var i = 0; i < samples.length; i++) {
      if (i.isEven) {
        final x = sampleWidth * i;
        final isAbsolute = waveformAlignment != WaveformAlignment.center;
        final y = isAbsolute
            ? samples[i]
            : !isCentered
                ? samples[i]
                : samples[i] * 2;
        final positionFromTop = isAbsolute
            ? alignPosition
            : !isCentered
                ? alignPosition
                : alignPosition - y / 2;
        //Draws the filled rectangles of the waveform.
        canvas
          ..drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(x, positionFromTop, sampleWidth, y),
              Radius.circular(x),
            ),
            paint,
          )
          //Draws the border for the rectangles of the waveform.
          ..drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(x, positionFromTop, sampleWidth, y),
              Radius.circular(x),
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
        isRoundedRectangle != oldDelegate.isRoundedRectangle ||
        isCentered != oldDelegate.isCentered;
  }
}

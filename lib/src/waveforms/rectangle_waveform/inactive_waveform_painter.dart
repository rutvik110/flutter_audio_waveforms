// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/src/core/waveform_painters_ab.dart';
import 'package:flutter_audio_waveforms/src/util/waveform_alignment.dart';
import 'package:flutter_audio_waveforms/src/waveforms/rectangle_waveform/rectangle_waveform.dart';

///InActiveWaveformPainter for the [RectangleWaveform].
class RectangleInActiveWaveformPainter extends InActiveWaveformPainter {
  // ignore: public_member_api_docs
  RectangleInActiveWaveformPainter({
    super.color = Colors.white,
    super.gradient,
    required super.samples,
    required super.waveformAlignment,
    required super.sampleWidth,
    required super.borderColor,
    required super.borderWidth,
    required this.isRoundedRectangle,
    required this.isCentered,
    super.style = PaintingStyle.fill,
  });

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
    final isAbsolute = waveformAlignment != WaveformAlignment.center;

    if (isRoundedRectangle) {
      drawRoundedRectangles(
        canvas,
        alignPosition,
        paint,
        borderPaint,
        waveformAlignment,
        isCentered,
        isAbsolute,
      );
    } else {
      drawRegularRectangles(
        canvas,
        alignPosition,
        paint,
        borderPaint,
        waveformAlignment,
        isCentered,
        isAbsolute,
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
    bool isAbsolute,
  ) {
    final isCenteredAndNotAbsolute = isCentered && !isAbsolute;
    for (var i = 0; i < samples.length; i++) {
      final x = sampleWidth * i;
      final y = isCenteredAndNotAbsolute ? samples[i] * 2 : samples[i];
      final positionFromTop =
          isCenteredAndNotAbsolute ? alignPosition - y / 2 : alignPosition;
      final rectangle = Rect.fromLTWH(x, positionFromTop, sampleWidth, y);

      //Draws the filled rectangles of the waveform.
      canvas
        ..drawRect(
          rectangle,
          paint,
        )
        //Draws the border for the rectangles of the waveform.
        ..drawRect(
          rectangle,
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
    bool isAbsolute,
  ) {
    final radius = Radius.circular(sampleWidth);
    final isAbsoluteAndNotCentered = isAbsolute || !isCentered;
    for (var i = 0; i < samples.length; i++) {
      if (i.isEven) {
        final x = sampleWidth * i;
        final y = isAbsoluteAndNotCentered ? samples[i] : samples[i] * 2;
        final positionFromTop =
            isAbsoluteAndNotCentered ? alignPosition : alignPosition - y / 2;
        final rectangle = Rect.fromLTWH(x, positionFromTop, sampleWidth, y);
        //Draws the filled rectangles of the waveform.
        canvas
          ..drawRRect(
            RRect.fromRectAndRadius(
              rectangle,
              radius,
            ),
            paint,
          )
          //Draws the border for the rectangles of the waveform.
          ..drawRRect(
            RRect.fromRectAndRadius(
              rectangle,
              radius,
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

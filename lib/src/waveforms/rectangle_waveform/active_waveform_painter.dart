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

    for (var i = 0; i < activeSamples.length; i++) {
      final x = sampleWidth * i;
      final y = activeSamples[i];

      //Draws the filled rectangles of the waveform.
      canvas
        ..drawRect(
          Rect.fromLTWH(x, alignPosition, sampleWidth, y),
          activeTrackPaint,
        )
        //Draws the border for the rectangles of the waveform.
        ..drawRect(
          Rect.fromLTWH(x, alignPosition, sampleWidth, y),
          borderPaint,
        );
    }
  }
}

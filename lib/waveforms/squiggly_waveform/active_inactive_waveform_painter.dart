import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/helpers/waveform_alignment.dart';
import 'package:flutter_audio_waveforms/waveforms/waveform_painters_ab.dart';

///Painter for the Squiggly Waveform
class SquigglyWaveformPainter extends ActiveInActiveWaveformPainter {
  // ignore: public_member_api_docs
  SquigglyWaveformPainter({
    required Color activeColor,
    required List<double> samples,
    required Color inactiveColor,
    required double activeRatio,
    required WaveformAlignment waveformAlignment,
    required double sampleWidth,
    required this.absolute,
    required this.invert,
    required this.strokeWidth,
  }) : super(
          samples: samples,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          activeRatio: activeRatio,
          waveformAlignment: waveformAlignment,
          sampleWidth: sampleWidth,
        );

  ///Whether to draw the waveform as an absolute value or not
  final bool absolute;

  ///Whether to invert the waveform or not
  final bool invert;

  ///The width of the stroke
  final double strokeWidth;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..shader = LinearGradient(
        begin: const Alignment(-1.001, 0),
        end: const Alignment(1.001, 0),
        colors: [activeColor, inactiveColor],
        stops: [activeRatio, 0],
      ).createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    final waveformPath = Path();
    if (!absolute) {
      paintDefaultWaveform(waveformPath, sampleWidth, invert);
    } else if (absolute && !invert) {
      downwardFacingAbsoluteWaveform(waveformPath, sampleWidth);
    } else {
      upwardFacingAbsoluteWaveform(waveformPath, sampleWidth);
    }

    final alignPosition = waveformAlignment.getAlignPosition(size.height);

    final shiftedPath = waveformPath.shift(Offset(0, alignPosition));

    canvas.drawPath(shiftedPath, paint);
  }

  /// Draws the default waveform
  // ignore: avoid_positional_boolean_parameters
  void paintDefaultWaveform(Path waveformPath, double pointWidth, bool invert) {
    for (var i = 0; i < samples.length; i++) {
      final value = samples[i];
      final upOrDown = invert ? i.isOdd : i.isEven;
      final x = pointWidth * i;
      final x2 = pointWidth * (i + 1);
      final y2 = upOrDown ? -value : value;
      final diameter = x2 - x;
      final radius = diameter / 2;
      waveformPath
        ..lineTo(x, y2)
        ..lineTo(x, upOrDown ? y2 - diameter : y2 + diameter)
        ..addArc(
          Rect.fromCircle(
            center:
                Offset(x2 - radius, upOrDown ? y2 - diameter : y2 + diameter),
            radius: radius,
          ),
          -math.pi,
          upOrDown ? math.pi : -math.pi,
        )
        ..lineTo(x2, y2);
    }
  }

  /// Draws the downward facing absolute waveform
  void upwardFacingAbsoluteWaveform(Path waveformPath, double pointWidth) {
    for (var i = 0; i < samples.length; i++) {
      final value = samples[i];
      final x = pointWidth * i;
      final x2 = pointWidth * (i + 1);
      final y2 = value;
      final diameter = x2 - x;
      final radius = diameter / 2;
      waveformPath
        ..lineTo(x, y2)
        ..lineTo(x, y2 + diameter)
        ..addArc(
          Rect.fromCircle(
            center: Offset(x2 - radius, y2 + diameter),
            radius: radius,
          ),
          -math.pi,
          -math.pi,
        )
        ..lineTo(x2, 0);
    }
    waveformPath.lineTo(0, 0);
  }

  /// Draws the upward facing absolute waveform

  void downwardFacingAbsoluteWaveform(Path waveformPath, double pointWidth) {
    for (var i = 0; i < samples.length; i++) {
      final value = samples[i];
      final x = pointWidth * i;
      final x2 = pointWidth * (i + 1);
      final y2 = -value;
      final diameter = x2 - x;
      final radius = diameter / 2;
      waveformPath
        ..lineTo(x, y2)
        ..lineTo(x, y2 - diameter)
        ..addArc(
          Rect.fromCircle(
            center: Offset(x2 - radius, y2 - diameter),
            radius: radius,
          ),
          math.pi,
          math.pi,
        )
        ..lineTo(x2, 0);
    }

    waveformPath.lineTo(0, 0);
  }
}

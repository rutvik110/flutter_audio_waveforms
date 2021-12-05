import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/helpers/waveform_align.dart';
import 'dart:math' as math;

import 'package:flutter_audio_waveforms/waveforms/waveform_painters_ab.dart';

class SquigglyWaveformPainter extends ActiveInActiveWaveformPainter {
  SquigglyWaveformPainter({
    required Color activeColor,
    required List<double> samples,
    required Color inactiveColor,
    required double activeRatio,
    required WaveformAlign waveformAlign,
    required double sampleWidth,
    required this.absolute,
    required this.invert,
    required this.strokeWidth,
  }) : super(
          samples: samples,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          activeRatio: activeRatio,
          waveformAlign: waveformAlign,
          sampleWidth: sampleWidth,
        );
  final bool absolute;
  final bool invert;
  final double strokeWidth;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..shader = LinearGradient(
        begin: const Alignment(-1.001, 0.0),
        end: const Alignment(1.001, 0.0),
        colors: [activeColor, inactiveColor],
        stops: [activeRatio, 0],
      ).createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    final waveformPath = Path();
    if (!absolute) {
      paintNormalWaveform(waveformPath, sampleWidth, invert);
    } else if (absolute && !invert) {
      downwardFacingAbsoluteWaveform(waveformPath, sampleWidth);
    } else {
      upwardFacingAbsoluteWaveform(waveformPath, sampleWidth);
    }

    final alignPosition = waveformAlign.getAlignPosition(size.height);

    final shiftedPath = waveformPath.shift(Offset(0, alignPosition));

    canvas.drawPath(shiftedPath, paint);
  }

  void paintNormalWaveform(Path waveformPath, double pointWidth, bool invert) {
    for (var i = 0; i < samples.length; i++) {
      final value = samples[i];
      final bool upOrDown = invert ? i.isOdd : i.isEven;
      final double x = pointWidth * i;
      final double x2 = pointWidth * (i + 1);
      final double y2 = upOrDown ? -value : value;
      final double diameter = x2 - x;
      final double radius = diameter / 2;
      waveformPath.lineTo(x, y2);
      waveformPath.lineTo(x, upOrDown ? y2 - diameter : y2 + diameter);
      waveformPath.addArc(
        Rect.fromCircle(
          center: Offset(x2 - radius, upOrDown ? y2 - diameter : y2 + diameter),
          radius: radius,
        ),
        -math.pi,
        upOrDown ? math.pi : -math.pi,
      );
      waveformPath.lineTo(x2, y2);
    }
  }

  void upwardFacingAbsoluteWaveform(Path waveformPath, double pointWidth) {
    for (var i = 0; i < samples.length; i++) {
      final value = samples[i];
      final double x = pointWidth * i;
      final double x2 = pointWidth * (i + 1);
      final double y2 = value;
      final double diameter = x2 - x;
      final double radius = diameter / 2;
      waveformPath.lineTo(x, y2);
      waveformPath.lineTo(x, y2 + diameter);
      waveformPath.addArc(
        Rect.fromCircle(
          center: Offset(x2 - radius, y2 + diameter),
          radius: radius,
        ),
        -math.pi,
        -math.pi,
      );
      waveformPath.lineTo(x2, 0);
    }
    waveformPath.lineTo(0, 0);
  }

  void downwardFacingAbsoluteWaveform(Path waveformPath, double pointWidth) {
    for (var i = 0; i < samples.length; i++) {
      final value = samples[i];
      final double x = pointWidth * i;
      final double x2 = pointWidth * (i + 1);
      final double y2 = -value;
      final double diameter = x2 - x;
      final double radius = diameter / 2;
      waveformPath.lineTo(x, y2);
      waveformPath.lineTo(x, y2 - diameter);
      waveformPath.addArc(
        Rect.fromCircle(
          center: Offset(x2 - radius, y2 - diameter),
          radius: radius,
        ),
        math.pi,
        math.pi,
      );
      waveformPath.lineTo(x2, 0);
    }

    waveformPath.lineTo(0, 0);
  }
}

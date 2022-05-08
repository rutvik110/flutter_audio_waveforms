import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/src/core/audio_waveform.dart';
import 'package:flutter_audio_waveforms/src/core/waveform_painters_ab.dart';
import 'package:scidart/numdart.dart' as numdart;
// import 'package:flutter_voice_processor/flutter_voice_processor.dart';
import 'package:scidart/scidart.dart' as scidart;

/// [FrequencyDistribution] paints a squiggly waveform.
/// The painter for this waveform is of the type [ActiveInActiveWaveformPainter]
///
/// {@tool snippet}
/// Example :
/// ```dart
/// FrequencyDistribution(
///   maxDuration: maxDuration,
///   elapsedDuration: elapsedDuration,
///   samples: samples,
///   height: 300,
///   width: MediaQuery.of(context).size.width,
/// )
///```
/// {@end-tool}
class FrequencyDistribution extends AudioWaveform {
  // ignore: public_member_api_docs
  FrequencyDistribution({
    Key? key,
    required List<double> samples,
    required double height,
    required double width,
    Duration? maxDuration,
    Duration? elapsedDuration,
    this.activeColor = Colors.red,
    this.inactiveColor = Colors.blue,
    this.strokeWidth = 1.0,
    this.style = PaintingStyle.stroke,
    bool showActiveWaveform = true,
    bool absolute = false,
    bool invert = false,
  })  : assert(strokeWidth >= 0, "strokeWidth can't be negative."),
        super(
          key: key,
          samples: samples,
          height: height,
          width: width,
          maxDuration: maxDuration,
          elapsedDuration: elapsedDuration,
          absolute: absolute,
          invert: invert,
          showActiveWaveform: showActiveWaveform,
        );

  /// The color of the active portion of the waveform.
  final Color activeColor;

  /// The color of the inactive portion of the waveform.
  final Color inactiveColor;

  /// The stroke width of the waveform.
  final double strokeWidth;

  /// waveform style
  final PaintingStyle style;

  @override
  AudioWaveformState<FrequencyDistribution> createState() =>
      _SquigglyWaveformState();
}

class _SquigglyWaveformState extends AudioWaveformState<FrequencyDistribution> {
  @override
  Widget build(BuildContext context) {
    if (widget.samples.isEmpty) {
      return const SizedBox.shrink();
    }
    final processedSamples = widget.samples.sublist(this.activeIndex);
    final numdart.ArrayComplex arrayComplex =
        numdart.ArrayComplex(processedSamples
            .map<numdart.Complex>((e) => numdart.Complex(
                  real: e,
                ))
            .toList());
    final frquenceyList = scidart.fft(
      arrayComplex,
      n: 256,
      normalization: true,
    );
    final double maxNum = frquenceyList.reduce(
      (previousValue, element) {
        return previousValue.real > element.real ? previousValue : element;
      },
    ).real;

    final double multiplier = math.pow(maxNum, -1).toDouble();

    final samples = frquenceyList
        .map(
          (e) => numdart.Complex(
            real: e.real * multiplier * 100,
            imaginary: e.imaginary,
          ),
        )
        .toList();

    // samples.removeWhere(
    //   (element) => element.real < 0,
    // );
    numdart.ArrayComplex frequencies = numdart.ArrayComplex(samples);
    return CustomPaint(
      size: Size(widget.width, widget.height),
      isComplex: true,
      painter: FrequencyDistributionPainter(
        frequencies: frequencies,
      ),
    );
  }
}

class FrequencyDistributionPainter extends CustomPainter {
  FrequencyDistributionPainter({required this.frequencies});
  numdart.ArrayComplex frequencies;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue;
    for (var i = 0; i < frequencies.length; i++) {
      if (frequencies[i].real.isNegative) {
      } else {
        canvas.drawRect(
          Rect.fromLTWH(
            (5 * i).toDouble(),
            size.height / 2,
            2,
            -frequencies[i].real,
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:math' as math;

abstract class AudioWaveform extends StatefulWidget {
  const AudioWaveform({
    Key? key,
    required this.samples,
    required this.height,
    required this.width,
    required this.maxDuration,
    required this.elapsedDuration,
  }) : super(key: key);

  final List<double> samples;
  final double height;
  final double width;
  final Duration maxDuration;
  final Duration elapsedDuration;

  @override
  AudioWaveformState<AudioWaveform> createState();
}

abstract class AudioWaveformState<T extends AudioWaveform> extends State<T> {
  @protected
  late List<double> processedSamples;

  @protected
  late int activeIndex;

  @protected
  void _processSamples(List<double> samples) {
    processedSamples = samples.map((e) => e * widget.height).toList();

    final maxNum =
        processedSamples.reduce((a, b) => math.max(a.abs(), b.abs()));
    final double multiplier = math.pow(maxNum, -1).toDouble();
    processedSamples = processedSamples
        .map((e) => e * multiplier * widget.height / 2)
        .toList();
    setState(() {});
  }

  @protected
  void _updateXAudio() {
    Duration maxDuration = widget.maxDuration;
    Duration elapsedDuration = widget.elapsedDuration;
    double elapsedTimeRatio =
        elapsedDuration.inMilliseconds / maxDuration.inMilliseconds;

    activeIndex = (processedSamples.length * elapsedTimeRatio).round();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    processedSamples = widget.samples;
    activeIndex = 0;

    if (processedSamples.isNotEmpty) {
      _processSamples(processedSamples);
    }
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.samples.length != oldWidget.samples.length) {
      _processSamples(widget.samples);
    }
    if (widget.elapsedDuration != oldWidget.elapsedDuration) {
      _updateXAudio();
    }
  }
}

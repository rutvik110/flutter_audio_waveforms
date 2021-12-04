import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/helpers/waveform_align.dart';

abstract class AudioWaveform extends StatefulWidget {
  const AudioWaveform({
    Key? key,
    required this.samples,
    required this.height,
    required this.width,
    required this.maxDuration,
    required this.elapsedDuration,
    required this.showActiveWaveform,
    this.absolute = false,
    this.invert = false,
  })  : waveformAlign = absolute
            ? invert
                ? WaveformAlign.top
                : WaveformAlign.bottom
            : WaveformAlign.center,
        super(key: key);

  final List<double> samples;
  final double height;
  final double width;
  final Duration maxDuration;
  final Duration elapsedDuration;
  final bool absolute;
  final bool invert;
  final bool showActiveWaveform;
  final WaveformAlign waveformAlign;

  @override
  AudioWaveformState<AudioWaveform> createState();
}

abstract class AudioWaveformState<T extends AudioWaveform> extends State<T> {
  late List<double> _processedSamples;

  List<double> get processedSamples => _processedSamples;

  @protected
  void updateProcessedSamples(List<double> value) {
    _processedSamples = value;
    setState(() {});
  }

  int get activeIndex => _activeIndex;

  late int _activeIndex;

  List<double> get activeSamples => _activeSamples;

  late List<double> _activeSamples;

  Duration get maxDuration => widget.maxDuration;
  Duration get elapsedDuration => widget.elapsedDuration;
  bool get showActiveWaveform => widget.showActiveWaveform;
  bool get invert => widget.absolute ? !widget.invert : widget.invert;
  bool get absolute => widget.absolute;
  WaveformAlign get waveformAlign => widget.waveformAlign;

  @protected
  void processSamples(List<double> samples) {
    _processedSamples = samples
        .map((e) => absolute ? e.abs() * widget.height : e * widget.height)
        .toList();

    final maxNum =
        _processedSamples.reduce((a, b) => math.max(a.abs(), b.abs()));
    final double multiplier = math.pow(maxNum, -1).toDouble();
    final finaHeight = absolute ? widget.height : widget.height / 2;
    _processedSamples = _processedSamples
        .map(
          (e) => invert
              ? -e * multiplier * finaHeight
              : e * multiplier * finaHeight,
        )
        .toList();
    setState(() {});
  }

  @protected
  void _updateXAudio() {
    double elapsedTimeRatio =
        elapsedDuration.inMilliseconds / maxDuration.inMilliseconds;

    _activeIndex = (_processedSamples.length * elapsedTimeRatio).round();

    setState(() {});
  }

  @protected
  void _updateActiveSamples() {
    _activeSamples = _processedSamples.sublist(0, _activeIndex);
  }

  @override
  void initState() {
    super.initState();

    _processedSamples = widget.samples;
    _activeIndex = 0;
    _activeSamples = [];

    if (_processedSamples.isNotEmpty) {
      processSamples(_processedSamples);
    }
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.samples.length != oldWidget.samples.length) {
      processSamples(widget.samples);
      _updateActiveSamples();
    }
    if (widget.height != oldWidget.height || widget.width != oldWidget.width) {
      processSamples(widget.samples);
      _updateActiveSamples();
    }
    if (widget.absolute != oldWidget.absolute) {
      processSamples(widget.samples);
      _updateActiveSamples();
    }
    if (widget.invert != oldWidget.invert) {
      processSamples(widget.samples);
      _updateActiveSamples();
    }
    if (widget.showActiveWaveform) {
      if (widget.elapsedDuration != oldWidget.elapsedDuration) {
        _updateXAudio();
        _updateActiveSamples();
      }
    }
  }
}

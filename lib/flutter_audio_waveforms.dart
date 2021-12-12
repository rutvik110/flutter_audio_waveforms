library flutter_audio_waveforms;

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/helpers/check_samples_equality.dart';
import 'package:flutter_audio_waveforms/helpers/waveform_align.dart';

/// A Standard Stateful widget to build skeleton for waveforms with core
/// functionality.
abstract class AudioWaveform extends StatefulWidget {
  /// Constructor for [AudioWaveform]
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

  /// Input from the user
  final List<double> samples;

  /// Height of the waveform
  final double height;

  /// Width of the waveform
  final double width;

  /// Maximum duration of the audio
  final Duration maxDuration;

  /// Elapsed duration of the audio
  final Duration elapsedDuration;

  /// Whether to show the absolute(*single direction waveform) waveform or not
  final bool absolute;

  /// Whether to invert the waveform or not
  final bool invert;

  /// Whether to show the active waveform(*represents elapsed duration) or not
  final bool showActiveWaveform;

  /// Alignment of the waveform
  final WaveformAlign waveformAlign;

  @override
  AudioWaveformState<AudioWaveform> createState();
}

/// State of the [AudioWaveform]
abstract class AudioWaveformState<T extends AudioWaveform> extends State<T> {
  late List<double> _processedSamples;

  ///getter for processed samples
  List<double> get processedSamples => _processedSamples;

  late double _sampleWidth;

  ///getter for sample width
  double get sampleWidth => _sampleWidth;

  ///Method for subsclass to update the processed samples
  @protected
  // ignore: use_setters_to_change_properties
  void updateProcessedSamples(List<double> updatedSamples) {
    _processedSamples = updatedSamples;
  }

  late int _activeIndex;

  ///getter for active samples
  List<double> get activeSamples => _activeSamples;

  late List<double> _activeSamples;

  ///getter for max Duration
  Duration get maxDuration => widget.maxDuration;

  ///getter for elapsed Duration
  Duration get elapsedDuration => widget.elapsedDuration;

  ///whether to show active waveform or not
  bool get showActiveWaveform => widget.showActiveWaveform;

  ///whether to show invert/flip waveform or not
  bool get invert => widget.absolute ? !widget.invert : widget.invert;

  ///whether to show absolute waveform or not
  bool get absolute => widget.absolute;

  ///getter for waveform align
  WaveformAlign get waveformAlign => widget.waveformAlign;

  ///Samples input from the user is processed before used following some
  ///standards. This is to have consistent samples that can be used to draw the
  ///waveform.
  @protected
  void processSamples() {
    final rawSamples = widget.samples;
    _processedSamples = rawSamples
        .map((e) => absolute ? e.abs() * widget.height : e * widget.height)
        .toList();

    final maxNum =
        _processedSamples.reduce((a, b) => math.max(a.abs(), b.abs()));
    final multiplier = math.pow(maxNum, -1).toDouble();
    final finaHeight = absolute ? widget.height : widget.height / 2;
    _processedSamples = _processedSamples
        .map(
          (e) => invert
              ? -e * multiplier * finaHeight
              : e * multiplier * finaHeight,
        )
        .toList();
  }

  void _calculateSampleWidth() {
    _sampleWidth = widget.width / (_processedSamples.length);
  }

  @protected
  void _updateActiveIndex({int? activeIndex}) {
    if (activeIndex != null) {
      _activeIndex = activeIndex;

      return;
    }
    final elapsedTimeRatio =
        elapsedDuration.inMilliseconds / maxDuration.inMilliseconds;

    _activeIndex = (widget.samples.length * elapsedTimeRatio).round();
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
    _sampleWidth = 0;

    if (_processedSamples.isNotEmpty) {
      processSamples();
      _calculateSampleWidth();
    }
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!checkforSamplesEquality(widget.samples, oldWidget.samples) &&
        widget.samples.isNotEmpty) {
      processSamples();
      _calculateSampleWidth();
      _updateActiveIndex(activeIndex: 0);
      _updateActiveSamples();
    }
    if (widget.showActiveWaveform) {
      if (widget.elapsedDuration != oldWidget.elapsedDuration) {
        _updateActiveIndex();
        _updateActiveSamples();
      }
    }
    if (widget.height != oldWidget.height || widget.width != oldWidget.width) {
      processSamples();
      _calculateSampleWidth();
      _updateActiveSamples();
    }
    if (widget.absolute != oldWidget.absolute) {
      processSamples();
      _updateActiveSamples();
    }
    if (widget.invert != oldWidget.invert) {
      processSamples();
      _updateActiveSamples();
    }
  }
}

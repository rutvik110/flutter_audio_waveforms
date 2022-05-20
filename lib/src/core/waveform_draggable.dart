import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';

class WaveformDraggableGestureDetector extends StatefulWidget {
  const WaveformDraggableGestureDetector({
    required this.waveform,
    this.onDragUpdate,
    this.onDragStart,
    this.onDragEnd,
    // required this.maxDuration,
    // required this.width,
    Key? key,
  }) : super(
          key: key,
        );

  final ValueChanged<Duration>? onDragUpdate;
  final ValueChanged<Duration>? onDragStart;
  final ValueChanged<Duration>? onDragEnd;
  final AudioWaveform waveform;

  @override
  State<WaveformDraggableGestureDetector> createState() =>
      _WaveformDraggableGestureDetectorState();
}

class _WaveformDraggableGestureDetectorState
    extends State<WaveformDraggableGestureDetector> {
  final GlobalKey containerKey = GlobalKey();
  late RenderBox renderBox;
  bool isRenderBoxInitialized = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.waveform.width;
    final maxDuration = widget.waveform.maxDuration;

    return GestureDetector(
      key: containerKey,
      onHorizontalDragStart: (details) {
        if (!isRenderBoxInitialized) {
          renderBox =
              containerKey.currentContext!.findRenderObject()! as RenderBox;
          isRenderBoxInitialized = true;
        }
      },
      onHorizontalDragUpdate: (details) {
        final position = renderBox.globalToLocal(details.globalPosition).dx;
        final visualPosition = position / width;
        if (visualPosition >= 0.0 && visualPosition <= 1.0) {
          final draggedTime =
              visualPosition * (maxDuration?.inMilliseconds ?? 0);
          widget.onDragUpdate!(Duration(milliseconds: draggedTime.toInt()));
        } else if (visualPosition < 0.0) {
          widget.onDragUpdate!(
            Duration.zero,
          );
        } else {
          widget.onDragUpdate!(
            Duration(
              milliseconds: maxDuration?.inMilliseconds ?? 0,
            ),
          );
        }
      },
      onHorizontalDragEnd: (details) {},
      child: widget.waveform,
    );
  }
}

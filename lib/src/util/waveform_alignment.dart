///Waveform align enum
enum WaveformAlignment {
  ///Aligns waveform to the top of the canvas.
  top,

  ///Aligns waveform to the center of the canvas.

  center,

  ///Aligns waveform to the bottom of the canvas.

  bottom,
}

///Extension to get Offset height based on waveform align
extension WaveformAlignmentExtension on WaveformAlignment {
  ///Gets offset height based on waveform align
  double getAlignPosition(double height) {
    switch (this) {
      case WaveformAlignment.top:
        return 0;
      case WaveformAlignment.center:
        return height / 2;
      case WaveformAlignment.bottom:
        return height;
    }
  }
}

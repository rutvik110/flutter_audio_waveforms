///Waveform align enum
enum WaveformAlign {
  ///Aligns waveform to the top of the canvas.
  top,

  ///Aligns waveform to the center of the canvas.

  center,

  ///Aligns waveform to the bottom of the canvas.

  bottom,
}

///Extension to get Offset height based on waveform align
extension WaveformAlignExtension on WaveformAlign {
  ///Gets offset height based on waveform align
  double getAlignPosition(double height) {
    switch (this) {
      case WaveformAlign.top:
        return 0;
      case WaveformAlign.center:
        return height / 2;
      case WaveformAlign.bottom:
        return height;
    }
  }
}

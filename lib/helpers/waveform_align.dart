enum WaveformAlign {
  top,
  center,
  bottom,
}

extension WaveformAlignExtension on WaveformAlign {
  double getShift(double height) {
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

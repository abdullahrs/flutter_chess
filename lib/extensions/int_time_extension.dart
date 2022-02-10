extension IntegerTimeExtension on int {
  String get timeString {
    int min = this ~/ 60;
    int sec = this - (min * 60);

    String minStr = min < 10 ? '0$min' : '$min';
    String secStr = sec < 10 ? '0$sec' : '$sec';

    return minStr + ':' + secStr;
  }
}

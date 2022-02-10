import '../constants/game_statuses.dart';

class TimerModel {
  final int whiteTime;
  final int blackTime;
  final int incrementAmount;

  TimerModel({
    required this.whiteTime,
    required this.blackTime,
    required this.incrementAmount,
  });

  TimerModel copyWith({int? wTime, int? bTime, int? increment}) {
    return TimerModel(
      whiteTime: wTime ?? whiteTime,
      blackTime: bTime ?? blackTime,
      incrementAmount: increment ?? incrementAmount,
    );
  }
}

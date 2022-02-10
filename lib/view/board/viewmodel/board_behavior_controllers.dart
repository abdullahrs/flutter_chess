import 'package:flutter_chess/constants/game_statuses.dart';

import '../../../model/timer_model.dart';
import 'time_controller.dart';

import '../../../model/board_model.dart';
import 'board_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final boardControllerProvider =
    StateNotifierProvider<BoardController, BoardModel>(
        (ref) => BoardController());

final resultController = Provider((ref) {
  final status =
      ref.watch(boardControllerProvider.select((value) => value.gameStatus));
  final timeStatus = ref.watch(timeControllerProvider);
  if (timeStatus.blackTime < 0 || timeStatus.whiteTime < 0) {
    return GameStatus.timeRunOut;
  }
  return status;
});

final timeControllerProvider =
    StateNotifierProvider<TimeController, TimerModel>(
        (ref) => TimeController());

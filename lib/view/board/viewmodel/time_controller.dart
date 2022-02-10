import 'package:flutter_chess/constants/game_statuses.dart';

import '../../../constants/piece_colors.dart';
import '../../../model/timer_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimeController extends StateNotifier<TimerModel> {
  TimeController()
      : super(TimerModel(blackTime: 0, incrementAmount: 0, whiteTime: 0));

  void init(int time, int inc) {
    state = state.copyWith(wTime: time, bTime: time, increment: inc);
  }

  void increment(PieceColor color) {
    if (PieceColor.white == color) {
      state = state.copyWith(wTime: state.whiteTime + state.incrementAmount);
    } else {
      state = state.copyWith(bTime: state.blackTime + state.incrementAmount);
    }
  }

  void decrement(PieceColor color) {
    if (PieceColor.white == color) {
      state = state.copyWith(wTime: state.whiteTime - 1);
    } else {
      state = state.copyWith(bTime: state.blackTime - 1);
    }
  }

  int getTime(PieceColor color) =>
      color == PieceColor.white ? state.whiteTime : state.blackTime;
}

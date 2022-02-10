import '../../../model/board_model.dart';
import 'board_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final boardControllerProvider =
    StateNotifierProvider<BoardController, BoardModel>(
        (ref) => BoardController());

final resultController = Provider((ref) {
  final status =
      ref.watch(boardControllerProvider.select((value) => value.gameStatus));

  return status;
});

import 'package:flutter/material.dart';
import '../viewmodel/board_behavior_controllers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/movement_types.dart';

class ChessBoard extends ConsumerWidget {
  const ChessBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        childAspectRatio: 1,
      ),
      itemCount: 64,
      itemBuilder: (BuildContext context, int index) {
        int x = index ~/ 8;
        int y = index % 8;
        return InkWell(
          onTap: () {
            final controller = ref.read(boardControllerProvider.notifier);
            controller.onClickSquare(x, y);
          },
          child: Container(
            decoration: BoxDecoration(
              color: (((index) ~/ 8) + index + 1) % 2 == 0
                  ? const Color(0xFFb58763)
                  : const Color(0xFFf0dab5),
              border: buildBorder(context, ref, x, y),
            ),
            child: buildChild(context, ref, x, y),
          ),
        );
      },
    );
  }

  BoxBorder? buildBorder(BuildContext context, WidgetRef ref, int x, int y) {
    final availableMoves = ref
        .watch(boardControllerProvider.select((value) => value.availableMoves));
    List moves = availableMoves
        .where((move) => move.positionX == x && move.positionY == y)
        .toList();
    if (moves.isNotEmpty) {
      var move = moves.first;
      return move.movementType == MovementType.capture
          ? move.isLegal
              ? Border.all(color: Colors.red)
              : Border.all(color: Colors.grey)
          : null;
    }
    return null;
  }

  Widget? buildChild(BuildContext context, WidgetRef ref, int x, int y) {
    final state = ref.watch(boardControllerProvider);
    List moves = state.availableMoves
        .where((move) => move.positionX == x && move.positionY == y)
        .toList();
    if (moves.isNotEmpty) {
      var move = moves.first;
      return state.board[x][y] != null
          ? state.board[x][y]!
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircleAvatar(
                backgroundColor: move.isLegal ? Colors.green : Colors.grey,
                radius: 2,
              ),
            );
    }
    return state.board[x][y];
  }
}

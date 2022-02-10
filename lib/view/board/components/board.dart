import 'package:flutter/material.dart';
import '../../../extensions/buildcontext_extension.dart';
import '../../../constants/board_consts.dart';
import '../../../style/chess_style.dart';
import '../viewmodel/board_behavior_controllers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/movement_types.dart';

class ChessBoard extends ConsumerWidget {
  const ChessBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final board = ref.read(boardControllerProvider).board;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        childAspectRatio: 1,
      ),
      itemCount: 64,
      itemBuilder: (BuildContext context, int index) {
        int x = index ~/ 8;
        int y = index % 8;
        return (board[x][y] == null)
            ? _dragTarget(ref, x, y, index)
            : Draggable(
                data: '$x,$y',
                child: _dragTarget(ref, x, y, index),
                feedback: SizedBox(
                    height: (context.screenWidth / 8),
                    width: (context.screenWidth / 8),
                    child: Material(child: _dragTarget(ref, x, y, index))),
                childWhenDragging: Container(
                    color: (((index) ~/ 8) + index + 1) % 2 == 0
                        ? ChessStyle.blackSquareColor
                        : ChessStyle
                            .whiteSquareColor), //_dragTarget(ref, x, y, index),
              );
      },
    );
  }

  DragTarget<String> _dragTarget(WidgetRef ref, int x, int y, int index) {
    final controller = ref.read(boardControllerProvider.notifier);
    return DragTarget(
      onWillAccept: (data) => true, //data is Piece ? true : false,
      onAccept: (String? data) {
        if (data != null) {
          ref
              .read(timeControllerProvider.notifier)
              .increment(ref.read(boardControllerProvider).colorToMove);
          controller.onClickSquare(int.parse(data[0]), int.parse(data[2]));
          controller.onClickSquare(x, y);
        }
      },
      builder: (context, candidateData, rejectedData) => InkWell(
          onTap: () {
            if (ref.read(boardControllerProvider).selectedSquare != null) {
              ref
                  .read(timeControllerProvider.notifier)
                  .increment(ref.read(boardControllerProvider).colorToMove);
            }
            controller.onClickSquare(x, y);
          },
          child: square(ref, x, y, index, context)),
    );
  }

  Stack square(WidgetRef ref, int x, int y, int index, BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: (((index) ~/ 8) + index + 1) % 2 == 0
                ? ChessStyle.blackSquareColor
                : ChessStyle.whiteSquareColor,
            border: buildBorder(context, ref, x, y),
          ),
          child: buildChild(context, ref, x, y),
        ),
        Visibility(
          visible: ((index + 1) % 8) - 1 == 0,
          child: Positioned(
            top: 0,
            left: 0,
            child: Text(
              "${((index + 1) % 8) * (x + 1)}",
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
        Visibility(
          visible: x == 7,
          child: Positioned(
            bottom: 0,
            right: 0,
            child: Text(
              kColumnNames[y],
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
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
      return (state.board[x][y] != null)
          ? state.board[x][y]
          : SizedBox.expand(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircleAvatar(
                  backgroundColor: move.isLegal ? Colors.green : Colors.grey,
                  radius: 2,
                ),
              ),
            );
    }
    return state.board[x][y];
  }
}

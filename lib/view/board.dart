import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants/movement_types.dart';
import '../viewmodel/board_cubit.dart';

class ChessBoard extends StatelessWidget {
  const ChessBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BoardCubit(),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
          childAspectRatio: 1,
        ),
        itemCount: 64,
        itemBuilder: (BuildContext context, int index) {
          int x = index ~/ 8;
          int y = index % 8;
          return BlocConsumer<BoardCubit, BoardState>(
            listener: (context, state) {},
            builder: (context, state) {
              return InkWell(
                onTap: () {
                  context.read<BoardCubit>().onClickSquare(x, y);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: (((index) ~/ 8) + index + 1) % 2 == 0
                        ? const Color(0xFFb58763)
                        : const Color(0xFFf0dab5),
                    border: buildBorder(context, state, x, y),
                  ),
                  child: buildChild(context, state, x, y),
                ),
              );
            },
          );
        },
      ),
    );
  }

  BoxBorder? buildBorder(BuildContext context, BoardState state, int x, int y) {
    if (state is MovesCalculated) {
      List moves = state.movements
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
    }
    return null;
  }

  Widget? buildChild(BuildContext context, BoardState state, int x, int y) {
    if (state is MovesCalculated) {
      List moves = state.movements
          .where((move) => move.positionX == x && move.positionY == y)
          .toList();
      if (moves.isNotEmpty) {
        var move = moves.first;
        return context.read<BoardCubit>().board[x][y] != null
            ? context.read<BoardCubit>().board[x][y]!
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircleAvatar(
                  backgroundColor: move.isLegal ? Colors.green : Colors.grey,
                  radius: 2,
                ),
              );
      }
    }
    return context.read<BoardCubit>().board[x][y];
  }
}

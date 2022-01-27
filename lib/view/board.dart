import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../viewmodel/board_cubit.dart';

class ChessBoard extends StatelessWidget {
  const ChessBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BoardCubit()..initializeBoard(),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
          childAspectRatio: 1,
        ),
        itemCount: 64,
        itemBuilder: (BuildContext context, int index) {
          int x = index ~/ 8;
          int y = index % 8;
          return BlocSelector<BoardCubit, BoardState, BoardState>(
            selector: (state) {
              return state;
            },
            builder: (context, state) {
              return BlocConsumer<BoardCubit, BoardState>(
                listener: (context, state) {},
                builder: (context, state) {
                  return Container(
                    decoration: BoxDecoration(
                        color: (((index) ~/ 8) + index + 1) % 2 == 0
                            ? const Color(0xFFb58763)
                            : const Color(0xFFf0dab5)),
                    child: context.read<BoardCubit>().board[x][y],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

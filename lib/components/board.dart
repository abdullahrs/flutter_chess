import 'package:flutter/material.dart';
import 'package:flutter_chess/components/piece.dart';
import 'package:flutter_chess/config/board_map.dart';
import 'package:flutter_chess/config/pieces.dart';
import 'package:flutter_chess/controller/board_controller.dart';
import 'package:get/get.dart';

class Board extends StatelessWidget {
  const Board({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    BoardController _boardController = Get.find();
    return GetBuilder<BoardController>(builder: (_) {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
          childAspectRatio: 1,
        ),
        itemCount: 64,
        itemBuilder: (BuildContext context, int index) {
          int x = index ~/ 8;
          int y = index % 8;
          return Container(
            decoration: BoxDecoration(
                color: (((index) ~/ 8) + index + 1) % 2 == 0
                    ? const Color(0xFFf0dab5)
                    : const Color(0xFFb58763)),
            child: boardMatrix[x][y] == null
                ? emptySquare(_boardController, x, y)
                : Piece(
                    pieceModel: boardMatrix[x][y],
                  ),
          );
        },
      );
    });
  }

  GestureDetector emptySquare(BoardController _boardController, int x, int y) {
    return GestureDetector(
      onTap: () {
        onClickEmptySquare(_boardController, x, y);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              width: _boardController.tapped &&
                      _boardController.activeSquares(x, y)
                  ? 4
                  : 0,
              color: _boardController.tapped &&
                      _boardController.activeSquares(x, y)
                  ? Colors.green
                  : Colors.transparent),
        ),
      ),
    );
  }

  void onClickEmptySquare(BoardController _boardController, int x, int y) {
    if (_boardController.tapped &&
        boardMatrix[_boardController.pX!][_boardController.pY!].color ==
            _boardController.colorToMove) {
      if (boardMatrix[_boardController.pX!][_boardController.pY!].piece ==
              Pieces.Pawn &&
          (boardMatrix[_boardController.pX!][_boardController.pY!].piece ==
              boardMatrix[_boardController.pX!][y].piece) &&
          boardMatrix[_boardController.pX!][_boardController.pY!].color !=
              boardMatrix[_boardController.pX!][y].color) {
        _boardController.enPassantPawnTake(x, y);
      } else {
        _boardController.normalMovement(x, y);
      }
      _boardController.update();
    }
  }
}

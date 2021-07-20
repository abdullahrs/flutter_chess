import 'package:flutter/material.dart';
import 'package:flutter_chess/components/piece.dart';
import 'package:flutter_chess/config/board_map.dart';
import 'package:flutter_chess/config/pieces.dart';
import 'package:flutter_chess/controller/board_controller.dart';
import 'package:flutter_chess/model/piece_model.dart';
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
                ? GestureDetector(
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
                  )
                : Piece(
                    pieceModel: boardMatrix[x][y],
                  ),
          );
        },
      );
    });
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
        enPassantPawnTake(_boardController, x, y);
      } else {
        normalMovement(_boardController, x, y);
      }
      _boardController.update();
    }
  }

  void normalMovement(BoardController _boardController, int x, int y) {
    if (movementIsAvailable(_boardController, x, y)) {
      Movement type = getMovementType(_boardController, x, y);
      if (type == Movement.Promote) {
        // TODO: Promotion
      } else {
        Map<String, dynamic> data = {};
        data['piece'] = PieceModel.fromObject(
            boardMatrix[_boardController.pX!][_boardController.pY!]);
        data['preX'] = _boardController.previousPx;
        data['preY'] = _boardController.previousPy;
        data['px'] = _boardController.pX;
        data['py'] = _boardController.pY;

        boardMatrix[x][y] = PieceModel.fromObject(
            boardMatrix[_boardController.pX!][_boardController.pY!]);
        boardMatrix[x][y].x = x;
        boardMatrix[x][y].y = y;
        boardMatrix[_boardController.pX!][_boardController.pY!] = null;
        _boardController.previousPx = _boardController.pX;
        _boardController.previousPy = _boardController.pY;
        _boardController.pX = x;
        _boardController.pY = y;
        if (!_boardController.kingIsSafe) {
          boardMatrix[x][y] = null;
          _boardController.previousPx = boardMatrix[x][y];
          _boardController.previousPy = data['preY'];
          _boardController.pX = data['px'];
          _boardController.pY = data['py'];
          boardMatrix[_boardController.pX!][_boardController.pY!] =
              data['piece'];
          return;
        }
        boardMatrix[x][y].moved = true;
        _boardController.tapped = false;
        castling(type, y, _boardController);
        observeKings(_boardController, x, y);
        _boardController.colorToMove =
            PieceColor.Black == _boardController.colorToMove
                ? PieceColor.White
                : PieceColor.Black;
      }
      _boardController.availableMoves.clear();
    }
  }

  void observeKings(BoardController _boardController, int x, int y) {
    if (boardMatrix[_boardController.pX!][_boardController.pY!].piece ==
        Pieces.King) {
      if (boardMatrix[_boardController.pX!][_boardController.pY!].color ==
          PieceColor.Black) {
        _boardController.blackKingPosition = [x, y];
      } else {
        _boardController.whiteKingPosition = [x, y];
      }
    }
  }

  void castling(Movement type, int y, BoardController _boardController) {
    // TODO: Aradaki kareler atak altinda ise rook atma
    if (type == Movement.Castles) {
      // Short castling
      if (y == 6) {
        print("Short castling");
        if (PieceColor.White ==
            boardMatrix[_boardController.pX!][_boardController.pY!].color) {
          boardMatrix[7][5] = boardMatrix[7][7];
          boardMatrix[7][7] = null;
          boardMatrix[7][5].moved = true;
        } else {
          boardMatrix[0][5] = boardMatrix[0][7];
          boardMatrix[0][7] = null;
          boardMatrix[0][5].moved = true;
        }
      }
      // Long castling
      if (y == 2) {
        print("Long castling");
        if (PieceColor.White ==
            boardMatrix[_boardController.pX!][_boardController.pY!].color) {
          boardMatrix[7][3] = boardMatrix[7][0];
          boardMatrix[7][0] = null;
          boardMatrix[7][3].moved = true;
          boardMatrix[7][3].x = 7;
          boardMatrix[7][3].y = 3;
        } else {
          boardMatrix[0][3] = boardMatrix[0][0];
          boardMatrix[0][0] = null;
          boardMatrix[0][3].moved = true;
          boardMatrix[0][3].x = 0;
          boardMatrix[0][3].y = 3;
        }
      }
    }
  }

  void enPassantPawnTake(BoardController _boardController, int x, int y) {
    boardMatrix[_boardController.previousPx!][y] = null;
    normalMovement(_boardController, x, y);
  }

  bool movementIsAvailable(BoardController _boardController, int x, int y) {
    for (dynamic l in _boardController.availableMoves) {
      if (l[0] == x && l[1] == y) {
        return true;
      }
    }
    return false;
  }

  Movement getMovementType(BoardController _boardController, int x, int y) {
    for (dynamic l in _boardController.availableMoves) {
      if (l[0] == x && l[1] == y) {
        return l[2];
      }
    }
    // for ignore_error
    return Movement.Move;
  }
}

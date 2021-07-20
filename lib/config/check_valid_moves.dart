import 'package:flutter_chess/config/board_map.dart';
import 'package:flutter_chess/config/pieces.dart';
import 'package:flutter_chess/controller/board_controller.dart';
import 'package:flutter_chess/model/piece_model.dart';
import 'package:get/get.dart';

class PieceMovements {
  static final BoardController _boardController = Get.find();

  static List<List<dynamic>?> pawnMoves(int x, int y, PieceColor pieceColor) {
    List<List<dynamic?>?> moves = [];
    int e = pieceColor == PieceColor.White ? -1 : 1;
    // Moves
    if (x == 1 || x == 6) {
      for (int i = 1; i <= 2; i++) {
        int newX = x + i * e;
        // Onunde tas varsa ilerlemesin
        if (boardMatrix[newX][y] != null) {
          break;
        }
        if (boardMatrix[newX][y] == null) {
          moves.add([newX, y, Movement.Move]);
        }
      }
    } else {
      if (boardMatrix[x + e][y] == null) {
        if (x + e == 0 || x + e == 7) {
          moves.add([x + e, y, Movement.Promote]);
        } else {
          moves.add([x + e, y, Movement.Move]);
        }
      }
    }

    // Normal takes
    if (y + 1 <= 7 &&
        boardMatrix[x + e][y + 1] != null &&
        boardMatrix[x + e][y + 1].color != pieceColor) {
      moves.add([x + e, y + 1, Movement.Take]);
    }
    if (y - 1 >= 0 &&
        boardMatrix[x + e][y - 1] != null &&
        boardMatrix[x + e][y - 1].color != pieceColor) {
      moves.add([x + e, y - 1, Movement.Take]);
    }
    if (_boardController.previousPx == x &&
        (_boardController.previousPy == y - 1 ||
            _boardController.previousPy == y + 1)) {
      // White left en-passant take && Black right en-passant take
      if (y - 1 >= 0 &&
          boardMatrix[x][y - 1] != null &&
          boardMatrix[x][y - 1].piece == Pieces.Pawn &&
          boardMatrix[x][y - 1].color != pieceColor &&
          _boardController.previousPy == y - 1 &&
          (x == 3 || x == 4)) {
        moves.add([x + e, y - 1, Movement.Take]);
      }
      // White right en-passant take && Black left en-passant take
      if (y + 1 <= 7 &&
          boardMatrix[x][y + 1] != null &&
          boardMatrix[x][y + 1].piece == Pieces.Pawn &&
          boardMatrix[x][y + 1].color != pieceColor &&
          _boardController.previousPy == y + 1 &&
          (x == 3 || x == 4)) {
        moves.add([x + e, y + 1, Movement.Take]);
      }
    }
    return moves;
  }

  static List<List<dynamic>?> knightMoves(int x, int y, PieceColor pieceColor) {
    List<List<dynamic?>?> moves = [];
    print("knightMoves : $x,$y [$pieceColor]");
    // Bottom left-right
    if (x + 2 <= 7) {
      if (y - 1 >= 0) {
        if (boardMatrix[x + 2][y - 1] == null) {
          moves.add([x + 2, y - 1, Movement.Move]);
        } else if (boardMatrix[x + 2][y - 1].color != pieceColor) {
          moves.add([x + 2, y - 1, Movement.Take]);
        }
      }
      if (y + 1 <= 7) {
        if (boardMatrix[x + 2][y + 1] == null) {
          moves.add([x + 2, y + 1, Movement.Move]);
        } else if (boardMatrix[x + 2][y + 1].color != pieceColor) {
          moves.add([x + 2, y + 1, Movement.Take]);
        }
      }
    }
    // Right
    if (y + 2 <= 7) {
      if (x - 1 >= 0) {
        if (boardMatrix[x - 1][y + 2] == null) {
          moves.add([x - 1, y + 2, Movement.Move]);
        } else if (boardMatrix[x - 1][y + 2].color != pieceColor) {
          moves.add([x - 1, y + 2, Movement.Take]);
        }
      }
      if (x + 1 <= 7) {
        if (boardMatrix[x + 1][y + 2] == null) {
          moves.add([x + 1, y + 2, Movement.Move]);
        } else if (boardMatrix[x + 1][y + 2].color != pieceColor) {
          moves.add([x + 1, y + 2, Movement.Take]);
        }
      }
    }
    // Left
    if (y - 2 >= 0) {
      if (x - 1 >= 0) {
        if (boardMatrix[x - 1][y - 2] == null) {
          moves.add([x - 1, y - 2, Movement.Move]);
        } else if (boardMatrix[x - 1][y - 2].color != pieceColor) {
          moves.add([x - 1, y - 2, Movement.Take]);
        }
      }
      if (x + 1 <= 7) {
        if (boardMatrix[x + 1][y - 2] == null) {
          moves.add([x + 1, y - 2, Movement.Move]);
        } else if (boardMatrix[x + 1][y - 2].color != pieceColor) {
          moves.add([x + 1, y - 2, Movement.Take]);
        }
      }
    }
    // Top left-right
    if (x - 2 >= 0) {
      if (y - 1 >= 0) {
        if (boardMatrix[x - 2][y - 1] == null) {
          moves.add([x - 2, y - 1, Movement.Move]);
        } else if (boardMatrix[x - 2][y - 1].color != pieceColor) {
          moves.add([x - 2, y - 1, Movement.Take]);
        }
      }
      if (y + 1 <= 7) {
        if (boardMatrix[x - 2][y + 1] == null) {
          moves.add([x - 2, y + 1, Movement.Move]);
        } else if (boardMatrix[x - 2][y + 1].color != pieceColor) {
          moves.add([x - 2, y + 1, Movement.Take]);
        }
      }
    }
    return moves;
  }

  static List<List<dynamic>?> bishopMoves(int x, int y, PieceColor pieceColor) {
    List<List<dynamic?>?> moves = [];
    print("bishopMoves : $x,$y [$pieceColor]");

    int i = x + 1;
    int j = y + 1;
    // Bottom-right
    while (i < 8 && j < 8) {
      if (boardMatrix[i][j] != null && boardMatrix[i][j].color == pieceColor) {
        break;
      } else if (boardMatrix[i][j] == null) {
        moves.add([i, j, Movement.Move]);
        i++;
        j++;
      } else {
        moves.add([i, j, Movement.Take]);
        break;
      }
    }
    // Top-left
    i = x - 1;
    j = y - 1;
    while (i >= 0 && j >= 0) {
      if (boardMatrix[i][j] != null && boardMatrix[i][j].color == pieceColor) {
        break;
      } else if (boardMatrix[i][j] == null) {
        moves.add([i, j, Movement.Move]);
        i--;
        j--;
      } else {
        moves.add([i, j, Movement.Take]);
        break;
      }
    }
    // Top-right
    i = x + 1;
    j = y - 1;
    while (i < 8 && j >= 0) {
      if (boardMatrix[i][j] != null && boardMatrix[i][j].color == pieceColor) {
        break;
      } else if (boardMatrix[i][j] == null) {
        moves.add([i, j, Movement.Move]);
        i++;
        j--;
      } else {
        moves.add([i, j, Movement.Take]);
        break;
      }
    }
    // Bottom-left
    i = x - 1;
    j = y + 1;
    while (i >= 0 && j < 8) {
      if (boardMatrix[i][j] != null && boardMatrix[i][j].color == pieceColor) {
        break;
      } else if (boardMatrix[i][j] == null) {
        moves.add([i, j, Movement.Move]);
        i--;
        j++;
      } else {
        moves.add([i, j, Movement.Take]);
        break;
      }
    }
    return moves;
  }

  static List<List<dynamic>?> castleMoves(int x, int y, PieceColor pieceColor) {
    List<List<dynamic?>?> moves = [];
    print("castleMoves : $x,$y [$pieceColor]");
    // Top
    int i = x - 1;
    while (i >= 0) {
      if (boardMatrix[i][y] != null && boardMatrix[i][y].color == pieceColor) {
        break;
      }
      if (boardMatrix[i][y] == null) {
        moves.add([i, y, Movement.Move]);
        i--;
      } else {
        moves.add([i, y, Movement.Take]);
        break;
      }
    }
    // Bottom
    i = x + 1;
    while (i < 8) {
      if (boardMatrix[i][y] != null && boardMatrix[i][y].color == pieceColor) {
        break;
      }
      if (boardMatrix[i][y] == null) {
        moves.add([i, y, Movement.Move]);
        i++;
      } else {
        moves.add([i, y, Movement.Take]);
        break;
      }
    }
    // Right
    int j = y + 1;
    while (j < 8) {
      if (boardMatrix[x][j] != null && boardMatrix[x][j].color == pieceColor) {
        break;
      }
      if (boardMatrix[x][j] == null) {
        moves.add([x, j, Movement.Move]);
        j++;
      } else {
        moves.add([x, j, Movement.Take]);
        break;
      }
    }
    // Left
    j = y - 1;
    while (j >= 0) {
      if (boardMatrix[x][j] != null && boardMatrix[x][j].color == pieceColor) {
        break;
      }
      if (boardMatrix[x][j] == null) {
        moves.add([x, j, Movement.Move]);
        j--;
      } else {
        moves.add([x, j, Movement.Take]);
        break;
      }
    }
    return moves;
  }

  static List<List<dynamic>?> queenMoves(int x, int y, PieceColor pieceColor) {
    return castleMoves(x, y, pieceColor) + bishopMoves(x, y, pieceColor);
  }

  static List<List<dynamic>?> kingMoves(int x, int y, PieceColor pieceColor) {
    List<List<dynamic?>?> moves = [];
    print("kingMoves : $x,$y [$pieceColor]");
    PieceColor oppositeColor =
        pieceColor == PieceColor.Black ? PieceColor.White : PieceColor.Black;
    // Normal moves
    // Top
    if (x - 1 >= 0 &&
        (boardMatrix[x - 1][y] == null ||
            (boardMatrix[x - 1][y] != null &&
                boardMatrix[x - 1][y].color != pieceColor))) {
      if (!squareHasDefender(x - 1, y, oppositeColor)) {
        moves.add([
          x - 1,
          y,
          boardMatrix[x - 1][y] == null ? Movement.Move : Movement.Take
        ]);
      }
    }
    // Top-right
    if ((x - 1 >= 0 && y + 1 < 8) &&
        (boardMatrix[x - 1][y + 1] == null ||
            (boardMatrix[x - 1][y + 1] != null &&
                boardMatrix[x - 1][y + 1].color != pieceColor))) {
      if (!squareHasDefender(x - 1, y + 1, oppositeColor))
        moves.add([
          x - 1,
          y + 1,
          boardMatrix[x - 1][y + 1] == null ? Movement.Move : Movement.Take
        ]);
    }
    // Right
    if (y + 1 < 8 &&
        (boardMatrix[x][y + 1] == null ||
            (boardMatrix[x][y + 1] != null &&
                boardMatrix[x][y + 1].color != pieceColor))) {
      if (!squareHasDefender(x, y + 1, oppositeColor))
        moves.add([
          x,
          y + 1,
          boardMatrix[x][y + 1] == null ? Movement.Move : Movement.Take
        ]);
    }
    // Bottom
    if (x + 1 < 8 &&
        (boardMatrix[x + 1][y] == null ||
            (boardMatrix[x + 1][y] != null &&
                boardMatrix[x + 1][y].color != pieceColor))) {
      if (!squareHasDefender(x + 1, y, oppositeColor))
        moves.add([
          x + 1,
          y,
          boardMatrix[x + 1][y] == null ? Movement.Move : Movement.Take
        ]);
    }
    // Bottom-left
    if ((x + 1 < 8 && y - 1 >= 0) &&
        (boardMatrix[x + 1][y - 1] == null ||
            (boardMatrix[x + 1][y - 1] != null &&
                boardMatrix[x + 1][y - 1].color != pieceColor))) {
      if (!squareHasDefender(x + 1, y - 1, oppositeColor))
        moves.add([
          x + 1,
          y - 1,
          boardMatrix[x + 1][y - 1] == null ? Movement.Move : Movement.Take
        ]);
    }
    // Left
    if (y - 1 >= 0 &&
        (boardMatrix[x][y - 1] == null ||
            (boardMatrix[x][y - 1] != null &&
                boardMatrix[x][y - 1].color != pieceColor))) {
      if (!squareHasDefender(x, y - 1, oppositeColor))
        moves.add([
          x,
          y - 1,
          boardMatrix[x][y - 1] == null ? Movement.Move : Movement.Take
        ]);
    }
    // Top-left
    if ((y - 1 >= 0 && x - 1 >= 0) &&
        (boardMatrix[x - 1][y - 1] == null ||
            (boardMatrix[x - 1][y - 1] != null &&
                boardMatrix[x - 1][y - 1].color != pieceColor))) {
      if (!squareHasDefender(x - 1, y - 1, oppositeColor))
        moves.add([
          x - 1,
          y - 1,
          boardMatrix[x - 1][y - 1] == null ? Movement.Move : Movement.Take
        ]);
    }
    // Long castling
    bool longCastlingControl = true;
    switch (pieceColor) {
      case PieceColor.White:
        if (!boardMatrix[x][y].moved && !boardMatrix[7][0].moved) {
          for (int j = y - 1; j > 0; j--) {
            if (boardMatrix[7][j] != null) {
              longCastlingControl = false;
              break;
            }
          }
          if (longCastlingControl) {
            moves.add([7, 2, Movement.Castles]);
          }
        }
        break;
      case PieceColor.Black:
        if (!boardMatrix[x][y].moved && !boardMatrix[0][0].moved) {
          for (int j = y - 1; j > 0; j--) {
            if (boardMatrix[0][j] != null) {
              longCastlingControl = false;
              break;
            }
          }
          if (longCastlingControl) {
            moves.add([0, 2, Movement.Castles]);
          }
        }
        break;
      default:
        throw (Exception(
            "[check_valid_moves][kingMoves] invalid case <pieceColor :$pieceColor>"));
    }
    // Short castling
    bool shortCastlingControl = true;
    switch (pieceColor) {
      case PieceColor.White:
        {
          if (!boardMatrix[x][y].moved &&
              (boardMatrix[7][7] != null && !boardMatrix[7][7].moved)) {
            for (int j = y + 1; j < 7; j++) {
              if (boardMatrix[7][j] != null) {
                shortCastlingControl = false;
                break;
              }
            }
            if (shortCastlingControl) {
              moves.add([7, 6, Movement.Castles]);
            }
          }
          break;
        }
      case PieceColor.Black:
        {
          if (!boardMatrix[x][y].moved &&
              (boardMatrix[0][7] != null && !boardMatrix[0][7].moved)) {
            for (int j = y + 1; j < 7; j++) {
              if (boardMatrix[0][j] != null) {
                shortCastlingControl = false;
                break;
              }
            }
            if (shortCastlingControl) {
              moves.add([0, 6, Movement.Castles]);
            }
          }
          break;
        }
      default:
        throw (Exception(
            "[check_valid_moves][kingMoves] invalid case <pieceColor :$pieceColor>"));
    }
    return moves;
  }

  static bool squareHasDefender(int x, int y, PieceColor pieceColor) {
    // Top
    for (int i = x - 1; i >= 0; i--) {
      if (boardMatrix[i][y] != null && boardMatrix[i][y].color != pieceColor) {
        break;
      }
      if (boardMatrix[i][y] != null &&
          boardMatrix[i][y].color == pieceColor &&
          (boardMatrix[i][y].piece != Pieces.Queen ||
              boardMatrix[i][y].piece != Pieces.Castle ||
              boardMatrix[i][y].piece != Pieces.King)) {
        break;
      }
      if (boardMatrix[i][y] != null &&
          boardMatrix[i][y].piece != Pieces.King &&
          i == x - 1) {
        return true;
      } else if (boardMatrix[i][y] != null &&
              (boardMatrix[i][y].piece != Pieces.Queen ||
                  boardMatrix[i][y].piece != Pieces.Castle) ||
          (boardMatrix[i][y].piece == Pieces.King && i == x - 1)) {
        return true;
      }
    }
    // Top-right diagonal
    int i = x - 1;
    int j = y + 1;
    while (i >= 0 && j < 8) {
      if (boardMatrix[i][j] != null && pieceColor != boardMatrix[i][j].color) {
        break;
      }
      if (boardMatrix[i][j] != null &&
          (boardMatrix[i][j].piece == Pieces.Castle ||
              boardMatrix[i][j].piece == Pieces.Knight)) {
        break;
      }
      if (boardMatrix[i][j] != null &&
          pieceColor == PieceColor.Black &&
          boardMatrix[i][j].piece == Pieces.Pawn &&
          i == x - 1 &&
          j == y + 1) {
        return true;
      } else if (boardMatrix[i][j] != null &&
          ((boardMatrix[i][j].piece == Pieces.Bishop ||
                  boardMatrix[i][j].piece == Pieces.Queen) ||
              (boardMatrix[i][j].piece == Pieces.King &&
                  j == y + 1 &&
                  i == x - 1))) {
        return true;
      }
      i--;
      j++;
    }
    // Right
    for (int j = y + 1; j < 8; j++) {
      if (boardMatrix[x][j] != null && boardMatrix[x][j].color != pieceColor) {
        break;
      }
      if (boardMatrix[x][j] != null &&
          (boardMatrix[x][j].piece == Pieces.Bishop ||
              boardMatrix[x][j].piece == Pieces.Pawn ||
              boardMatrix[x][j].piece == Pieces.Knight)) {
        break;
      } else if (boardMatrix[x][j] != null &&
          ((boardMatrix[x][j].piece == Pieces.Queen ||
                  boardMatrix[x][j].piece == Pieces.Castle) ||
              (boardMatrix[x][j].piece == Pieces.King && j == y + 1))) {}
    }
    // Bottom-right diagonal
    i = x + 1;
    j = y + 1;
    while (i < 8 && j < 8) {
      if (boardMatrix[i][j] != null && pieceColor != boardMatrix[i][j].color) {
        break;
      }
      if (boardMatrix[i][j] != null &&
          (boardMatrix[i][j].piece == Pieces.Castle ||
              boardMatrix[i][j].piece == Pieces.Knight)) {
        break;
      }
      if (boardMatrix[i][j] != null &&
          pieceColor == PieceColor.White &&
          boardMatrix[i][j].piece == Pieces.Pawn &&
          i == x + 1 &&
          j == y + 1) {
        return true;
      } else if (boardMatrix[i][j] != null &&
          ((boardMatrix[i][j].piece == Pieces.Bishop ||
                  boardMatrix[i][j].piece == Pieces.Queen) ||
              (boardMatrix[i][j].piece == Pieces.King &&
                  j == y + 1 &&
                  i == x + 1))) {
        return true;
      }
      i++;
      j++;
    }
    // Bottom
    for (int i = x + 1; i < 8; i++) {
      if (boardMatrix[i][y] != null && pieceColor != boardMatrix[i][y].color) {
        break;
      }
      if (boardMatrix[i][y] != null &&
          (boardMatrix[i][y].piece == Pieces.Bishop ||
              boardMatrix[i][y].piece == Pieces.Pawn ||
              boardMatrix[i][y].piece == Pieces.Knight)) break;
      if (boardMatrix[i][y] != null &&
          ((boardMatrix[i][y].piece == Pieces.Queen ||
                  boardMatrix[i][y].piece == Pieces.Castle) ||
              (boardMatrix[i][y].piece == Pieces.King && i == x + 1))) {
        return true;
      }
    }
    // Bottom-left diagonal
    i = x + 1;
    j = y - 1;
    while (i < 8 && j >= 0) {
      if (boardMatrix[i][j] != null && pieceColor != boardMatrix[i][j].color) {
        break;
      }
      if (boardMatrix[i][j] != null &&
          (boardMatrix[i][j].piece == Pieces.Castle ||
              boardMatrix[i][j].piece == Pieces.Knight)) {
        break;
      }
      if (boardMatrix[i][j] != null &&
          (pieceColor == PieceColor.White &&
              boardMatrix[i][j].piece == Pieces.Pawn &&
              i == x + 1 &&
              j == y - 1)) {
        return true;
      } else if (boardMatrix[i][j] != null &&
          ((boardMatrix[i][j].piece == Pieces.Bishop ||
                  boardMatrix[i][j].piece == Pieces.Queen) ||
              (boardMatrix[i][j].piece == Pieces.King &&
                  j == y + 1 &&
                  i == x - 1))) {
        return true;
      }
      i++;
      j--;
    }
    // Left
    for (int j = y - 1; j >= 0; j--) {
      if (boardMatrix[x][j] != null && pieceColor != boardMatrix[x][j].color) {
        break;
      }
      if (boardMatrix[x][j] != null &&
          (boardMatrix[x][j].piece == Pieces.Bishop ||
              boardMatrix[x][j].piece == Pieces.Pawn ||
              boardMatrix[x][j].piece == Pieces.Knight)) break;
      if (boardMatrix[x][j] != null &&
          ((boardMatrix[x][j].piece == Pieces.Queen ||
                  boardMatrix[x][j].piece == Pieces.Castle) ||
              (boardMatrix[x][j].piece == Pieces.King && j == j - 1))) {
        return true;
      }
    }
    // Top-left diagonal
    i = x - 1;
    j = y - 1;
    while (i >= 0 && j >= 0) {
      if (boardMatrix[i][j] != null && pieceColor != boardMatrix[i][j].color) {
        break;
      }
      if (boardMatrix[i][j] != null &&
          (boardMatrix[i][j].piece == Pieces.Castle ||
              boardMatrix[i][j].piece == Pieces.Knight)) {
        break;
      }
      if (boardMatrix[i][j] != null &&
          pieceColor == PieceColor.Black &&
          boardMatrix[i][j].piece == Pieces.Pawn &&
          i == x - 1 &&
          j == y - 1) {
        return true;
      } else if (boardMatrix[i][j] != null &&
          ((boardMatrix[i][j].piece == Pieces.Bishop ||
                  boardMatrix[i][j].piece == Pieces.Queen) ||
              (boardMatrix[i][j].piece == Pieces.King &&
                  j == y - 1 &&
                  i == x - 1))) {
        return true;
      }
      i--;
      j--;
    }
    return false;
  }

  static void calculateMoves(PieceModel pieceModel) {
    switch (pieceModel.piece) {
      case Pieces.Pawn:
        _boardController.availableMoves.value = PieceMovements.pawnMoves(
            pieceModel.x, pieceModel.y, pieceModel.color);
        break;
      case Pieces.Knight:
        _boardController.availableMoves.value = PieceMovements.knightMoves(
            pieceModel.x, pieceModel.y, pieceModel.color);
        break;
      case Pieces.Bishop:
        _boardController.availableMoves.value = PieceMovements.bishopMoves(
            pieceModel.x, pieceModel.y, pieceModel.color);
        break;
      case Pieces.Castle:
        _boardController.availableMoves.value = PieceMovements.castleMoves(
            pieceModel.x, pieceModel.y, pieceModel.color);
        break;
      case Pieces.Queen:
        _boardController.availableMoves.value = PieceMovements.queenMoves(
            pieceModel.x, pieceModel.y, pieceModel.color);
        break;
      case Pieces.King:
        _boardController.availableMoves.value = PieceMovements.kingMoves(
            pieceModel.x, pieceModel.y, pieceModel.color);
        break;
      default:
        throw (Exception("[piece][onClickPiece] invalid case"));
    }
  }
}

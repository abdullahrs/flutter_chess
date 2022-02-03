import 'calculate_movements.dart';

import '../model/piece_position_model.dart';
import '../model/movement_model.dart';

import '../constants/board_defination.dart';
import '../constants/piece_colors.dart';
import '../constants/directions.dart';
import '../constants/pieces.dart';

import '../components/board/piece.dart';

import 'calculate_indexes.dart';

class MovePolice {
  bool kingIsSafe(
      {required Board board,
      required PiecePosition kingPosition,
      required PieceColor kingColor}) {
    return squareIsSafe(
        board, kingPosition.positionX, kingPosition.positionY, kingColor);
  }

  bool moveIsLegal(
      {required Board board,
      required PiecePosition kingPosition,
      required PieceColor colorToMove,
      required Movement movement}) {
    // bool kingSafety = kingIsSafe(
    //     board: board, kingPosition: kingPosition, kingColor: colorToMove);
    // If king is under attack check if movement interrupt the attack move,
    // it is legal if it interrupts the attack; if not, its illegal
    // Apply move
    return checkMove(
        board: board,
        kingPosition: kingPosition,
        colorToMove: colorToMove,
        movement: movement);
  }

  /// x : square x coordinate
  ///
  /// y : square y coordinate
  ///
  /// color : colorToMove
  bool squareIsSafe(Board board, int x, int y, PieceColor color) {
    PieceColor selectedPieceColor = color;

    List<Direction> diagonals = [
      Direction.fromBLTTR,
      Direction.fromBRTTL,
      Direction.fromTLTBR,
      Direction.fromTRTBL
    ];

    List<Direction> lines = [
      Direction.top,
      Direction.left,
      Direction.right,
      Direction.bottom
    ];

    for (Direction direction in Direction.values) {
      int i = calcIndexForLines(direction, Coordinate.x, x);
      int j = calcIndexForLines(direction, Coordinate.y, y);

      while (i >= 0 && i < 8 && j >= 0 && j < 8) {
        Piece? square = board[i][j];

        if (square != null) {
          // Above the line is the stone belonging to its side.
          // There is no need to look ahead.
          if (selectedPieceColor == square.pieceModel.color) break;

          int sign = square.pieceModel.color == PieceColor.white ? 1 : -1;

          if (i == x + 1 * sign && (j == y + 1 || j == y - 1)) {
            if (square.pieceModel.piece == Pieces.pawn) {
              return false;
            }
          }

          if (diagonals.contains(direction) &&
              (square.pieceModel.piece == Pieces.bishop ||
                  square.pieceModel.piece == Pieces.queen)) {
            return false;
          }

          if (lines.contains(direction) &&
              (square.pieceModel.piece == Pieces.rook ||
                  square.pieceModel.piece == Pieces.queen)) {
            return false;
          }

          if (selectedPieceColor != square.pieceModel.color) break;
        }

        i = calcIndexForLines(direction, Coordinate.x, i);
        j = calcIndexForLines(direction, Coordinate.y, j);
      }
    }
    // If code reachs here it means diagonals and lines are clear
    // now we can check for knight attacks
    for (Direction direction in lines) {
      List<int> result = calcIndexForJump(direction, x, y);

      if (result[0] == 0) {
        int x = result[1];
        int y1 = result[2];
        int y2 = result[3];
        if (x >= 0 && x < 8) {
          if (y1 < 8 && y1 >= 0) {
            if (board[x][y1] != null &&
                board[x][y1]!.pieceModel.color != selectedPieceColor &&
                board[x][y1]!.pieceModel.piece == Pieces.knight) {
              return false;
            }
          }
          if (y2 >= 0 && y2 < 8) {
            if (board[x][y2] != null &&
                board[x][y2]!.pieceModel.color != selectedPieceColor &&
                board[x][y2]!.pieceModel.piece == Pieces.knight) {
              return false;
            }
          }
        }
      }
      if (result[0] == 1) {
        int y = result[1];
        int x1 = result[2];
        int x2 = result[3];
        if (y >= 0 && y < 8) {
          if (x1 < 8 && x1 >= 0) {
            if (board[x1][y] != null &&
                board[x1][y]!.pieceModel.color != selectedPieceColor &&
                board[x1][y]!.pieceModel.piece == Pieces.knight) {
              return false;
            }
          }
          if (x2 >= 0 && x2 < 8) {
            if (board[x2][y] != null &&
                board[x2][y]!.pieceModel.color != selectedPieceColor &&
                board[x2][y]!.pieceModel.piece == Pieces.knight) {
              return false;
            }
          }
        }
      }
    }
    return true;
  }

  bool checkMove(
      {required Board board,
      required PiecePosition kingPosition,
      required PieceColor colorToMove,
      required Movement movement}) {
    Board tempBoard =
        board.map((List<Piece?> e) => List<Piece?>.from(e)).toList();

    PiecePosition? tempKingPosition;

    if (tempBoard[movement.previousX][movement.previousY] != null &&
        tempBoard[movement.previousX][movement.previousY]!.pieceModel.piece ==
            Pieces.king) {
      tempKingPosition = PiecePosition(movement.positionX, movement.positionY);
    }

    tempBoard[movement.positionX][movement.positionY] = Piece(
      pieceModel: board[movement.previousX][movement.previousY]!
          .pieceModel
          .copyWith(
              piecePosition:
                  PiecePosition(movement.positionX, movement.positionY)),
    );

    tempBoard[movement.previousX][movement.previousY] = null;

    // Check again
    return kingIsSafe(
        board: tempBoard,
        kingPosition: tempKingPosition ?? kingPosition,
        kingColor: colorToMove);
  }

  /// true : continues
  ///
  /// false : check mate || stalemate
  bool checkAllMoves(Board board,
      {Movement? previousWhiteMove,
      Movement? previousBlackMove,
      required PiecePosition whiteKingPos,
      required PiecePosition blackKingPos,
      required PieceColor colorToMove}) {
    int numberOfMoves = 0;
    for (List<Piece?> row in board) {
      for (Piece? square in row) {
        if (square == null) continue;
        if(square.pieceModel.color == colorToMove) continue;
        List<Movement> moves = PieceMovementCalculator.instance.calculateMoves(
            square.pieceModel, board,
            whiteKingPos: whiteKingPos, blackKingPos: blackKingPos);
        numberOfMoves +=
            moves.where((element) => element.isLegal).toList().length;
      }
    }
    return numberOfMoves > 0;
  }
}

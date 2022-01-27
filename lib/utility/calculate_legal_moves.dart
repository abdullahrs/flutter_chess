import 'dart:developer';

import '../constants/movement_types.dart';
import '../constants/piece_colors.dart';

import '../components/board/piece.dart';
import '../constants/pieces.dart';
import '../model/movement_model.dart';
import '../model/piece_model.dart';

class PieceMovementCalculator {
  static final PieceMovementCalculator instance =
      PieceMovementCalculator._ctor();

  PieceMovementCalculator._ctor();

  List<List<Piece?>> boardMatrix = [];

  List<Movement> calculateMoves(PieceModel? model, List<List<Piece?>> board,
      {Movement? previousWhiteMove, Movement? previousBlackMove}) {
    boardMatrix = board;
    switch (model?.piece) {
      case Pieces.king:
        {
          return [];
        }
      case Pieces.queen:
        {
          return [];
        }
      case Pieces.bishop:
        {
          return [];
        }
      case Pieces.knight:
        {
          return [];
        }
      case Pieces.castle:
        {
          return [];
        }
      case Pieces.pawn:
        {
          return _calculatePawnMoves(
              model!, previousWhiteMove, previousBlackMove);
        }
      default:
        return [];
    }
  }

  List<Movement> _calculatePawnMoves(PieceModel model,
      Movement? previousWhiteMove, Movement? previousBlackMove) {
    log("[PawnMoves] Position <${model.piecePosition.positionX}, ${model.piecePosition.positionY}>");
    int x = model.piecePosition.positionX;
    int y = model.piecePosition.positionY;

    List<Movement> moves = [];
    // Variable that dynamically moves matrix indexes up or down
    int sign = model.color == PieceColor.white ? -1 : 1;

    // Promote
    if ((x + 1 * sign == 0 || x + 1 * sign == 7) &&
        boardMatrix[x + 1 * sign][y] == null) {
      moves.add(
        Movement(
          previousX: x,
          previousY: y,
          positionX: x + 1 * sign,
          positionY: y,
          movementType: MovementType.promote,
          // TODO: check if king is under attack
          isLegal: true,
        ),
      );
    }
    // Normal moves
    else if (boardMatrix[x + 1 * sign][y] == null) {
      moves.add(
        Movement(
          previousX: x,
          previousY: y,
          positionX: x + 1 * sign,
          positionY: y,
          movementType: MovementType.normal,
          // TODO: check if king is under attack
          isLegal: true,
        ),
      );
    }
    // If there is no obstacle pawn can move forward two squares.
    if ((x == 6 || x == 1) && boardMatrix[x + 1 * sign][y] == null) {
      if (boardMatrix[x + 2 * sign][y] == null) {
        moves.add(
          Movement(
            previousX: x,
            previousY: y,
            positionX: x + 2 * sign,
            positionY: y,
            movementType: MovementType.normal,
            // TODO: check if king is under attack
            isLegal: true,
          ),
        );
      }
    }
    // Left Capture
    if (y - 1 >= 0 && boardMatrix[x + 1 * sign][y - 1] != null) {
      PieceModel piece = (boardMatrix[x + 1 * sign][y - 1] as Piece).pieceModel;
      if (piece.color != model.color) {
        moves.add(
          Movement(
            previousX: x,
            previousY: y,
            positionX: x + 1 * sign,
            positionY: y - 1,
            movementType: MovementType.capture,
            // TODO: check if king is under attack
            isLegal: true,
          ),
        );
      }
    }
    // Right Capture
    if (y + 1 < 8 && boardMatrix[x + 1 * sign][y + 1] != null) {
      PieceModel piece = (boardMatrix[x + 1 * sign][y + 1] as Piece).pieceModel;
      if (piece.color != model.color) {
        moves.add(
          Movement(
            previousX: x,
            previousY: y,
            positionX: x + 1 * sign,
            positionY: y + 1,
            movementType: MovementType.capture,
            // TODO: check if king is under attack
            isLegal: true,
          ),
        );
      }
    }
    // Left En-passant
    Movement? movement = sign < 0 ? previousBlackMove : previousWhiteMove;
    if (movement == null) return moves;

    if (y - 1 >= 0 && boardMatrix[x + 1 * sign][y - 1] == null && boardMatrix[x][y - 1] != null) {
      PieceModel piece = (boardMatrix[x][y - 1] as Piece).pieceModel;
      if (model.color != piece.color &&
          movement.positionX == piece.piecePosition.positionX &&
          movement.positionY == piece.piecePosition.positionY &&
          piece.piece == Pieces.pawn) {
        moves.add(
          Movement(
            previousX: x,
            previousY: y,
            positionX: x + 1 * sign,
            positionY: y - 1,
            movementType: MovementType.enPassant,
            // TODO: check if king is under attack
            isLegal: true,
          ),
        );
      }
    }
    // Right En-passant
    if (y + 1 < 8 && boardMatrix[x + 1 * sign][y + 1] == null && boardMatrix[x][y + 1] != null) {
      PieceModel piece = (boardMatrix[x][y + 1] as Piece).pieceModel;
      if (model.color != piece.color &&
          movement.positionX == piece.piecePosition.positionX &&
          movement.positionY == piece.piecePosition.positionY &&
          piece.piece == Pieces.pawn) {
        moves.add(
          Movement(
            previousX: x,
            previousY: y,
            positionX: x + 1 * sign,
            positionY: y + 1,
            movementType: MovementType.enPassant,
            // TODO: check if king is under attack
            isLegal: true,
          ),
        );
      }
    }
    return moves;
  }
}

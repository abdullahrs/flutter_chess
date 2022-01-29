import 'dart:developer';

import '../components/board/piece.dart';

import '../constants/board_defination.dart';
import '../constants/movement_types.dart';
import '../constants/piece_colors.dart';
import '../constants/directions.dart';
import '../constants/pieces.dart';

import '../model/piece_position_model.dart';
import '../model/movement_model.dart';
import '../model/piece_model.dart';

import 'calculate_indexes.dart';
import 'move_police.dart';

part 'calculator_helper.dart';

class PieceMovementCalculator extends MovePolice {
  static final PieceMovementCalculator instance =
      PieceMovementCalculator._ctor();

  PieceMovementCalculator._ctor();

  Board boardMatrix = [];

  late PiecePosition whiteKingPosition;
  late PiecePosition blackKingPosition;

  List<Movement> calculateMoves(PieceModel? model, Board board,
      {Movement? previousWhiteMove,
      Movement? previousBlackMove,
      required PiecePosition whiteKingPos,
      required PiecePosition blackKingPos}) {
    boardMatrix = [...board];
    whiteKingPosition = whiteKingPos;
    blackKingPosition = blackKingPos;
    log("[calculateMoves] Piece : ${model?.piece}");
    switch (model?.piece) {
      case Pieces.king:
        {
          return _calculateKingMoves(model!);
        }
      case Pieces.queen:
        {
          List<Movement> moves = _calculateCastleMoves(model!);
          moves.addAll(_calculateBishopMoves(model));
          return moves;
        }
      case Pieces.castle:
        {
          return _calculateCastleMoves(model!);
        }
      case Pieces.bishop:
        {
          return _calculateBishopMoves(model!);
        }
      case Pieces.knight:
        {
          return _calculateKnightMoves(model!);
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

  List<Movement> _calculateKingMoves(PieceModel model) {
    List<Movement> moves = [];

    int x = model.piecePosition.positionX;
    int y = model.piecePosition.positionY;
    /*
     0  1  2
     3  X  5
     6  7  8
    */
    Map<int, List<int>> conversion = {
      0: [-1, -1],
      1: [-1, 0],
      2: [-1, 1],
      3: [0, -1],
      5: [0, 1],
      6: [1, -1],
      7: [1, 0],
      8: [1, 1],
    };

    for (int k = 0; k < 9; k++) {
      if (k == 4) continue;
      List<int> additions = conversion[k]!;
      int newX = x + additions[0];
      int newY = y + additions[1];
      if (newX < 0 || newX > 7 || newY < 0 || newY > 7) continue;
      Piece? square = boardMatrix[newX][newY];
      Movement? move = _getMovement(model, square, x, y, newX, newY);
      if (move != null) {
        if (move.positionX == -1) continue;
        moves.add(move);
      }
    }

    // Short castling
    if ((boardMatrix[x][y]!.pieceModel.piecePosition ==
                kInitialWhiteKingPosition ||
            boardMatrix[x][y]!.pieceModel.piecePosition ==
                kInitialBlackKingPosition) &&
        !boardMatrix[x][y]!.pieceModel.moved &&
        boardMatrix[x][y + 1] == null &&
        boardMatrix[x][y + 2] == null &&
        boardMatrix[x][y + 3] != null &&
        boardMatrix[x][y + 3]!.pieceModel.piece == Pieces.castle &&
        !boardMatrix[x][y + 3]!.pieceModel.moved) {
      Movement? move = _getMovement(
          model, boardMatrix[x][y + 2], x, y, x, y + 2,
          type: MovementType.shortCastle);
      if (move != null) moves.add(move);
    }
    // Long castling
    if ((boardMatrix[x][y]!.pieceModel.piecePosition ==
                kInitialWhiteKingPosition ||
            boardMatrix[x][y]!.pieceModel.piecePosition ==
                kInitialBlackKingPosition) &&
        !boardMatrix[x][y]!.pieceModel.moved &&
        boardMatrix[x][y - 1] == null &&
        boardMatrix[x][y - 2] == null &&
        boardMatrix[x][y - 3] == null &&
        boardMatrix[x][y - 4] != null &&
        boardMatrix[x][y - 4]!.pieceModel.piece == Pieces.castle &&
        !boardMatrix[x][y - 4]!.pieceModel.moved) {
      Movement? move = _getMovement(
          model, boardMatrix[x][y - 2], x, y, x, y - 2,
          type: MovementType.longCastle);
      if (move != null) moves.add(move);
    }
    return moves;
  }

  List<Movement> _calculateBishopMoves(PieceModel model) {
    List<Movement> moves = [];
    // Bottom left to top right diagonal
    moves.addAll(_calculateLineMoves(
        boardMatrix: boardMatrix,
        direction: Direction.fromBLTTR,
        model: model));
    // Bottom right to top left diagonal
    moves.addAll(_calculateLineMoves(
        boardMatrix: boardMatrix,
        direction: Direction.fromBRTTL,
        model: model));
    // Top left to bottom right diagonal
    moves.addAll(_calculateLineMoves(
        boardMatrix: boardMatrix,
        direction: Direction.fromTLTBR,
        model: model));
    // Top right to bottom left diagonal
    moves.addAll(_calculateLineMoves(
        boardMatrix: boardMatrix,
        direction: Direction.fromTRTBL,
        model: model));
    return moves;
  }

  List<Movement> _calculateCastleMoves(PieceModel model) {
    List<Movement> moves = [];

    // Towards the white pieces
    moves.addAll(_calculateLineMoves(
        boardMatrix: boardMatrix, direction: Direction.bottom, model: model));

    // Towards the black pieces
    moves.addAll(_calculateLineMoves(
        boardMatrix: boardMatrix, direction: Direction.top, model: model));

    // To the right of the board relative to white, (towards the white's kingside)
    moves.addAll(_calculateLineMoves(
        boardMatrix: boardMatrix, direction: Direction.right, model: model));

    // To the right of the board relative to white, (towards the white's quennside)
    moves.addAll(_calculateLineMoves(
        boardMatrix: boardMatrix, direction: Direction.left, model: model));
    return moves;
  }

  List<Movement> _calculateKnightMoves(PieceModel model) {
    List<Movement> moves = [];

    // Top
    moves.addAll(_calculateJumpMoves(
        boardMatrix: boardMatrix, direction: Direction.top, model: model));
    // Right
    moves.addAll(_calculateJumpMoves(
        boardMatrix: boardMatrix, direction: Direction.right, model: model));
    // Bottom
    moves.addAll(_calculateJumpMoves(
        boardMatrix: boardMatrix, direction: Direction.bottom, model: model));
    // Left
    moves.addAll(_calculateJumpMoves(
        boardMatrix: boardMatrix, direction: Direction.left, model: model));

    return moves;
  }

  List<Movement> _calculatePawnMoves(PieceModel model,
      Movement? previousWhiteMove, Movement? previousBlackMove) {
    int x = model.piecePosition.positionX;
    int y = model.piecePosition.positionY;

    List<Movement> moves = [];
    // Variable that dynamically moves matrix indexes up or down
    int sign = model.color == PieceColor.white ? -1 : 1;

    // Promote, If first or eight rank empty or opposite color piece
    if ((x + 1 * sign == 0 || x + 1 * sign == 7) &&
        (boardMatrix[x + 1 * sign][y] == null ||
            (boardMatrix[x + 1 * sign][y] != null &&
                boardMatrix[x + 1 * sign][y]!.pieceModel.color !=
                    model.color))) {
      moves.add(
        Movement(
          previousX: x,
          previousY: y,
          positionX: x + 1 * sign,
          positionY: y,
          movementType: MovementType.promote,
          isLegal: moveIsLegal(
            board: boardMatrix,
            colorToMove: model.color,
            kingPosition: model.color == PieceColor.white
                ? whiteKingPosition
                : blackKingPosition,
            movement: Movement(
                previousX: x,
                previousY: y,
                positionX: x + 1 * sign,
                positionY: y,
                movementType: MovementType.promote,
                isLegal: true),
          ),
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
          isLegal: moveIsLegal(
            board: boardMatrix,
            colorToMove: model.color,
            kingPosition: model.color == PieceColor.white
                ? whiteKingPosition
                : blackKingPosition,
            movement: Movement(
                previousX: x,
                previousY: y,
                positionX: x + 1 * sign,
                positionY: y,
                movementType: MovementType.normal,
                isLegal: true),
          ),
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
            isLegal: moveIsLegal(
              board: boardMatrix,
              colorToMove: model.color,
              kingPosition: model.color == PieceColor.white
                  ? whiteKingPosition
                  : blackKingPosition,
              movement: Movement(
                  previousX: x,
                  previousY: y,
                  positionX: x + 2 * sign,
                  positionY: y,
                  movementType: MovementType.normal,
                  isLegal: true),
            ),
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
            isLegal: moveIsLegal(
              board: boardMatrix,
              colorToMove: model.color,
              kingPosition: model.color == PieceColor.white
                  ? whiteKingPosition
                  : blackKingPosition,
              movement: Movement(
                  previousX: x,
                  previousY: y,
                  positionX: x + 1 * sign,
                  positionY: y - 1,
                  movementType: MovementType.capture,
                  isLegal: true),
            ),
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
            isLegal: moveIsLegal(
              board: boardMatrix,
              colorToMove: model.color,
              kingPosition: model.color == PieceColor.white
                  ? whiteKingPosition
                  : blackKingPosition,
              movement: Movement(
                  previousX: x,
                  previousY: y,
                  positionX: x + 1 * sign,
                  positionY: y + 1,
                  movementType: MovementType.normal,
                  isLegal: true),
            ),
          ),
        );
      }
    }
    // Left En-passant
    Movement? movement = sign < 0 ? previousBlackMove : previousWhiteMove;
    if (movement == null) return moves;

    if (y - 1 >= 0 &&
        boardMatrix[x + 1 * sign][y - 1] == null &&
        boardMatrix[x][y - 1] != null) {
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
            isLegal: moveIsLegal(
              board: boardMatrix,
              colorToMove: model.color,
              kingPosition: model.color == PieceColor.white
                  ? whiteKingPosition
                  : blackKingPosition,
              movement: Movement(
                  previousX: x,
                  previousY: y,
                  positionX: x + 1 * sign,
                  positionY: y - 1,
                  movementType: MovementType.enPassant,
                  isLegal: true),
            ),
          ),
        );
      }
    }
    // Right En-passant
    if (y + 1 < 8 &&
        boardMatrix[x + 1 * sign][y + 1] == null &&
        boardMatrix[x][y + 1] != null) {
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
            isLegal: moveIsLegal(
              board: boardMatrix,
              colorToMove: model.color,
              kingPosition: model.color == PieceColor.white
                  ? whiteKingPosition
                  : blackKingPosition,
              movement: Movement(
                  previousX: x,
                  previousY: y,
                  positionX: x + 1 * sign,
                  positionY: y + 1,
                  movementType: MovementType.enPassant,
                  isLegal: true),
            ),
          ),
        );
      }
    }
    return moves;
  }
}

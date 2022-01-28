part of 'calculate_legal_moves.dart';

enum _Direction {
  top,
  bottom,
  right,
  left,
  fromBLTTR,
  fromTLTBR,
  fromTRTBL,
  fromBRTTL
}

enum Coordinate { x, y }

List<Movement> _calculateLineMoves({
  required _Direction direction,
  required PieceModel model,
  required List<List<Piece?>> boardMatrix,
}) {
  List<Movement> moves = [];

  int x = model.piecePosition.positionX;
  int y = model.piecePosition.positionY;

  int i = _calcIndexForLines(direction, Coordinate.x, x);

  int j = _calcIndexForLines(direction, Coordinate.y, y);

  while (i >= 0 && i < 8 && j >= 0 && j < 8) {
    Piece? square = boardMatrix[i][j];
    Movement? move = _getMovement(model, square, x, y, i, j);
    if (move != null) {
      if (move.positionX == -1) break;
      moves.add(move);
    }

    i = _calcIndexForLines(direction, Coordinate.x, i);
    j = _calcIndexForLines(direction, Coordinate.y, j);
  }

  return moves;
}

int _calcIndexForLines(_Direction direction, Coordinate coordinate, int value) {
  if (direction == _Direction.top && coordinate == Coordinate.x) {
    return value - 1;
  }
  if (direction == _Direction.bottom && coordinate == Coordinate.x) {
    return value + 1;
  }
  if (direction == _Direction.right && coordinate == Coordinate.y) {
    return value + 1;
  }
  if (direction == _Direction.left && coordinate == Coordinate.y) {
    return value - 1;
  }

  if (direction == _Direction.fromBLTTR && coordinate == Coordinate.x) {
    return value - 1;
  }
  if (direction == _Direction.fromBLTTR && coordinate == Coordinate.y) {
    return value + 1;
  }

  if (direction == _Direction.fromBRTTL && coordinate == Coordinate.x) {
    return value - 1;
  }
  if (direction == _Direction.fromBRTTL && coordinate == Coordinate.y) {
    return value - 1;
  }

  if (direction == _Direction.fromTLTBR && coordinate == Coordinate.x) {
    return value + 1;
  }
  if (direction == _Direction.fromTLTBR && coordinate == Coordinate.y) {
    return value + 1;
  }

  if (direction == _Direction.fromTRTBL && coordinate == Coordinate.x) {
    return value + 1;
  }
  if (direction == _Direction.fromTRTBL && coordinate == Coordinate.y) {
    return value - 1;
  }

  return value;
}

List<Movement> _calculateJumpMoves({
  required _Direction direction,
  required PieceModel model,
  required List<List<Piece?>> boardMatrix,
}) {
  List<Movement> moves = [];

  List<int> result = _calcIndexForJump(
      direction, model.piecePosition.positionX, model.piecePosition.positionY);

  if (result[0] == 0) {
    int x = result[1];
    int y1 = result[2];
    int y2 = result[3];
    if (x >= 0 && x < 8) {
      if (y1 < 8 && y1 >= 0) {
        Piece? square1 = boardMatrix[x][y1];
        Movement? move1 = _getMovement(
            model,
            square1,
            model.piecePosition.positionX,
            model.piecePosition.positionY,
            x,
            y1);
        if (move1 != null) moves.add(move1);
      }
      if (y2 >= 0 && y2 < 8) {
        Piece? square2 = boardMatrix[x][y2];
        Movement? move2 = _getMovement(
            model,
            square2,
            model.piecePosition.positionX,
            model.piecePosition.positionY,
            x,
            y2);
        if (move2 != null) moves.add(move2);
      }
    }
  }
  if (result[0] == 1) {
    int y = result[1];
    int x1 = result[2];
    int x2 = result[3];
    if (y >= 0 && y < 8) {
      if (x1 < 8 && x1 >= 0) {
        Piece? square1 = boardMatrix[x1][y];
        Movement? move1 = _getMovement(
            model,
            square1,
            model.piecePosition.positionX,
            model.piecePosition.positionY,
            x1,
            y);
        if (move1 != null) moves.add(move1);
      }
      if (x2 >= 0 && x2 < 8) {
        Piece? square2 = boardMatrix[x2][y];
        Movement? move2 = _getMovement(
            model,
            square2,
            model.piecePosition.positionX,
            model.piecePosition.positionY,
            x2,
            y);

        if (move2 != null) moves.add(move2);
      }
    }
  }

  return moves;
}

/// return [c,x,y,z]
///
/// c : Vertical or horizontal (0, 1)
///
/// x : two units of progress relative to variable c
///
/// y : one units of progress relative to variable c
///
/// z : one units of progress relative to variable c
List<int> _calcIndexForJump(_Direction direction, int x, int y) {
  if (direction == _Direction.top) {
    return [0, x - 2, y + 1, y - 1];
  }
  if (direction == _Direction.bottom) {
    return [0, x + 2, y + 1, y - 1];
  }
  if (direction == _Direction.left) {
    return [1, y - 2, x - 1, x + 1];
  }
  if (direction == _Direction.right) {
    return [1, y + 2, x - 1, x + 1];
  }

  throw Exception("Invalid direction");
}

Movement? _getMovement(
    PieceModel model, Piece? square, int x, int y, int i, int j) {
  if (square != null && square.pieceModel.color == model.color) {
    // If there are piece of the same color in the square, it means that the line is closed.
    // (for line and diagonal moves)
    // Equivalent to returning null on jump moves
    return Movement(
        previousX: -1,
        previousY: -1,
        positionX: -1,
        positionY: -1,
        movementType: MovementType.normal,
        isLegal: false);
  } else if (square != null && square.pieceModel.color != model.color) {
    return Movement(
        previousX: x,
        previousY: y,
        positionX: i,
        positionY: j,
        movementType: MovementType.capture,
        // TODO: check if king is under attack
        isLegal: true);
  } else if (square == null) {
    return Movement(
        previousX: x,
        previousY: y,
        positionX: i,
        positionY: j,
        movementType: MovementType.normal,
        // TODO: check if king is under attack
        isLegal: true);
  }
  return null;
}

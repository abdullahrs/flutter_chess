part of 'calculate_movements.dart';

List<Movement> _calculateLineMoves({
  required Direction direction,
  required PieceModel model,
  required Board boardMatrix,
}) {
  List<Movement> moves = [];

  int x = model.piecePosition.positionX;
  int y = model.piecePosition.positionY;

  int i = calcIndexForLines(direction, Coordinate.x, x);

  int j = calcIndexForLines(direction, Coordinate.y, y);

  while (i >= 0 && i < 8 && j >= 0 && j < 8) {
    Piece? square = boardMatrix[i][j];
    Movement? move = _getMovement(model, square, x, y, i, j);
    if (move != null) {
      if (move.positionX == -1) break;
      moves.add(move);
      if (move.movementType == MovementType.capture) break;
    }

    i = calcIndexForLines(direction, Coordinate.x, i);
    j = calcIndexForLines(direction, Coordinate.y, j);
  }

  return moves;
}

List<Movement> _calculateJumpMoves({
  required Direction direction,
  required PieceModel model,
  required Board boardMatrix,
}) {
  List<Movement> moves = [];

  List<int> result = calcIndexForJump(
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

Movement? _getMovement(
    PieceModel model, Piece? square, int x, int y, int i, int j,
    {MovementType? type}) {
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
      isLegal: PieceMovementCalculator.instance.moveIsLegal(
        board: PieceMovementCalculator.instance.boardMatrix,
        colorToMove: model.color,
        kingPosition: model.color == PieceColor.white
            ? PieceMovementCalculator.instance.whiteKingPosition
            : PieceMovementCalculator.instance.blackKingPosition,
        movement: Movement(
            previousX: x,
            previousY: y,
            positionX: i,
            positionY: j,
            movementType: MovementType.capture,
            isLegal: true),
      ),
    );
  } else if (square == null) {
    return Movement(
      previousX: x,
      previousY: y,
      positionX: i,
      positionY: j,
      movementType: type ?? MovementType.normal,
      isLegal: PieceMovementCalculator.instance.moveIsLegal(
        board: PieceMovementCalculator.instance.boardMatrix,
        colorToMove: model.color,
        kingPosition: model.color == PieceColor.white
            ? PieceMovementCalculator.instance.whiteKingPosition
            : PieceMovementCalculator.instance.blackKingPosition,
        movement: Movement(
            previousX: x,
            previousY: y,
            positionX: i,
            positionY: j,
            movementType: type ?? MovementType.normal,
            isLegal: true),
      ),
    );
  }
  return null;
}


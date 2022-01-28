import '../constants/directions.dart';

int calcIndexForLines(Direction direction, Coordinate coordinate, int value) {
  if (direction == Direction.top && coordinate == Coordinate.x) {
    return value - 1;
  }
  if (direction == Direction.bottom && coordinate == Coordinate.x) {
    return value + 1;
  }
  if (direction == Direction.right && coordinate == Coordinate.y) {
    return value + 1;
  }
  if (direction == Direction.left && coordinate == Coordinate.y) {
    return value - 1;
  }

  if (direction == Direction.fromBLTTR && coordinate == Coordinate.x) {
    return value - 1;
  }
  if (direction == Direction.fromBLTTR && coordinate == Coordinate.y) {
    return value + 1;
  }

  if (direction == Direction.fromBRTTL && coordinate == Coordinate.x) {
    return value - 1;
  }
  if (direction == Direction.fromBRTTL && coordinate == Coordinate.y) {
    return value - 1;
  }

  if (direction == Direction.fromTLTBR && coordinate == Coordinate.x) {
    return value + 1;
  }
  if (direction == Direction.fromTLTBR && coordinate == Coordinate.y) {
    return value + 1;
  }

  if (direction == Direction.fromTRTBL && coordinate == Coordinate.x) {
    return value + 1;
  }
  if (direction == Direction.fromTRTBL && coordinate == Coordinate.y) {
    return value - 1;
  }

  return value;
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
List<int> calcIndexForJump(Direction direction, int x, int y) {
  if (direction == Direction.top) {
    return [0, x - 2, y + 1, y - 1];
  }
  if (direction == Direction.bottom) {
    return [0, x + 2, y + 1, y - 1];
  }
  if (direction == Direction.left) {
    return [1, y - 2, x - 1, x + 1];
  }
  if (direction == Direction.right) {
    return [1, y + 2, x - 1, x + 1];
  }

  throw Exception("Invalid direction");
}

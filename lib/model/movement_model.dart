import '../constants/movement_types.dart';

class Movement {
  final int previousX;
  final int previousY;

  final int positionX;
  final int positionY;

  final MovementType movementType;

  final bool isLegal;

  Movement({
    required this.previousX,
    required this.previousY,
    required this.positionX,
    required this.positionY,
    required this.movementType,
    required this.isLegal,
  });
}

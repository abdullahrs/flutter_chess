class PiecePosition {
  final int positionY;
  final int positionX;

  const PiecePosition(
    this.positionX,
    this.positionY,
  );

  PiecePosition copyWith({
    int? positionY,
    int? positionX,
  }) {
    return PiecePosition(
      positionY ?? this.positionY,
      positionX ?? this.positionX,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PiecePosition &&
        other.positionY == positionY &&
        other.positionX == positionX;
  }

  @override
  int get hashCode => positionY.hashCode ^ positionX.hashCode;
}

class NullPiecePosition extends PiecePosition {
  NullPiecePosition() : super(-1, -1);
}

enum Pieces { pawn, rook, knight, bishop, queen, king }


extension PiecesExtension on Pieces{
  /// returns piece ICCF Numeric notation
  String get iccfNotation {
    Map<Pieces, String> conversionMap = {
      Pieces.king: "K",
      Pieces.queen: "Q",
      Pieces.rook: "R",
      Pieces.bishop: "B",
      Pieces.knight: "N",
      Pieces.pawn: "P",
    };
    return conversionMap[this]!;
  }
}

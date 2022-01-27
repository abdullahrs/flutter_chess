import '../constants/piece_colors.dart';
import '../constants/pieces.dart';
import 'piece_position_model.dart';

class PieceModel {
  final Pieces piece;
  final PieceColor color;
  final PiecePosition piecePosition;
  const PieceModel(
      {required this.piece, required this.color, required this.piecePosition});

  PieceModel copyWith(
      {Pieces? piece,
      PieceColor? color,
      PiecePosition? piecePosition}) {
    return PieceModel(
        piece: piece ?? this.piece,
        color: color ?? this.color,
        piecePosition: piecePosition ?? this.piecePosition);
  }

  String get imagePath {
    switch (piece) {
      case Pieces.king:
        return color == PieceColor.white
            ? "assets/white_king.png"
            : "assets/black_king.png";
      case Pieces.queen:
        return color == PieceColor.white
            ? "assets/white_queen.png"
            : "assets/black_queen.png";
      case Pieces.castle:
        return color == PieceColor.white
            ? "assets/white_castle.png"
            : "assets/black_castle.png";
      case Pieces.bishop:
        return color == PieceColor.white
            ? "assets/white_bishop.png"
            : "assets/black_bishop.png";
      case Pieces.knight:
        return color == PieceColor.white
            ? "assets/white_knight.png"
            : "assets/black_knight.png";
      case Pieces.pawn:
        return color == PieceColor.white
            ? "assets/white_pawn.png"
            : "assets/black_pawn.png";
      default:
        return color == PieceColor.white
            ? "assets/white_pawn.png"
            : "assets/black_pawn.png";
    }
  }
}

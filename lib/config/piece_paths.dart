import 'package:flutter_chess/config/pieces.dart';

const Map<Pieces, Map<PieceColor, String>> piecePathMap = {
  Pieces.Pawn: {
    PieceColor.Black: "assets/black_pawn.png",
    PieceColor.White: "assets/white_pawn.png"
  },
  Pieces.Castle: {
    PieceColor.Black: "assets/black_castle.png",
    PieceColor.White: "assets/white_castle.png"
  },
  Pieces.Knight: {
    PieceColor.Black: "assets/black_knight.png",
    PieceColor.White: "assets/white_knight.png"
  },
  Pieces.Bishop: {
    PieceColor.Black: "assets/black_bishop.png",
    PieceColor.White: "assets/white_bishop.png"
  },
  Pieces.Queen: {
    PieceColor.Black: "assets/black_queen.png",
    PieceColor.White: "assets/white_queen.png"
  },
  Pieces.King: {
    PieceColor.Black: "assets/black_king.png",
    PieceColor.White: "assets/white_king.png"
  },
};

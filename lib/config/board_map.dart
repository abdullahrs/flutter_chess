import 'package:flutter_chess/config/pieces.dart';
import 'package:flutter_chess/model/piece_model.dart';

List<List<dynamic?>> boardMatrix = [
  [
    PieceModel(
        Pieces.Castle, PieceColor.Black, "assets/black_castle.png", 0, 0),
    PieceModel(
        Pieces.Knight, PieceColor.Black, "assets/black_knight.png", 0, 1),
    PieceModel(
        Pieces.Bishop, PieceColor.Black, "assets/black_bishop.png", 0, 2),
    PieceModel(Pieces.Queen, PieceColor.Black, "assets/black_queen.png", 0, 3),
    PieceModel(Pieces.King, PieceColor.Black, "assets/black_king.png", 0, 4),
    PieceModel(
        Pieces.Bishop, PieceColor.Black, "assets/black_bishop.png", 0, 5),
    PieceModel(
        Pieces.Knight, PieceColor.Black, "assets/black_knight.png", 0, 6),
    PieceModel(
        Pieces.Castle, PieceColor.Black, "assets/black_castle.png", 0, 7),
  ],
  [
    PieceModel(Pieces.Pawn, PieceColor.Black, "assets/black_pawn.png", 1, 0),
    PieceModel(Pieces.Pawn, PieceColor.Black, "assets/black_pawn.png", 1, 1),
    PieceModel(Pieces.Pawn, PieceColor.Black, "assets/black_pawn.png", 1, 2),
    PieceModel(Pieces.Pawn, PieceColor.Black, "assets/black_pawn.png", 1, 3),
    PieceModel(Pieces.Pawn, PieceColor.Black, "assets/black_pawn.png", 1, 4),
    PieceModel(Pieces.Pawn, PieceColor.Black, "assets/black_pawn.png", 1, 5),
    PieceModel(Pieces.Pawn, PieceColor.Black, "assets/black_pawn.png", 1, 6),
    PieceModel(Pieces.Pawn, PieceColor.Black, "assets/black_pawn.png", 1, 7),
  ],
  [null, null, null, null, null, null, null, null],
  [null, null, null, null, null, null, null, null],
  [null, null, null, null, null, null, null, null],
  [null, null, null, null, null, null, null, null],
  [
    PieceModel(Pieces.Pawn, PieceColor.White, "assets/white_pawn.png", 6, 0),
    PieceModel(Pieces.Pawn, PieceColor.White, "assets/white_pawn.png", 6, 1),
    PieceModel(Pieces.Pawn, PieceColor.White, "assets/white_pawn.png", 6, 2),
    PieceModel(Pieces.Pawn, PieceColor.White, "assets/white_pawn.png", 6, 3),
    PieceModel(Pieces.Pawn, PieceColor.White, "assets/white_pawn.png", 6, 4),
    PieceModel(Pieces.Pawn, PieceColor.White, "assets/white_pawn.png", 6, 5),
    PieceModel(Pieces.Pawn, PieceColor.White, "assets/white_pawn.png", 6, 6),
    PieceModel(Pieces.Pawn, PieceColor.White, "assets/white_pawn.png", 6, 7),
  ],
  [
    PieceModel(
        Pieces.Castle, PieceColor.White, "assets/white_castle.png", 7, 0),
    PieceModel(
        Pieces.Knight, PieceColor.White, "assets/white_knight.png", 7, 1),
    PieceModel(
        Pieces.Bishop, PieceColor.White, "assets/white_bishop.png", 7, 2),
    PieceModel(Pieces.Queen, PieceColor.White, "assets/white_queen.png", 7, 3),
    PieceModel(Pieces.King, PieceColor.White, "assets/white_king.png", 7, 4),
    PieceModel(
        Pieces.Bishop, PieceColor.White, "assets/white_bishop.png", 7, 5),
    PieceModel(
        Pieces.Knight, PieceColor.White, "assets/white_knight.png", 7, 6),
    PieceModel(
        Pieces.Castle, PieceColor.White, "assets/white_castle.png", 7, 7),
  ],
];

import 'package:flutter_chess/config/piece_paths.dart';
import 'package:flutter_chess/config/pieces.dart';
import 'package:flutter_chess/model/piece_model.dart';

List<List<dynamic?>> boardMatrix = [
  [
    PieceModel(Pieces.Castle, PieceColor.Black,
        piecePathMap[Pieces.Castle]![PieceColor.Black]!, 0, 0),
    PieceModel(Pieces.Knight, PieceColor.Black,
        piecePathMap[Pieces.Knight]![PieceColor.Black]!, 0, 1),
    PieceModel(Pieces.Bishop, PieceColor.Black,
        piecePathMap[Pieces.Bishop]![PieceColor.Black]!, 0, 2),
    PieceModel(Pieces.Queen, PieceColor.Black,
        piecePathMap[Pieces.Queen]![PieceColor.Black]!, 0, 3),
    PieceModel(Pieces.King, PieceColor.Black,
        piecePathMap[Pieces.King]![PieceColor.Black]!, 0, 4),
    PieceModel(Pieces.Bishop, PieceColor.Black,
        piecePathMap[Pieces.Bishop]![PieceColor.Black]!, 0, 5),
    PieceModel(Pieces.Knight, PieceColor.Black,
        piecePathMap[Pieces.Knight]![PieceColor.Black]!, 0, 6),
    PieceModel(Pieces.Castle, PieceColor.Black,
        piecePathMap[Pieces.Castle]![PieceColor.Black]!, 0, 7),
  ],
  [
    PieceModel(Pieces.Pawn, PieceColor.Black,
        piecePathMap[Pieces.Pawn]![PieceColor.Black]!, 1, 0),
    PieceModel(Pieces.Pawn, PieceColor.Black,
        piecePathMap[Pieces.Pawn]![PieceColor.Black]!, 1, 1),
    PieceModel(Pieces.Pawn, PieceColor.Black,
        piecePathMap[Pieces.Pawn]![PieceColor.Black]!, 1, 2),
    PieceModel(Pieces.Pawn, PieceColor.Black,
        piecePathMap[Pieces.Pawn]![PieceColor.Black]!, 1, 3),
    PieceModel(Pieces.Pawn, PieceColor.Black,
        piecePathMap[Pieces.Pawn]![PieceColor.Black]!, 1, 4),
    PieceModel(Pieces.Pawn, PieceColor.Black,
        piecePathMap[Pieces.Pawn]![PieceColor.Black]!, 1, 5),
    PieceModel(Pieces.Pawn, PieceColor.Black,
        piecePathMap[Pieces.Pawn]![PieceColor.Black]!, 1, 6),
    PieceModel(Pieces.Pawn, PieceColor.Black,
        piecePathMap[Pieces.Pawn]![PieceColor.Black]!, 1, 7),
  ],
  [null, null, null, null, null, null, null, null],
  [null, null, null, null, null, null, null, null],
  [null, null, null, null, null, null, null, null],
  [null, null, null, null, null, null, null, null],
  [
    PieceModel(Pieces.Pawn, PieceColor.White,
        piecePathMap[Pieces.Pawn]![PieceColor.White]!, 6, 0),
    PieceModel(Pieces.Pawn, PieceColor.White,
        piecePathMap[Pieces.Pawn]![PieceColor.White]!, 6, 1),
    PieceModel(Pieces.Pawn, PieceColor.White,
        piecePathMap[Pieces.Pawn]![PieceColor.White]!, 6, 2),
    PieceModel(Pieces.Pawn, PieceColor.White,
        piecePathMap[Pieces.Pawn]![PieceColor.White]!, 6, 3),
    PieceModel(Pieces.Pawn, PieceColor.White,
        piecePathMap[Pieces.Pawn]![PieceColor.White]!, 6, 4),
    PieceModel(Pieces.Pawn, PieceColor.White,
        piecePathMap[Pieces.Pawn]![PieceColor.White]!, 6, 5),
    PieceModel(Pieces.Pawn, PieceColor.White,
        piecePathMap[Pieces.Pawn]![PieceColor.White]!, 6, 6),
    PieceModel(Pieces.Pawn, PieceColor.White,
        piecePathMap[Pieces.Pawn]![PieceColor.White]!, 6, 7),
  ],
  [
    PieceModel(Pieces.Castle, PieceColor.White,
        piecePathMap[Pieces.Castle]![PieceColor.White]!, 7, 0),
    PieceModel(Pieces.Knight, PieceColor.White,
        piecePathMap[Pieces.Knight]![PieceColor.White]!, 7, 1),
    PieceModel(Pieces.Bishop, PieceColor.White,
        piecePathMap[Pieces.Bishop]![PieceColor.White]!, 7, 2),
    PieceModel(Pieces.Queen, PieceColor.White,
        piecePathMap[Pieces.Queen]![PieceColor.White]!, 7, 3),
    PieceModel(Pieces.King, PieceColor.White,
        piecePathMap[Pieces.King]![PieceColor.White]!, 7, 4),
    PieceModel(Pieces.Bishop, PieceColor.White,
        piecePathMap[Pieces.Bishop]![PieceColor.White]!, 7, 5),
    PieceModel(Pieces.Knight, PieceColor.White,
        piecePathMap[Pieces.Knight]![PieceColor.White]!, 7, 6),
    PieceModel(Pieces.Castle, PieceColor.White,
        piecePathMap[Pieces.Castle]![PieceColor.White]!, 7, 7),
  ],
];

final List<List<dynamic?>> matrix = [
  [
    PieceModel(Pieces.Castle, PieceColor.Black,
        piecePathMap[Pieces.Castle]![PieceColor.Black]!, 0, 0),
    PieceModel(Pieces.Knight, PieceColor.Black,
        piecePathMap[Pieces.Knight]![PieceColor.Black]!, 0, 1),
    PieceModel(Pieces.Bishop, PieceColor.Black,
        piecePathMap[Pieces.Bishop]![PieceColor.Black]!, 0, 2),
    PieceModel(Pieces.Queen, PieceColor.Black,
        piecePathMap[Pieces.Queen]![PieceColor.Black]!, 0, 3),
    PieceModel(Pieces.King, PieceColor.Black,
        piecePathMap[Pieces.King]![PieceColor.Black]!, 0, 4),
    PieceModel(Pieces.Bishop, PieceColor.Black,
        piecePathMap[Pieces.Bishop]![PieceColor.Black]!, 0, 5),
    PieceModel(Pieces.Knight, PieceColor.Black,
        piecePathMap[Pieces.Knight]![PieceColor.Black]!, 0, 6),
    PieceModel(Pieces.Castle, PieceColor.Black,
        piecePathMap[Pieces.Castle]![PieceColor.Black]!, 0, 7),
  ],
  [
    PieceModel(Pieces.Pawn, PieceColor.Black,
        piecePathMap[Pieces.Pawn]![PieceColor.Black]!, 1, 0),
    PieceModel(Pieces.Pawn, PieceColor.Black,
        piecePathMap[Pieces.Pawn]![PieceColor.Black]!, 1, 1),
    PieceModel(Pieces.Pawn, PieceColor.Black,
        piecePathMap[Pieces.Pawn]![PieceColor.Black]!, 1, 2),
    PieceModel(Pieces.Pawn, PieceColor.Black,
        piecePathMap[Pieces.Pawn]![PieceColor.Black]!, 1, 3),
    PieceModel(Pieces.Pawn, PieceColor.Black,
        piecePathMap[Pieces.Pawn]![PieceColor.Black]!, 1, 4),
    PieceModel(Pieces.Pawn, PieceColor.Black,
        piecePathMap[Pieces.Pawn]![PieceColor.Black]!, 1, 5),
    PieceModel(Pieces.Pawn, PieceColor.Black,
        piecePathMap[Pieces.Pawn]![PieceColor.Black]!, 1, 6),
    PieceModel(Pieces.Pawn, PieceColor.Black,
        piecePathMap[Pieces.Pawn]![PieceColor.Black]!, 1, 7),
  ],
  [null, null, null, null, null, null, null, null],
  [null, null, null, null, null, null, null, null],
  [null, null, null, null, null, null, null, null],
  [null, null, null, null, null, null, null, null],
  [
    PieceModel(Pieces.Pawn, PieceColor.White,
        piecePathMap[Pieces.Pawn]![PieceColor.White]!, 6, 0),
    PieceModel(Pieces.Pawn, PieceColor.White,
        piecePathMap[Pieces.Pawn]![PieceColor.White]!, 6, 1),
    PieceModel(Pieces.Pawn, PieceColor.White,
        piecePathMap[Pieces.Pawn]![PieceColor.White]!, 6, 2),
    PieceModel(Pieces.Pawn, PieceColor.White,
        piecePathMap[Pieces.Pawn]![PieceColor.White]!, 6, 3),
    PieceModel(Pieces.Pawn, PieceColor.White,
        piecePathMap[Pieces.Pawn]![PieceColor.White]!, 6, 4),
    PieceModel(Pieces.Pawn, PieceColor.White,
        piecePathMap[Pieces.Pawn]![PieceColor.White]!, 6, 5),
    PieceModel(Pieces.Pawn, PieceColor.White,
        piecePathMap[Pieces.Pawn]![PieceColor.White]!, 6, 6),
    PieceModel(Pieces.Pawn, PieceColor.White,
        piecePathMap[Pieces.Pawn]![PieceColor.White]!, 6, 7),
  ],
  [
    PieceModel(Pieces.Castle, PieceColor.White,
        piecePathMap[Pieces.Castle]![PieceColor.White]!, 7, 0),
    PieceModel(Pieces.Knight, PieceColor.White,
        piecePathMap[Pieces.Knight]![PieceColor.White]!, 7, 1),
    PieceModel(Pieces.Bishop, PieceColor.White,
        piecePathMap[Pieces.Bishop]![PieceColor.White]!, 7, 2),
    PieceModel(Pieces.Queen, PieceColor.White,
        piecePathMap[Pieces.Queen]![PieceColor.White]!, 7, 3),
    PieceModel(Pieces.King, PieceColor.White,
        piecePathMap[Pieces.King]![PieceColor.White]!, 7, 4),
    PieceModel(Pieces.Bishop, PieceColor.White,
        piecePathMap[Pieces.Bishop]![PieceColor.White]!, 7, 5),
    PieceModel(Pieces.Knight, PieceColor.White,
        piecePathMap[Pieces.Knight]![PieceColor.White]!, 7, 6),
    PieceModel(Pieces.Castle, PieceColor.White,
        piecePathMap[Pieces.Castle]![PieceColor.White]!, 7, 7),
  ],
];

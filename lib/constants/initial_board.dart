import '../model/piece_position_model.dart';

import 'piece_colors.dart';
import '../model/piece_model.dart';

import '../components/board/piece.dart';
import 'pieces.dart';

/// Black pieces
const Piece _blackCastle = Piece(
  pieceModel: PieceModel(
    piece: Pieces.castle,
    color: PieceColor.black,
    piecePosition: PiecePosition(0, 0),
    moved: false,
  ),
);
const Piece _blackKnight = Piece(
  pieceModel: PieceModel(
    piece: Pieces.knight,
    color: PieceColor.black,
    piecePosition: PiecePosition(0, 1),
    moved: false,
  ),
);
const Piece _blackBishop = Piece(
  pieceModel: PieceModel(
    piece: Pieces.bishop,
    color: PieceColor.black,
    piecePosition: PiecePosition(0, 2),
    moved: false,
  ),
);
const Piece _blackQuenn = Piece(
    pieceModel: PieceModel(
  piece: Pieces.queen,
  color: PieceColor.black,
  piecePosition: PiecePosition(0, 3),
  moved: false,
));
const Piece _blackKing = Piece(
    pieceModel: PieceModel(
  piece: Pieces.king,
  color: PieceColor.black,
  piecePosition: PiecePosition(0, 4),
  moved: false,
));
const Piece _blackPawn = Piece(
    pieceModel: PieceModel(
  piece: Pieces.pawn,
  color: PieceColor.black,
  piecePosition: PiecePosition(1, 0),
  moved: false,
));

/// White pieces
const Piece _whiteCastle = Piece(
    pieceModel: PieceModel(
  piece: Pieces.castle,
  color: PieceColor.white,
  piecePosition: PiecePosition(7, 0),
  moved: false,
));
const Piece _whiteKnight = Piece(
    pieceModel: PieceModel(
  piece: Pieces.knight,
  color: PieceColor.white,
  piecePosition: PiecePosition(7, 1),
  moved: false,
));
const Piece _whiteBishop = Piece(
    pieceModel: PieceModel(
  piece: Pieces.bishop,
  color: PieceColor.white,
  piecePosition: PiecePosition(7, 2),
  moved: false,
));
const Piece _whiteQuenn = Piece(
    pieceModel: PieceModel(
  piece: Pieces.queen,
  color: PieceColor.white,
  piecePosition: PiecePosition(7, 3),
  moved: false,
));
const Piece _whiteKing = Piece(
    pieceModel: PieceModel(
  piece: Pieces.king,
  color: PieceColor.white,
  piecePosition: PiecePosition(7, 4),
  moved: false,
));
const Piece _whitePawn = Piece(
    pieceModel: PieceModel(
  piece: Pieces.pawn,
  color: PieceColor.white,
  piecePosition: PiecePosition(6, 0),
  moved: false,
));

final List<List<Piece?>> kInitialBoard = [
  [
    _blackCastle,
    _blackKnight,
    _blackBishop,
    _blackQuenn,
    _blackKing,
    Piece(
        pieceModel: _blackBishop.pieceModel
            .copyWith(piecePosition: const PiecePosition(0, 5))),
    Piece(
        pieceModel: _blackKnight.pieceModel
            .copyWith(piecePosition: const PiecePosition(0, 6))),
    Piece(
        pieceModel: _blackCastle.pieceModel
            .copyWith(piecePosition: const PiecePosition(0, 7))),
  ],
  [
    _blackPawn,
    Piece(
        pieceModel: _blackPawn.pieceModel
            .copyWith(piecePosition: const PiecePosition(1, 1))),
    Piece(
        pieceModel: _blackPawn.pieceModel
            .copyWith(piecePosition: const PiecePosition(1, 2))),
    Piece(
        pieceModel: _blackPawn.pieceModel
            .copyWith(piecePosition: const PiecePosition(1, 3))),
    Piece(
        pieceModel: _blackPawn.pieceModel
            .copyWith(piecePosition: const PiecePosition(1, 4))),
    Piece(
        pieceModel: _blackPawn.pieceModel
            .copyWith(piecePosition: const PiecePosition(1, 5))),
    Piece(
        pieceModel: _blackPawn.pieceModel
            .copyWith(piecePosition: const PiecePosition(1, 6))),
    Piece(
        pieceModel: _blackPawn.pieceModel
            .copyWith(piecePosition: const PiecePosition(1, 7))),
  ],
  [
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
  ],
  [
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
  ],
  [
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
  ],
  [
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
  ],
  [
    _whitePawn,
    Piece(
        pieceModel: _whitePawn.pieceModel
            .copyWith(piecePosition: const PiecePosition(6, 1))),
    Piece(
        pieceModel: _whitePawn.pieceModel
            .copyWith(piecePosition: const PiecePosition(6, 2))),
    Piece(
        pieceModel: _whitePawn.pieceModel
            .copyWith(piecePosition: const PiecePosition(6, 3))),
    Piece(
        pieceModel: _whitePawn.pieceModel
            .copyWith(piecePosition: const PiecePosition(6, 4))),
    Piece(
        pieceModel: _whitePawn.pieceModel
            .copyWith(piecePosition: const PiecePosition(6, 5))),
    Piece(
        pieceModel: _whitePawn.pieceModel
            .copyWith(piecePosition: const PiecePosition(6, 6))),
    Piece(
        pieceModel: _whitePawn.pieceModel
            .copyWith(piecePosition: const PiecePosition(6, 7))),
  ],
  [
    _whiteCastle,
    _whiteKnight,
    _whiteBishop,
    _whiteQuenn,
    _whiteKing,
    Piece(
        pieceModel: _whiteBishop.pieceModel
            .copyWith(piecePosition: const PiecePosition(7, 5))),
    Piece(
        pieceModel: _whiteKnight.pieceModel
            .copyWith(piecePosition: const PiecePosition(7, 6))),
    Piece(
        pieceModel: _whiteCastle.pieceModel
            .copyWith(piecePosition: const PiecePosition(7, 7))),
  ],
];

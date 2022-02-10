import '../components/board/piece.dart';
import '../constants/game_statuses.dart';
import '../constants/initial_board.dart';
import '../constants/board_defination.dart';
import '../constants/piece_colors.dart';
import 'movement_model.dart';

import 'piece_position_model.dart';

class BoardModel {
  final Board board;
  final Movement? lastWhiteMove;
  final Movement? lastBlackMove;
  final PieceColor colorToMove;
  final PiecePosition? selectedSquare;
  final List<Movement> availableMoves;
  final PiecePosition whiteKingPosition;
  final PiecePosition blackKingPosition;
  final GameStatus gameStatus;

  BoardModel({
    required this.board,
    this.lastBlackMove,
    this.lastWhiteMove,
    this.colorToMove = PieceColor.white,
    this.selectedSquare,
    this.availableMoves = const <Movement>[],
    this.whiteKingPosition = const PiecePosition(7, 4),
    this.blackKingPosition = const PiecePosition(0, 4),
    this.gameStatus = GameStatus.continues,
  });

  BoardModel copyWith({
    Board? board,
    Movement? lastBlackMove,
    Movement? lastWhiteMove,
    PieceColor? colorToMove,
    PiecePosition? selectedSquare,
    List<Movement>? availableMoves,
    PiecePosition? whiteKingPosition,
    PiecePosition? blackKingPosition,
    GameStatus? gameStatus,
  }) {
    return BoardModel(
        board: board ?? this.board,
        lastWhiteMove: lastWhiteMove ?? this.lastWhiteMove,
        lastBlackMove: lastBlackMove ?? this.lastBlackMove,
        colorToMove: colorToMove ?? this.colorToMove,
        selectedSquare:
            selectedSquare is NullPiecePosition ? null : selectedSquare,
        availableMoves: availableMoves ?? this.availableMoves,
        whiteKingPosition: whiteKingPosition ?? this.whiteKingPosition,
        blackKingPosition: blackKingPosition ?? this.blackKingPosition,
        gameStatus: gameStatus ?? this.gameStatus);
  }

  BoardModel get initialModel {
    return BoardModel(
        board: kInitialBoard
            .map((List<Piece?> e) => List<Piece?>.from(e))
            .toList(),
        lastWhiteMove: null,
        lastBlackMove: null,
        colorToMove: PieceColor.white,
        selectedSquare: null,
        availableMoves: const <Movement>[],
        whiteKingPosition: const PiecePosition(7, 4),
        blackKingPosition: const PiecePosition(0, 4),
        gameStatus: GameStatus.continues);
  }
}

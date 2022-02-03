import '../constants/piece_colors.dart';
import 'calculate_movements.dart';

import '../constants/board_defination.dart';
import '../model/piece_position_model.dart';

import '../constants/game_statuses.dart';

class CalculateGameStatuses {
  static final CalculateGameStatuses instance = CalculateGameStatuses._();
  CalculateGameStatuses._();

  late Board boardMatrix;
  late PiecePosition whiteKingPosition;
  late PiecePosition blackKingPosition;

  static List<String> _moves = [];

  List<String> get moves => _moves;

  static int _fiftyMoveCounter = 0;

  void updatePlayedMoves(String str) {
    _moves.add(str);
  }

  void updateMoveCounter(bool reset) {
    if (reset) {
      _fiftyMoveCounter = 0;
    } else {
      _fiftyMoveCounter++;
    }
  }

  bool playableMoves = true;
  late PieceColor moveColor;

  GameStatus calculateGameStatus(
      {required Board board,
      required PiecePosition whiteKingPos,
      required PiecePosition blackKingPos,
      required bool checkAllMoves,
      required PieceColor colorToMove}) {
    boardMatrix = board;
    whiteKingPosition = whiteKingPos;
    blackKingPosition = blackKingPos;
    playableMoves = checkAllMoves;
    moveColor = colorToMove;

    bool checkMate = _checkMate();
    if (checkMate) return GameStatus.checkMate;
    bool repetition = _drawByRepetition();
    if (repetition) return GameStatus.drawByRepetition;
    bool insufficient = _drawByInsufficientMaterial();
    if (insufficient) return GameStatus.drawByInsufficientMaterial;
    bool fifty = _drawByFiftyMoveRule();
    if (fifty) return GameStatus.drawByFiftyMoveRule;
    bool stalemate = _drawByStalemate();
    if (stalemate) return GameStatus.drawByStalemate;
    return GameStatus.continues;
  }

  bool _checkMate() {
    bool kingIsSafe = PieceMovementCalculator.instance.kingIsSafe(
        board: boardMatrix,
        kingPosition: moveColor == PieceColor.white
            ? blackKingPosition
            : whiteKingPosition,
        kingColor: moveColor);
    return !kingIsSafe && !playableMoves;
  }

  bool _drawByRepetition() {
    return _moves
            .where((element) => element == boardMatrix.boardStateToString())
            .toList()
            .length >=
        3;
  }

  bool _drawByInsufficientMaterial() {
    String boardState = boardMatrix.boardStateToString();
    Map<String, int> pieceCounts = {
      'K': 'K'.allMatches(boardState).length,
      'Q': 'Q'.allMatches(boardState).length,
      'R': 'R'.allMatches(boardState).length,
      'B': 'B'.allMatches(boardState).length,
      'N': 'N'.allMatches(boardState).length,
      'P': 'P'.allMatches(boardState).length,
    };

    /// Lone king situation
    int sum = 0;
    pieceCounts.forEach((key, value) {
      if (key != 'K') sum += value;
    });
    // Except kings there is no piece left on the board
    if (sum == 0) return true;

    /// A king and bishop
    int whiteBishopCount = 0;
    int blackBishopCount = 0;

    pieceCounts.forEach((key, value) {
      if (key.contains('wB')) whiteBishopCount++;
      if (key.contains('bB')) blackBishopCount++;
    });
    // Except for the two kings, each side may either have an bishop,
    // or one of the players may have an bishop and the other may not.
    if ((whiteBishopCount == 1 && blackBishopCount < 2) ||
        (blackBishopCount == 1 && whiteBishopCount < 2)) return true;

    /// A king and knight
    int whiteKnightCount = 0;
    int blackKnightCount = 0;

    pieceCounts.forEach((key, value) {
      if (key.contains('wB')) whiteKnightCount++;
      if (key.contains('bB')) blackKnightCount++;
    });
    // Except for the two kings, each side may either have an bishop,
    // or one of the players may have an bishop and the other may not.
    if ((whiteKnightCount == 1 && blackKnightCount < 2) ||
        (blackKnightCount == 1 && whiteKnightCount < 2)) return true;

    // One side can have one bishop and opposite side have knight or reverse
    if ((whiteKnightCount == 1 && blackBishopCount == 1) ||
        (blackKnightCount == 1 && whiteBishopCount == 1)) return true;
    return false;
  }

  bool _drawByFiftyMoveRule() {
    return _fiftyMoveCounter == 50;
  }

  bool _drawByStalemate() {
    bool kingIsSafe = PieceMovementCalculator.instance.kingIsSafe(
        board: boardMatrix,
        kingPosition: moveColor == PieceColor.white
            ? whiteKingPosition
            : blackKingPosition,
        kingColor: moveColor);
    return kingIsSafe && !playableMoves;
  }
}

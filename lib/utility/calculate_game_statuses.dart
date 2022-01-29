import '../constants/board_defination.dart';
import '../model/piece_position_model.dart';

import '../constants/game_statuses.dart';

class CalculateGameStatuses {
  static final CalculateGameStatuses instance = CalculateGameStatuses._();
  CalculateGameStatuses._();

  late Board board;
  late PiecePosition whiteKingPosition;
  late PiecePosition blackKingPosition;

  static List<String> _moves = [];

  void updatePlayedMoves(String str) {
    _moves.add(str);
  }

  GameStatus calculateGameStatus(
      {required Board board,
      required PiecePosition whiteKingPos,
      required PiecePosition blackKingPos}) {
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
    return false;
  }

  bool _drawByRepetition() {
    return _moves
            .where((element) => element == board.boardStateToString())
            .toList()
            .length >=
        3;
  }

  bool _drawByInsufficientMaterial() {
    String boardState = board.boardStateToString();
    Map<String, int> pieceCounts = {
      'K': 'K'.allMatches(boardState).length,
      'Q': 'Q'.allMatches(boardState).length,
      'R': 'R'.allMatches(boardState).length,
      'B': 'B'.allMatches(boardState).length,
      'N': 'N'.allMatches(boardState).length,
      'P': 'P'.allMatches(boardState).length,
    };
    // Lone king situation
    int sum = 0;
    pieceCounts.forEach((key, value) {
      if(key != 'K') sum += value;
    });
    if(sum == 0) return true;

    
    return false;
  }

  bool _drawByFiftyMoveRule() {
    return false;
  }

  bool _drawByStalemate() {
    return false;
  }
}

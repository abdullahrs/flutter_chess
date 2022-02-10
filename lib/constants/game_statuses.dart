enum GameStatus {
  /// Before duration selection
  initial,

  /// After duration selection
  continues,

  /// When a king is attacked, it is called check.
  /// A checkmate occurs *when a king is placed in check and
  /// has no legal moves to escape*. When a checkmate happens,
  /// the game ends immediately, and the player who delivered the checkmate wins.
  checkMate,

  /// When one player resign other player wins
  resign,

  /// if a position arises three times in a game, either player can claim a draw
  /// during that position.
  /// the repeated positions do not need to be in a row.
  /// *The three positions can happen at any point in the game.*
  /// If a position is repeated three times, no matter where in the game,
  /// on the third time it will be declared a draw.
  /// It doesn't matter that there are other moves in between,
  /// what matters is that this exact position happened three times.
  /// On the third time it is declared a draw.
  drawByRepetition,

  /// When one player offers the other a draw, the other player accepts.
  drawByAgreement,

  /// If both sides have any one of the following, and there are no pawns on the board:
  ///
  /// - A lone king
  ///
  /// - A king and bishop
  ///
  /// - A king and knight
  ///
  /// In the above scenarios the game will end in a draw,
  drawByInsufficientMaterial,

  /// if both players make 50 moves without captures or pawn moves then
  /// the game is automatically a draw
  drawByFiftyMoveRule,

  /// Stalemate is a situation in the game of chess where the player whose turn it is to
  /// move is not in check but has no legal move.
  /// The rules of chess provide that when stalemate occurs, the game ends as a draw.
  drawByStalemate,

  /// If one of the players runs out of time, the player whose time runs out loses.
  timeRunOut,
}

extension GameStatusExtension on GameStatus {
  String getStatusText(String winner) {
    switch (this) {
      case GameStatus.checkMate:
        return 'CHECK MATE!\n$winner WINS';
      case GameStatus.resign:
        return '$winner WINS by resignation';
      case GameStatus.timeRunOut:
        return 'Time run out!\n$winner WINS';
      case GameStatus.drawByAgreement:
        return 'Draw by agreement';
      case GameStatus.drawByFiftyMoveRule:
        return 'Draw by fifty move rule';
      case GameStatus.drawByInsufficientMaterial:
        return 'Draw causes by insufficient material';
      case GameStatus.drawByRepetition:
        return 'Draw by repetition';
      case GameStatus.drawByStalemate:
        return 'Stalemate!';
      default:
        return 'Default';
    }
  }
}

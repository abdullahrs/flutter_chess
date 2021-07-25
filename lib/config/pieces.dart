enum Pieces{
  Pawn,
  Knight,
  Bishop,
  Castle,
  Queen,
  King
}

enum PieceColor{
  White,
  Black
}

enum Movement{
  Take,
  Move,
  Castles,
  Promote
}

enum GameOverStatus{
  CheckMate,
  Resign,
  Draw,
  OnTime
}
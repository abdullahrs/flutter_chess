import 'package:flutter_chess/config/board_map.dart';
import 'package:flutter_chess/config/check_valid_moves.dart';
import 'package:flutter_chess/config/pieces.dart';
import 'package:flutter_chess/model/piece_model.dart';
import 'package:get/get.dart';

class BoardController extends GetxController {
  var availableMoves = [].obs;
  RxBool _tapped = false.obs;

  bool get tapped => _tapped.value;
  set tapped(bool v) => _tapped.value = v;

  bool get kingIsSafe => !iSKingUnderAttack();

  List<int> whiteKingPosition = [7, 4];
  List<int> blackKingPosition = [0, 4];

  int? pX;
  int? pY;

  int? previousPx;
  int? previousPy;

  PieceColor colorToMove = PieceColor.White;

  void normalMovement(int x, int y) {
    if (movementIsAvailable(x, y)) {
      Movement type = getMovementType(x, y);
      if (type == Movement.Promote) {
        // TODO: Promotion
      } else {
        Map<String, dynamic> data = {};
        data['piece'] = PieceModel.fromObject(boardMatrix[pX!][pY!]);
        data['preX'] = previousPx;
        data['preY'] = previousPy;
        data['px'] = pX;
        data['py'] = pY;

        boardMatrix[x][y] = PieceModel.fromObject(boardMatrix[pX!][pY!]);
        boardMatrix[x][y].x = x;
        boardMatrix[x][y].y = y;
        boardMatrix[pX!][pY!] = null;
        previousPx = x;
        previousPy = y;
        pX = x;
        pY = y;
        if (!kingIsSafe) {
          boardMatrix[x][y] = null;
          previousPx = boardMatrix[x][y];
          previousPy = data['preY'];
          pX = data['px'];
          pY = data['py'];
          boardMatrix[pX!][pY!] = data['piece'];
          return;
        }
        boardMatrix[x][y].moved = true;
        tapped = false;
        if (type == Movement.Castles) {
          castling(y);
        }
        observeKings(x, y);
        colorToMove = PieceColor.Black == colorToMove
            ? PieceColor.White
            : PieceColor.Black;
      }
      availableMoves.clear();
    }
  }

  void observeKings(int x, int y) {
    if (boardMatrix[pX!][pY!].piece == Pieces.King) {
      if (boardMatrix[pX!][pY!].color == PieceColor.Black) {
        blackKingPosition = [x, y];
      } else {
        whiteKingPosition = [x, y];
      }
    }
  }

  void castling(int y) {
    // TODO: Aradaki kareler atak altinda ise rook atma
    // Short castling
    if (y == 6) {
      print("Short castling");
      if (PieceColor.White == boardMatrix[pX!][pY!].color) {
        boardMatrix[7][5] = boardMatrix[7][7];
        boardMatrix[7][7] = null;
        boardMatrix[7][5].moved = true;
      } else {
        boardMatrix[0][5] = boardMatrix[0][7];
        boardMatrix[0][7] = null;
        boardMatrix[0][5].moved = true;
      }
    }
    // Long castling
    if (y == 2) {
      print("Long castling");
      if (PieceColor.White == boardMatrix[pX!][pY!].color) {
        boardMatrix[7][3] = boardMatrix[7][0];
        boardMatrix[7][0] = null;
        boardMatrix[7][3].moved = true;
        boardMatrix[7][3].x = 7;
        boardMatrix[7][3].y = 3;
      } else {
        boardMatrix[0][3] = boardMatrix[0][0];
        boardMatrix[0][0] = null;
        boardMatrix[0][3].moved = true;
        boardMatrix[0][3].x = 0;
        boardMatrix[0][3].y = 3;
      }
    }
  }

  void enPassantPawnTake(int x, int y) {
    boardMatrix[previousPx!][y] = null;
    normalMovement(x, y);
  }

  bool movementIsAvailable(int x, int y) {
    for (dynamic l in availableMoves) {
      if (l[0] == x && l[1] == y) {
        return true;
      }
    }
    return false;
  }

  Movement getMovementType(int x, int y) {
    for (dynamic l in availableMoves) {
      if (l[0] == x && l[1] == y) {
        return l[2];
      }
    }
    // for ignore_error
    return Movement.Move;
  }

  bool activeSquares(int x, int y) {
    for (dynamic d in availableMoves) {
      if (d[0] == x && d[1] == y) return true;
    }
    return false;
  }

  bool iSKingUnderAttack() {
    /*
      Sah cekilmis mi diye kontrol
      Seeking if the king is under attack. 
    */
    int x = colorToMove == PieceColor.White
        ? whiteKingPosition[0]
        : blackKingPosition[0];
    int y = colorToMove == PieceColor.White
        ? whiteKingPosition[1]
        : blackKingPosition[1];

    // Top
    for (int i = x - 1; i >= 0; i--) {
      if (boardMatrix[i][y] != null && boardMatrix[i][y].color == colorToMove) {
        break;
      }
      if (boardMatrix[i][y] == null) continue;
      if (boardMatrix[i][y].color != colorToMove) {
        if (boardMatrix[i][y].piece == Pieces.Bishop ||
            boardMatrix[i][y].piece == Pieces.Pawn ||
            boardMatrix[i][y].piece == Pieces.Knight) {
          break;
        }
        if (boardMatrix[i][y].piece == Pieces.Queen ||
            boardMatrix[i][y].piece == Pieces.Castle) {
          return true;
        }
      }
    }
    // Top-right diagonal
    int r = x - 1;
    int t = y + 1;
    while (r >= 0 && t < 8) {
      if (boardMatrix[r][t] != null && boardMatrix[r][t].color == colorToMove)
        break;
      if (boardMatrix[r][t] != null && boardMatrix[r][t].color != colorToMove) {
        if (boardMatrix[r][t].piece == Pieces.Pawn &&
            colorToMove == PieceColor.White &&
            r == x - 2 &&
            t == y + 2) {
          return true;
        }
        if (boardMatrix[r][t].piece == Pieces.Castle ||
            boardMatrix[r][t].piece == Pieces.Pawn ||
            boardMatrix[r][t].piece == Pieces.Knight) {
          break;
        }
        if (boardMatrix[r][t].piece == Pieces.Queen ||
            boardMatrix[r][t].piece == Pieces.Bishop) {
          return true;
        }
      }
      r--;
      t++;
    }
    // Right
    for (int j = y + 1; j < 8; j++) {
      if (boardMatrix[x][j] != null && boardMatrix[x][j].color == colorToMove)
        break;
      if (boardMatrix[x][j] == null) continue;
      if (boardMatrix[x][j].color != colorToMove) {
        if (boardMatrix[x][j].piece == Pieces.Bishop ||
            boardMatrix[x][j].piece == Pieces.Pawn ||
            boardMatrix[x][j].piece == Pieces.Knight) {
          break;
        }
        if (boardMatrix[x][j].piece == Pieces.Queen ||
            boardMatrix[x][j].piece == Pieces.Castle) {
          return true;
        }
      }
    }
    // Bottom-right diagonal
    r = x + 1;
    t = y + 1;
    while (r < 8 && t < 8) {
      if (boardMatrix[r][t] != null && boardMatrix[r][t].color == colorToMove)
        break;
      if (boardMatrix[r][t] != null && boardMatrix[r][t].color != colorToMove) {
        if (boardMatrix[r][t].piece == Pieces.Pawn &&
            colorToMove == PieceColor.Black &&
            r == x + 2 &&
            t == y + 2) {
          return true;
        }
        if (boardMatrix[r][t].piece == Pieces.Castle ||
            boardMatrix[r][t].piece == Pieces.Pawn ||
            boardMatrix[r][t].piece == Pieces.Knight) {
          break;
        }
        if (boardMatrix[r][t].piece == Pieces.Queen ||
            boardMatrix[r][t].piece == Pieces.Bishop) {
          return true;
        }
      }
      r++;
      t++;
    }
    // Bottom
    for (int i = x + 1; i < 8; i++) {
      if (boardMatrix[i][y] != null && boardMatrix[i][y].color == colorToMove)
        break;
      if (boardMatrix[i][y] != null && boardMatrix[i][y].color != colorToMove) {
        if (boardMatrix[i][y].piece == Pieces.Bishop ||
            boardMatrix[i][y].piece == Pieces.Pawn ||
            boardMatrix[i][y].piece == Pieces.Knight) {
          break;
        }
        if (boardMatrix[i][y].piece == Pieces.Queen ||
            boardMatrix[i][y].piece == Pieces.Castle) {
          return true;
        }
      }
    }
    // Bottom-left diagonal
    r = x + 1;
    t = y - 1;
    while (r < 8 && t >= 0) {
      if (boardMatrix[r][t] != null && boardMatrix[r][t].color == colorToMove)
        break;
      if (boardMatrix[r][t] != null && boardMatrix[r][t].color != colorToMove) {
        if (boardMatrix[r][t].piece == Pieces.Pawn &&
            colorToMove == PieceColor.Black &&
            r == x + 2 &&
            t == y - 2) {
          return true;
        }
        if (boardMatrix[r][t].piece == Pieces.Castle ||
            boardMatrix[r][t].piece == Pieces.Pawn ||
            boardMatrix[r][t].piece == Pieces.Knight) {
          break;
        }
        if (boardMatrix[r][t].piece == Pieces.Queen ||
            boardMatrix[r][t].piece == Pieces.Bishop) {
          return true;
        }
      }
      r++;
      t--;
    }
    // Left
    for (int j = y - 1; j >= 0; j--) {
      if (boardMatrix[x][j] != null && boardMatrix[x][j].color == colorToMove)
        break;
      if (boardMatrix[x][j] != null && boardMatrix[x][j].color != colorToMove) {
        if (boardMatrix[x][j].piece == Pieces.Bishop ||
            boardMatrix[x][j].piece == Pieces.Pawn ||
            boardMatrix[x][j].piece == Pieces.Knight) {
          break;
        }
        if (boardMatrix[x][j].piece == Pieces.Queen ||
            boardMatrix[x][j].piece == Pieces.Castle) {
          return true;
        }
      }
    }
    // Top-left diagonal
    r = x - 1;
    t = y - 1;
    while (r >= 0 && t >= 0) {
      if (boardMatrix[r][t] != null && boardMatrix[r][t].color == colorToMove)
        break;
      if (boardMatrix[r][t] != null && boardMatrix[r][t].color != colorToMove) {
        if (boardMatrix[r][t].piece == Pieces.Pawn &&
            colorToMove == PieceColor.White &&
            r == x - 2 &&
            t == y - 2) {
          return true;
        }
        if (boardMatrix[r][t].piece == Pieces.Castle ||
            boardMatrix[r][t].piece == Pieces.Knight) {
          break;
        }
        if (boardMatrix[r][t].piece == Pieces.Queen ||
            boardMatrix[r][t].piece == Pieces.Bishop) {
          return true;
        }
      }
      r--;
      t--;
    }
    // Knight Top
    if ((y - 1 >= 0 &&
            x - 2 >= 0 &&
            boardMatrix[x - 2][y - 1] != null &&
            boardMatrix[x - 2][y - 1].color != colorToMove) ||
        (y + 1 >= 0 &&
            x - 2 >= 0 &&
            boardMatrix[x - 2][y + 1] != null &&
            boardMatrix[x - 2][y + 1].color != colorToMove)) {
      return true;
    }

    // Knight Right
    if ((y + 2 < 8 &&
            x + 1 < 8 &&
            boardMatrix[x + 1][y + 2] != null &&
            boardMatrix[x + 1][y + 2].color != colorToMove) ||
        (y + 2 < 8 &&
            x - 1 >= 0 &&
            boardMatrix[x - 1][y + 2] != null &&
            boardMatrix[x - 1][y + 2].color != colorToMove)) {
      return true;
    }
    // Knight Bottom
    if ((y - 1 >= 0 &&
            x + 2 < 8 &&
            boardMatrix[x + 2][y - 1] != null &&
            boardMatrix[x + 2][y - 1].color != colorToMove) ||
        (y + 1 >= 0 &&
            x + 2 < 8 &&
            boardMatrix[x + 2][y + 1] != null &&
            boardMatrix[x + 2][y + 1].color != colorToMove)) {
      return true;
    }
    // Knight Left
    if ((y - 2 >= 0 &&
            x + 1 < 8 &&
            boardMatrix[x + 1][y - 2] != null &&
            boardMatrix[x + 1][y - 2].color != colorToMove) ||
        (y - 2 >= 0 &&
            x - 1 >= 0 &&
            boardMatrix[x - 1][y - 2] != null &&
            boardMatrix[x - 1][y - 2].color != colorToMove)) {
      return true;
    }
    return false;
  }

  bool isGameOver() {
    // Eger sah cekilmis ise mat olup olmadigini kontrol etmek icin
    // saldiri altinda olan tarafa ait taslarin yapabilecegi hamlelere bakilir
    // eger yapilabilecek hamleler sah halen saldiri altinda kaliyorsa mat olmus
    // demektir.
    if (!kingIsSafe) {
      // TODO: Search
      List<dynamic> temp = List.from(availableMoves);

      for (int i = 0; i < 7; i++) {
        for (int j = 0; j < 7; j++) {
          if (boardMatrix[i][j] == null) continue;
          if (boardMatrix[i][j].color == colorToMove) {
            PieceMovements.calculateMoves(boardMatrix[i][j]);
            for (dynamic move in availableMoves) {}
          }
        }
      }
    }
    return false;
  }
}

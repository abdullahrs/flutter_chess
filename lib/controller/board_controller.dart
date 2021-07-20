import 'package:flutter_chess/config/board_map.dart';
import 'package:flutter_chess/config/pieces.dart';
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
          print(boardMatrix[x][j].piece);
          print(boardMatrix[x][j].color);
          print(colorToMove);
          print("$x $j");
          return true;
        }
      }
    }
    print("check");

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
    }
    return false;
  }
}

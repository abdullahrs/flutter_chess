import 'package:flutter/material.dart';
import 'package:flutter_chess/components/game_over_dialog.dart';
import 'package:flutter_chess/components/promotion_dialog.dart';
import 'package:flutter_chess/config/board_map.dart';
import 'package:flutter_chess/config/check_valid_moves.dart';
import 'package:flutter_chess/config/piece_paths.dart';
import 'package:flutter_chess/config/pieces.dart';
import 'package:flutter_chess/model/piece_model.dart';
import 'package:get/get.dart';

class BoardController extends GetxController {
  var availableMoves = [].obs;
  RxBool _tapped = false.obs;

  BuildContext? controllerContext;

  bool get tapped => _tapped.value;
  set tapped(bool v) => _tapped.value = v;

  bool get kingIsSafe => !iSKingUnderAttack();
  Future<bool> get gameOver async => await isGameOver();

  List<int> whiteKingPosition = [7, 4];
  List<int> blackKingPosition = [0, 4];

  int? pX;
  int? pY;

  int? previousPx;
  int? previousPy;

  PieceColor colorToMove = PieceColor.White;

  Future<void> normalMovement(int x, int y) async {
    if (movementIsAvailable(x, y)) {
      Movement type = getMovementType(x, y);
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
      observeKings(x, y);
      if (!kingIsSafe) {
        boardMatrix[x][y] = null;
        previousPx = data['preX'];
        previousPy = data['preY'];
        pX = data['px'];
        pY = data['py'];
        boardMatrix[pX!][pY!] = data['piece'];
        observeKings(pX!, pY!);
        return;
      }
      boardMatrix[x][y].moved = true;
      tapped = false;
      if (type == Movement.Castles) {
        castling(y);
      }
      if (type == Movement.Promote) {
        await promote(x, y);
      }
      await changeColorToMove();

      availableMoves.clear();
    }
  }

  void onClickReset() {
    tapped = false;
    pX = null;
    pY = null;
    availableMoves.clear();
  }

  void onClickPiece(PieceModel pieceModel) {
    tapped = true;
    pX = pieceModel.x;
    pY = pieceModel.y;
    PieceMovements.calculateMoves(pieceModel);
  }

  Future<void> onClickForCapture(PieceModel pieceModel) async {
    // Secili tas disinda kendisine ait baska bir tasa basilirsa,
    // diger tas seciliyor.
    // If another piece is pressed with the same color other than the selected piece,
    // the other piece is selected.
    if (boardMatrix[pX!][pY!].color == pieceModel.color) {
      onClickReset();
      onClickPiece(pieceModel);
      return;
    }
    // Yapilan hamlenin legal olup olmadigi kontrol ediliyor.
    // It is checked whether the move is legal or not.
    bool available = false;
    for (dynamic l in availableMoves) {
      if (l[0] == pieceModel.x &&
          l[1] == pieceModel.y &&
          l[2] == Movement.Take) {
        available = true;
        break;
      }
    }
    // Hamle legalse islemler yapiliyor.
    // If movement is legal then the movement process starts.
    if (available) {
      // Sah'in hareketleri gozlemleniyor.
      // The movements of the king are observed.
      if (boardMatrix[pX!][pY!].piece == Pieces.King) {
        if (boardMatrix[pX!][pY!].color == PieceColor.Black) {
          blackKingPosition = [pieceModel.x, pieceModel.y];
        } else {
          blackKingPosition = [pieceModel.x, pieceModel.y];
        }
      }
      // Eger sah cekilmis ise yapilacak hamlenin bilgileri tutulur ki yapilan
      // hamle sonucunda sah halen saldiri altinda ise hamleye izin verilmez
      // tutulan bilgilerle yapilan hamle geri alinir
      // If king is under attack the information of the move to be made is stored.
      // If the king is still under attack as a result of the move, the move cannot be allowed.
      // With the stored information, the move is rolled back.
      Map<String, dynamic> data = {};
      data['capturer_piece'] = PieceModel.fromObject(boardMatrix[pX!][pY!]);
      data['captured_piece'] =
          PieceModel.fromObject(boardMatrix[pieceModel.x][pieceModel.y]);
      data['preX'] = previousPx;
      data['preY'] = previousPy;
      data['px'] = pX;
      data['py'] = pY;
      // Kontrolor pozisyonlari yeni degerlerine atanir ve tahtadaki saldiran tas
      // alinan tasin yerine konur eski tas tahtadan kaldirilir.
      // New position values are assigned to the controller
      // The attacking piece is replaced by the taken piece,
      // and the taken piece is removed from the board.
      previousPx = pX;
      previousPy = pY;
      pX = pieceModel.x;
      pY = pieceModel.y;
      boardMatrix[pX!][pY!] =
          PieceModel.fromObject(boardMatrix[previousPx!][previousPy!]);
      boardMatrix[pX!][pY!].x = pieceModel.x;
      boardMatrix[pX!][pY!].y = pieceModel.y;
      boardMatrix[previousPx!][previousPy!] = null;
      // Hamlenin sonunda sah halen saldiri altinda ise hamle illegal
      // olacagindan hamle geri alinir.
      // If the king is still under attack at the end of the move, the move rolls back.
      if (!kingIsSafe) {
        previousPx = data['preX'];
        previousPy = data['preY'];
        pX = data['px'];
        pY = data['py'];
        boardMatrix[pieceModel.x][pieceModel.y] = data['captured_piece'];
        boardMatrix[pX!][pY!] = data['capturer_piece'];
        return;
      }
      if (pX == 0 || pX == 7) {
        await promote(pX!, pY!);
      }
      tapped = false;
      boardMatrix[pieceModel.x][pieceModel.y].moved = true;
      await changeColorToMove();
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

  Future<void> promote(int x, int y) async {
    var result = await showDialog(
        context: controllerContext!,
        builder: (_) => PromotionDialog(color: colorToMove));
    boardMatrix[x][y].piece = result as Pieces;
    boardMatrix[x][y].imagePath =
        piecePathMap[boardMatrix[x][y].piece]![boardMatrix[x][y].color];
  }

  void enPassantPawnTake(int x, int y) {
    boardMatrix[previousPx!][y] = null;
    normalMovement(x, y);
  }

  Future<void> changeColorToMove() async {
    PieceColor temp = colorToMove;
    colorToMove =
        PieceColor.Black == colorToMove ? PieceColor.White : PieceColor.Black;
    bool control = await gameOver;
    print("gameOver status : $control\ncolor to move : $colorToMove");
    if (control) {
      print("Check Mate!");
      await showDialog(
        context: controllerContext!,
        builder: (_) => GameOverDialog(
          color: temp,
        ),
        barrierDismissible: false,
      ).then((value) => resetVars());
    }
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
        if (boardMatrix[i][y].piece != Pieces.Queen &&
            boardMatrix[i][y].piece != Pieces.Castle) {
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
        if (boardMatrix[r][t].piece != Pieces.Queen &&
            boardMatrix[r][t].piece != Pieces.Bishop) {
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
        if (boardMatrix[x][j].piece != Pieces.Queen &&
            boardMatrix[x][j].piece != Pieces.Castle) {
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
        if (boardMatrix[r][t].piece != Pieces.Queen &&
            boardMatrix[r][t].piece != Pieces.Bishop) {
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
        if (boardMatrix[i][y].piece != Pieces.Queen &&
            boardMatrix[i][y].piece != Pieces.Castle) {
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
        if (boardMatrix[r][t].piece != Pieces.Queen &&
            boardMatrix[r][t].piece != Pieces.Bishop) {
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
        if (boardMatrix[x][j].piece != Pieces.Queen &&
            boardMatrix[x][j].piece != Pieces.Castle) {
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
        if (boardMatrix[r][t].piece != Pieces.Queen &&
            boardMatrix[r][t].piece != Pieces.Bishop) {
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
            boardMatrix[x - 2][y - 1].piece == Pieces.Knight &&
            boardMatrix[x - 2][y - 1].color != colorToMove) ||
        (y + 1 >= 0 &&
            x - 2 >= 0 &&
            boardMatrix[x - 2][y + 1] != null &&
            boardMatrix[x - 2][y + 1].piece == Pieces.Knight &&
            boardMatrix[x - 2][y + 1].color != colorToMove)) {
      return true;
    }

    // Knight Right
    if ((y + 2 < 8 &&
            x + 1 < 8 &&
            boardMatrix[x + 1][y + 2] != null &&
            boardMatrix[x + 1][y + 2].piece == Pieces.Knight &&
            boardMatrix[x + 1][y + 2].color != colorToMove) ||
        (y + 2 < 8 &&
            x - 1 >= 0 &&
            boardMatrix[x - 1][y + 2] != null &&
            boardMatrix[x - 1][y + 2].piece == Pieces.Knight &&
            boardMatrix[x - 1][y + 2].color != colorToMove)) {
      return true;
    }
    // Knight Bottom
    if ((y - 1 >= 0 &&
            x + 2 < 8 &&
            boardMatrix[x + 2][y - 1] != null &&
            boardMatrix[x + 2][y - 1].piece == Pieces.Knight &&
            boardMatrix[x + 2][y - 1].color != colorToMove) ||
        (y + 1 >= 0 &&
            x + 2 < 8 &&
            boardMatrix[x + 2][y + 1] != null &&
            boardMatrix[x + 2][y + 1].piece == Pieces.Knight &&
            boardMatrix[x + 2][y + 1].color != colorToMove)) {
      return true;
    }
    // Knight Left
    if ((y - 2 >= 0 &&
            x + 1 < 8 &&
            boardMatrix[x + 1][y - 2] != null &&
            boardMatrix[x + 1][y - 2].piece == Pieces.Knight &&
            boardMatrix[x + 1][y - 2].color != colorToMove) ||
        (y - 2 >= 0 &&
            x - 1 >= 0 &&
            boardMatrix[x - 1][y - 2] != null &&
            boardMatrix[x - 1][y - 2].piece == Pieces.Knight &&
            boardMatrix[x - 1][y - 2].color != colorToMove)) {
      return true;
    }
    return false;
  }

  Future<bool> isGameOver() async {
    // Eger sah cekilmis ise mat olup olmadigini kontrol etmek icin
    // saldiri altinda olan tarafa ait taslarin yapabilecegi hamlelere bakilir
    // eger yapilabilecek hamleler sah halen saldiri altinda kaliyorsa mat olmus
    // demektir.
    if (!kingIsSafe) {
      List<dynamic> temp = List.from(availableMoves);
      List<List<dynamic>> tempMatrix = [
        for (List<dynamic> l in boardMatrix) List.from(l)
      ];
      PieceColor tempColor = colorToMove;
      for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
          if (boardMatrix[i][j] == null) continue;
          if (boardMatrix[i][j].color == colorToMove) {
            PieceMovements.calculateMoves(boardMatrix[i][j]);
            for (dynamic move in availableMoves) {
              int x = move[0];
              int y = move[1];
              Movement type = move[2];
              onClickPiece(boardMatrix[i][j]);
              if (type == Movement.Move) {
                await normalMovement(x, y);
              } else if (type == Movement.Take) {
                await onClickForCapture(boardMatrix[i][j]);
              } else if (type == Movement.Promote) {
                await promote(x, y);
              }
              if (kingIsSafe) {
                availableMoves.value = temp;
                boardMatrix = tempMatrix;
                colorToMove = tempColor;
                return false;
              }
            }
          }
        }
      }
      boardMatrix = tempMatrix;
      availableMoves.value = temp;
      colorToMove = tempColor;
      return true;
    }
    return false;
  }

  void resetVars() {
    availableMoves.clear();
    tapped = false;
    whiteKingPosition = [7, 4];
    blackKingPosition = [0, 4];
    pX = null;
    pY = null;
    previousPx = null;
    previousPy = null;
    colorToMove = PieceColor.White;
    update();
  }
}

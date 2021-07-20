import 'package:flutter/material.dart';
import 'package:flutter_chess/config/board_map.dart';
import 'package:flutter_chess/config/check_valid_moves.dart';
import 'package:flutter_chess/config/pieces.dart';
import 'package:flutter_chess/controller/board_controller.dart';
import 'package:flutter_chess/model/piece_model.dart';
import 'package:get/get.dart';

class Piece extends StatelessWidget {
  final PieceModel pieceModel;
  const Piece({
    Key? key,
    required this.pieceModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BoardController _boardController = Get.find();
    return GestureDetector(
      onTap: () {
        // Eger hicbir tasa dokunulmadiysa ya da bir tas seciliyken baska
        // bir tas secilirse
        // If no piece is touched, or if a different piece is selected
        // while a piece is selected
        if (!_boardController.tapped ||
            (_boardController.pX != pieceModel.x ||
                _boardController.pY != pieceModel.y)) {
          if (_boardController.tapped) {
            onClickForCapture(_boardController);
          } else {
            // Sadece sirasi gelen taraf oynayabiliyor
            // Only the player whose turn it is can play
            if (pieceModel.color == _boardController.colorToMove)
              onClickPiece(_boardController);
          }
        }
        // Eger ayni tasa bir daha dokunulursa
        // If the same piece is touched again
        else {
          onClickReset(_boardController);
        }
        _boardController.update();
      },
      child: Container(
        width: MediaQuery.of(context).size.width * (0.9),
        height: MediaQuery.of(context).size.height * (0.9),
        decoration: BoxDecoration(
          border: Border.all(
              width: 4,
              color: _boardController.colorToMove != pieceModel.color &&
                      _boardController.tapped &&
                      _boardController.activeSquares(pieceModel.x, pieceModel.y)
                  ? Colors.red
                  : Colors.transparent),
          image: DecorationImage(
            image: AssetImage(pieceModel.imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void onClickReset(BoardController _boardController) {
    _boardController.tapped = false;
    _boardController.pX = null;
    _boardController.pY = null;
    _boardController.availableMoves.clear();
  }

  void onClickPiece(BoardController _boardController) {
    _boardController.tapped = true;
    _boardController.pX = pieceModel.x;
    _boardController.pY = pieceModel.y;
    PieceMovements.calculateMoves(pieceModel);
  }

  void onClickForCapture(BoardController _boardController) {
    // Secili tas disinda kendisine ait baska bir tasa basilirsa,
    // diger tas seciliyor.
    // If another piece is pressed with the same color other than the selected piece,
    // the other piece is selected.
    if (boardMatrix[_boardController.pX!][_boardController.pY!].color ==
        pieceModel.color) {
      onClickReset(_boardController);
      onClickPiece(_boardController);
      return;
    }
    // Yapilan hamlenin legal olup olmadigi kontrol ediliyor.
    // It is checked whether the move is legal or not.
    bool available = false;
    for (dynamic l in _boardController.availableMoves) {
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
      if (boardMatrix[_boardController.pX!][_boardController.pY!].piece ==
          Pieces.King) {
        if (boardMatrix[_boardController.pX!][_boardController.pY!].color ==
            PieceColor.Black) {
          _boardController.blackKingPosition = [pieceModel.x, pieceModel.y];
        } else {
          _boardController.blackKingPosition = [pieceModel.x, pieceModel.y];
        }
      }
      // Eger sah cekilmis ise yapilacak hamlenin bilgileri tutulur ki yapilan
      // hamle sonucunda sah halen saldiri altinda ise hamleye izin verilmez
      // tutulan bilgilerle yapilan hamle geri alinir
      // If king is under attack the information of the move to be made is stored.
      // If the king is still under attack as a result of the move, the move cannot be allowed.
      // With the stored information, the move is rolled back.
      Map<String, dynamic> data = {};
      if (!_boardController.kingIsSafe) {
        data['capturer_piece'] = PieceModel.fromObject(
            boardMatrix[_boardController.pX!][_boardController.pY!]);
        data['captured_piece'] =
            PieceModel.fromObject(boardMatrix[pieceModel.x][pieceModel.y]);
        data['preX'] = _boardController.previousPx;
        data['preY'] = _boardController.previousPy;
        data['px'] = _boardController.pX;
        data['py'] = _boardController.pY;
      }
      // Kontrolor pozisyonlari yeni degerlerine atanir ve tahtadaki saldiran tas
      // alinan tasin yerine konur eski tas tahtadan kaldirilir.
      // New position values are assigned to the controller
      // The attacking piece is replaced by the taken piece,
      // and the taken piece is removed from the board.
      _boardController.previousPx = _boardController.pX;
      _boardController.previousPy = _boardController.pY;
      _boardController.pX = pieceModel.x;
      _boardController.pY = pieceModel.y;
      boardMatrix[_boardController.pX!][_boardController.pY!] =
          PieceModel.fromObject(boardMatrix[_boardController.previousPx!]
              [_boardController.previousPy!]);
      boardMatrix[_boardController.pX!][_boardController.pY!].x = pieceModel.x;
      boardMatrix[_boardController.pX!][_boardController.pY!].y = pieceModel.y;
      boardMatrix[_boardController.previousPx!][_boardController.previousPy!] =
          null;
      // Hamlenin sonunda sah halen saldiri altinda ise hamle illegal
      // olacagindan hamle geri alinir.
      // If the king is still under attack at the end of the move, the move rolls back.
      if (!_boardController.kingIsSafe) {
        _boardController.previousPx = data['preX'];
        _boardController.previousPy = data['preY'];
        _boardController.pX = data['px'];
        _boardController.pY = data['py'];
        boardMatrix[pieceModel.x][pieceModel.y] = data['captured_piece'];
        boardMatrix[_boardController.pX!][_boardController.pY!] =
            data['capturer_piece'];
        return;
      }
      _boardController.tapped = false;
      boardMatrix[pieceModel.x][pieceModel.y].moved = true;
      _boardController.colorToMove = PieceColor.Black ==
              boardMatrix[_boardController.pX!][_boardController.pY!].color
          ? PieceColor.White
          : PieceColor.Black;
      _boardController.availableMoves.clear();
    }
  }
}

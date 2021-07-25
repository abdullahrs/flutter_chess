import 'package:flutter/material.dart';
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
      onTap: () async {
        // Eger hicbir tasa dokunulmadiysa ya da bir tas seciliyken baska
        // bir tas secilirse
        // If no piece is touched, or if a different piece is selected
        // while a piece is selected
        if (!_boardController.tapped ||
            (_boardController.pX != pieceModel.x ||
                _boardController.pY != pieceModel.y)) {
          if (_boardController.tapped) {
            await _boardController.onClickForCapture(pieceModel);
          } else {
            // Sadece sirasi gelen taraf oynayabiliyor
            // Only the player whose turn it is can play
            if (pieceModel.color == _boardController.colorToMove)
              _boardController.onClickPiece(pieceModel);
          }
        }
        // Eger ayni tasa bir daha dokunulursa
        // If the same piece is touched again
        else {
          _boardController.onClickReset();
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
}

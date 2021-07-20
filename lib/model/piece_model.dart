import 'package:flutter_chess/config/pieces.dart';

class PieceModel {
  late Pieces piece;
  late PieceColor color;
  late String imagePath;
  bool moved = false;
  late int x;
  late int y;

  PieceModel(this.piece, this.color, this.imagePath, this.x, this.y);
  PieceModel.fromObject(PieceModel pieceModel) {
    piece = pieceModel.piece;
    color = pieceModel.color;
    imagePath = pieceModel.imagePath;
    moved = pieceModel.moved;
    x = pieceModel.x;
    y = pieceModel.y;
  }
}

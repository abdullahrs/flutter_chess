import 'package:flutter/material.dart';
import '../model/piece_model.dart';


class Piece extends StatelessWidget {
  final PieceModel pieceModel;
  const Piece({Key? key, required this.pieceModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * (0.9),
      height: MediaQuery.of(context).size.height * (0.9),
      decoration: BoxDecoration(
        border: Border.all(width: 4, color: Colors.transparent),
        image: DecorationImage(
          image: AssetImage(pieceModel.imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

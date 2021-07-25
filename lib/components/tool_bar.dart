import 'package:flutter/material.dart';
import 'package:flutter_chess/components/timer.dart';
import 'package:flutter_chess/config/pieces.dart';
import 'package:flutter_chess/controller/board_controller.dart';
import 'package:get/get.dart';

class ToolBar extends StatelessWidget {
  final PieceColor pieceColor;
  ToolBar({
    Key? key,
    required this.pieceColor,
  }) : super(key: key);

  final BoardController _boardController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * (0.1),
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: pieceColor == PieceColor.White
            ? createElements().reversed.toList()
            : createElements(),
      ),
    );
  }

  List<Widget> createElements() => [
        ChessTimer(
          pieceColor: pieceColor,
        ),
        Spacer(flex: 3),
        IconButton(
            icon: Icon(Icons.flag),
            onPressed: () async {
              await _boardController.showGameOverDialog(
                  _boardController.colorToMove == PieceColor.Black
                      ? PieceColor.White
                      : PieceColor.Black,
                  GameOverStatus.Resign);
            }),
      ];
}

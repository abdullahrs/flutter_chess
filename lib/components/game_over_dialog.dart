import 'package:flutter/material.dart';
import 'package:flutter_chess/config/board_map.dart';
import 'package:flutter_chess/config/pieces.dart';

class GameOverDialog extends StatelessWidget {
  final PieceColor color;

  const GameOverDialog({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String lead = color == PieceColor.White ? 'WHITE' : 'BLACK';
    return AlertDialog(
      backgroundColor: Colors.grey,
      content: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("CHECK MATE!\n$lead WON"),
            IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  restart();
                  Navigator.of(context).pop();
                }),
          ],
        ),
      ),
    );
  }

  void restart() {
    boardMatrix = matrix;
  }
}

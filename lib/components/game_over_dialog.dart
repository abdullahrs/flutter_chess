import 'package:flutter/material.dart';
import 'package:flutter_chess/config/board_map.dart';
import 'package:flutter_chess/config/colors.dart';
import 'package:flutter_chess/config/pieces.dart';

class GameOverDialog extends StatelessWidget {
  final PieceColor color;
  final GameOverStatus gameOverStatus;
  const GameOverDialog(
      {Key? key, required this.color, required this.gameOverStatus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String lead = color == PieceColor.White ? 'WHITE' : 'BLACK';
    String status;
    if (gameOverStatus == GameOverStatus.CheckMate) {
      status = "CHECK MATE!";
    } else if (gameOverStatus == GameOverStatus.Resign) {
      status = "OPPONENT RESIGNED!";
    } else if (gameOverStatus == GameOverStatus.OnTime) {
      status = "RUN OUT OF TIME!";
    }else {
      status = "DRAW!";
    }
    return AlertDialog(
      backgroundColor: ChessStyle.dialogBackgroundColor,
      content: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$status!\n${gameOverStatus != GameOverStatus.Draw ? '$lead WON!' : ''}",
              textAlign: TextAlign.center,
              style: TextStyle(color: ChessStyle.dialogTextColor),
            ),
            IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: ChessStyle.dialogTextColor,
                ),
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
    boardMatrix = [for (List<dynamic> l in matrix) List.from(l)];
  }
}

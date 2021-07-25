import 'package:flutter/material.dart';
import 'package:flutter_chess/config/colors.dart';
import 'package:flutter_chess/config/pieces.dart';
import 'package:flutter_chess/controller/board_controller.dart';
import 'package:get/get.dart';

class ChessTimer extends StatelessWidget {
  final PieceColor pieceColor;
  ChessTimer({Key? key, required this.pieceColor}) : super(key: key);
  final BoardController _boardController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: MediaQuery.of(context).size.width * (0.3),
        height: MediaQuery.of(context).size.height * (0.075),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(width: 4, color: ChessStyle.pickerBorderColor),
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            color: ChessStyle.dialogButtonBackgroundColor),
        child: Text(
          formatDuration(),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, color: ChessStyle.dialogTextColor),
        ),
      ),
    );
  }

  String formatDuration() {
    if (_boardController.whiteTime == -1) return "";
    Duration duration = pieceColor == PieceColor.White
        ? Duration(seconds: _boardController.whiteTime)
        : Duration(seconds: _boardController.blackTime);
    int minute = duration.inMinutes;
    int second = duration.inSeconds - minute * 60;
    return "${minute < 10 ? '0$minute' : minute} : ${second < 10 ? '0$second' : second}";
  }
}

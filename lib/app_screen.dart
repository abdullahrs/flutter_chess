import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chess/components/board.dart';
import 'package:flutter_chess/components/tool_bar.dart';
import 'package:flutter_chess/config/pieces.dart';
import 'package:flutter_chess/controller/board_controller.dart';
import 'package:get/get.dart';

class Chess extends StatefulWidget {
  const Chess({Key? key}) : super(key: key);

  @override
  _ChessState createState() => _ChessState();
}

class _ChessState extends State<Chess> {
  BoardController boardController = Get.put(BoardController());
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    boardController.whiteTime = -1;
    boardController.blackTime = -1;
    boardController.controllerContext = context;
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await boardController.showDurationPickerDialog();
      _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
        if (boardController.whiteTime > 0 && boardController.blackTime > 0) {
          if (boardController.colorToMove == PieceColor.White) {
            boardController.whiteTime--;
            if (boardController.whiteTime == 0) {
              boardController.showGameOverDialog(
                  PieceColor.Black, GameOverStatus.OnTime);
            }
          } else {
            boardController.blackTime--;
            if (boardController.blackTime == 0) {
              boardController.showGameOverDialog(
                  PieceColor.White, GameOverStatus.OnTime);
            }
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Column(
            children: [
              Flexible(
                  flex: 1,
                  child: ToolBar(
                    pieceColor: PieceColor.Black,
                  )),
              Spacer(),
              Flexible(flex: 6, child: Board()),
              Spacer(),
              Flexible(
                  flex: 1,
                  child: ToolBar(
                    pieceColor: PieceColor.White,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

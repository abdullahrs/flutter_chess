import 'package:flutter/material.dart';
import 'package:flutter_chess/components/board.dart';
import 'package:flutter_chess/components/tool_bar.dart';
import 'package:flutter_chess/controller/board_controller.dart';
import 'package:get/get.dart';

class Chess extends StatefulWidget {
  const Chess({Key? key}) : super(key: key);

  @override
  _ChessState createState() => _ChessState();
}

class _ChessState extends State<Chess> {
  BoardController boardController = Get.put(BoardController());
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
              Flexible(flex: 1, child: ToolBar(reverse: false)),
              Spacer(),
              Flexible(flex: 6, child: Board()),
              Spacer(),
              Flexible(flex: 1, child: ToolBar(reverse: true)),
            ],
          ),
        ),
      ),
    );
  }
}

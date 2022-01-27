import 'package:flutter/material.dart';
import '../constants/assets.dart';
import 'board.dart';

class ChessPage extends StatelessWidget {
  const ChessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.background.path),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Spacer(flex: 2),
              Flexible(
                flex: 6,
                child: ChessBoard(),
              ),
              Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

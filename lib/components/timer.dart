import 'package:flutter/material.dart';

class ChessTimer extends StatelessWidget {
  const ChessTimer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * (0.25),
      height: MediaQuery.of(context).size.height * (0.075),
      decoration:
          BoxDecoration(border: Border.all(width: 4), color: Colors.white),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_chess/components/timer.dart';

class ToolBar extends StatelessWidget {
  final bool reverse;
  const ToolBar({Key? key, required this.reverse}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * (0.1),
      decoration: BoxDecoration(
        color: Colors.brown,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
            reverse ? createElements().reversed.toList() : createElements(),
      ),
    );
  }

  List<Widget> createElements() => [
        ChessTimer(),
        Spacer(),
        IconButton(icon: Icon(Icons.stop), onPressed: () {}),
        Spacer(flex: 3),
        IconButton(icon: Icon(Icons.flag), onPressed: () {}),
      ];
}

import 'package:flutter/material.dart';
import '../../../extensions/buildcontext_extension.dart';
import '../../../style/chess_style.dart';
import '../../../constants/piece_colors.dart';

class TimerSection extends StatefulWidget {
  final PieceColor color;
  final int initialTimePerSeconds;
  const TimerSection(
      {Key? key, required this.color, this.initialTimePerSeconds = 120})
      : super(key: key);

  @override
  State<TimerSection> createState() => _TimerSectionState();
}

class _TimerSectionState extends State<TimerSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.dynamicHeight(0.2),
      decoration: const BoxDecoration(color: Colors.brown),
      child: Row(
        children: [
          Container(
            width: context.dynamicWidth(0.2),
            height: context.dynamicHeight(0.2),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: ChessStyle.dialogBackgroundColor,
                border: Border.all(color: ChessStyle.dialogTextColor)),
            child: Text(
              widget.initialTimePerSeconds.toString(),
              style: context.appTextTheme.bodyText2,
            ),
          )
        ],
      ),
    );
  }
}

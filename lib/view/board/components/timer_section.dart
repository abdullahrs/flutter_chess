import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chess/constants/game_statuses.dart';
import '../viewmodel/board_behavior_controllers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../extensions/buildcontext_extension.dart';
import '../../../extensions/int_time_extension.dart';
import '../../../style/chess_style.dart';
import '../../../constants/piece_colors.dart';

class TimerSection extends StatelessWidget {
  final PieceColor color;
  const TimerSection({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.dynamicHeight(0.2),
      decoration: BoxDecoration(color: Colors.brown[400]!.withOpacity(0.5)),
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
            child: Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final _controller = ref.watch(timeControllerProvider);
              return Text(
                color == PieceColor.white
                    ? _controller.whiteTime.timeString
                    : _controller.blackTime.timeString,
                style: context.appTextTheme.bodyText2,
              );
            }),
          )
        ],
      ),
    );
  }
}

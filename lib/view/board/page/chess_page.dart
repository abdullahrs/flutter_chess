import 'package:flutter/material.dart';
import 'package:flutter_chess/constants/piece_colors.dart';
import 'package:flutter_chess/view/board/components/timer_section.dart';
import '../../../components/dialog/result_dialog.dart';
import '../../../constants/game_statuses.dart';
import '../viewmodel/board_behavior_controllers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/assets.dart';
import '../components/board.dart';

class ChessPage extends ConsumerWidget {
  const ChessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch<GameStatus>(resultController);
    if (result != GameStatus.continues) {
      final board = ref.read(boardControllerProvider);
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => ResultDialog(
            dialogText: result.getStatusText(board.colorToMove.name),
            onClick: () {
              ref.read(boardControllerProvider.notifier).resetBoard();
            },
          ),
        );
      });
    }
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
              Flexible(child: TimerSection(color: PieceColor.black)),
              Spacer(flex: 1),
              Flexible(
                flex: 6,
                child: ChessBoard(),
              ),
              Spacer(flex: 1),
              Flexible(child: TimerSection(color: PieceColor.white)),
            ],
          ),
        ),
      ),
    );
  }
}

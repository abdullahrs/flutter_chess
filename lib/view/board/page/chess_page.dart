import 'dart:async';

import 'package:flutter/material.dart';
import '../../../components/dialog/duration_picker_dialog.dart';
import '../../../constants/piece_colors.dart';
import '../components/timer_section.dart';
import '../../../components/dialog/result_dialog.dart';
import '../../../constants/game_statuses.dart';
import '../viewmodel/board_behavior_controllers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/assets.dart';
import '../components/board.dart';

class ChessPage extends ConsumerStatefulWidget {
  const ChessPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ChessPage> createState() => _ChessPageState();
}

class _ChessPageState extends ConsumerState<ChessPage> {
  late Timer _timer;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    preBuildSetup();
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

  void preBuildSetup() {
    final result = ref.watch<GameStatus>(resultController);
    final board = ref.read(boardControllerProvider);

    if (result == GameStatus.initial) {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        final controller = ref.read(boardControllerProvider.notifier);
        controller.changeStatus(GameStatus.continues);
        List<int> result = await showDialog(
            context: context,
            builder: (_) => const DurationPickerDialog()).then((value) {
          _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
            final colorToMove = ref.read(boardControllerProvider);
            final timeController = ref.read(timeControllerProvider.notifier);
            if (timeController.getTime(colorToMove.colorToMove) > -1) {
              timeController.decrement(colorToMove.colorToMove);
            }
          });
          return value;
        });
        if (result.isNotEmpty) {
          final timeController = ref.read(timeControllerProvider.notifier);
          timeController.init(result[0] * 60, result[1]);
        }
      });
    }
    if (result != GameStatus.continues && result != GameStatus.initial) {
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
  }
}


import '../../../model/board_model.dart';

import 'board_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final boardControllerProvider =
    StateNotifierProvider<BoardController, BoardModel>((ref) => BoardController());

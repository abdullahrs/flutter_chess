import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../model/movement_model.dart';
import '../constants/initial_board.dart';
import '../components/piece.dart';

part 'board_cubit_states.dart';

class BoardCubit extends Cubit<BoardState> {
  BoardCubit() : super(const BoardState(stateStatus: BoardStatus.initial));

  final List<List<Piece?>> board = [...kInitialBoard];

  Movement? lastWhiteMove;
  Movement? lastBlackMove;

  void initializeBoard() {
    emit(const BoardState(stateStatus: BoardStatus.ready));
  }
}

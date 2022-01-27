import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../constants/initial_board.dart';
import '../components/piece.dart';

part 'board_cubit_states.dart';

class BoardCubit extends Cubit<BoardState> {
  BoardCubit() : super(const BoardState(stateStatus: BoardStatus.initial));

  void initializeBoard() {
    emit(BoardState(stateStatus: BoardStatus.ready, board: kInitialBoard));
  }
}

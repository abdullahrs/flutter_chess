part of 'board_cubit.dart';

enum BoardStatus { initial, ready, move, checkMate, stealmate, draw, reset }

class BoardState extends Equatable {
  const BoardState({
    required this.stateStatus,
  });

  final BoardStatus stateStatus;

  @override
  List<Object?> get props => [stateStatus];

  BoardState copyWith({
    BoardStatus? newStatus,
    List<List<Piece?>>? newBoard,
  }) {
    return BoardState(stateStatus: newStatus ?? stateStatus);
  }
}

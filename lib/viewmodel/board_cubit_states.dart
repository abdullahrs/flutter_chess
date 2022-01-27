part of 'board_cubit.dart';

enum BoardStatus { initial,ready ,whitePlayed, blackPlayed, reset }

class BoardState extends Equatable {
  const BoardState({
    this.board,
    required this.stateStatus,
  });

  final BoardStatus stateStatus;
  final List<List<Piece?>>? board;

  @override
  List<Object?> get props => [stateStatus, board];

  BoardState copyWith({
    BoardStatus? newStatus,
    List<List<Piece?>>? newBoard,
  }) {
    return BoardState(
        board: newBoard ?? board, stateStatus: newStatus ?? stateStatus);
  }

}

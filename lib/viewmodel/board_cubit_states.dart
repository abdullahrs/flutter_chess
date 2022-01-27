part of 'board_cubit.dart';

// enum GameStatus {
//   initial,
//   continues,
//   checkMate,
//   stealmate,
//   draw,
//   resign,
//   inefficient
// }

// enum GameEvent { movesCalculated, movePlayed }

abstract class BoardState {}

class BoardInitial extends BoardState {}

class MovesCalculated extends BoardState {
  final List<Movement> movements;

  MovesCalculated(this.movements);
}

class OnClickReset extends BoardState {}

class PieceMovement extends BoardState {}

// class BoardState extends Equatable {
//   const BoardState({
//     required this.stateStatus,
//   });

//   final BoardStatus stateStatus;

//   @override
//   List<Object?> get props => [stateStatus];

//   BoardState copyWith({
//     BoardStatus? newStatus,
//     List<List<Piece?>>? newBoard,
//   }) {
//     return BoardState(stateStatus: newStatus ?? stateStatus);
//   }
// }

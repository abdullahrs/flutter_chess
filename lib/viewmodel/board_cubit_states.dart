part of 'board_cubit.dart';

// enum GameEvent { movesCalculated, movePlayed }

abstract class BoardState {}

class BoardInitial extends BoardState {}

class MovesCalculated extends BoardState {
  final List<Movement> movements;

  MovesCalculated(this.movements);
}

class OnClickReset extends BoardState {}

class PieceMovement extends BoardState {}

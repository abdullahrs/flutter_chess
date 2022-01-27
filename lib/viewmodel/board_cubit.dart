import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chess/constants/movement_types.dart';
import '../constants/piece_colors.dart';
import '../constants/pieces.dart';
import '../model/piece_position_model.dart';
import '../utility/calculate_legal_moves.dart';
import '../model/movement_model.dart';
import '../constants/initial_board.dart';
import '../components/board/piece.dart';

part 'board_cubit_states.dart';

class BoardCubit extends Cubit<BoardState> {
  BoardCubit() : super(BoardInitial());

  final List<List<Piece?>> board = [...kInitialBoard];

  Movement? lastWhiteMove;
  Movement? lastBlackMove;

  PieceColor _colorToMove = PieceColor.white;

  PieceColor get colorToMove => _colorToMove;

  void _changeColorToMove() {
    if (_colorToMove == PieceColor.white) {
      _colorToMove = PieceColor.black;
    } else {
      _colorToMove = PieceColor.white;
    }
  }

  PiecePosition? _selectedSquare;

  List<Movement> _availableMoves = [];

  void onClickSquare(int x, int y) {
    Piece? square = board[x][y];
    log("[onClickSquare] Position<$x , $y> Square value : ${square?.pieceModel.piece}");
    // If selected square is null player doesn't click any pieces
    if (_selectedSquare == null) {
      // If the pressed square is not empty and If the selected piece is the player's piece
      // selected piece position assign to the _selectedSquare
      if (square != null && square.pieceModel.color == colorToMove) {
        _selectedSquare = square.pieceModel.piecePosition;
        // For checking en-passant move
        if (square.pieceModel.piece == Pieces.pawn) {
          _availableMoves = PieceMovementCalculator.instance.calculateMoves(
              square.pieceModel, board,
              previousBlackMove: lastBlackMove,
              previousWhiteMove: lastWhiteMove);
          _availableMoves
              .forEach((e) => log("Move : <${e.positionX},${e.positionY}>"));
          emit(MovesCalculated(_availableMoves));
        } else {
          _availableMoves = PieceMovementCalculator.instance
              .calculateMoves(square.pieceModel, board);
        }
      } else {
        unSelectSquare();
      }
    } else {
      if (square != null &&
          square.pieceModel.piecePosition == _selectedSquare) {
        unSelectSquare();
      } else if (square != null) {
        if (square.pieceModel.color == colorToMove) {
          unSelectSquare();
          onClickSquare(x, y);
        } else {
          Movement? temp = getMovement(x, y);
          if (temp != null) {
            move(temp);
          } else {
            unSelectSquare();
          }
        }
      } else {
        // If _selectedSquare is not null it means player presses a piece,
        // after then clicks empty square, to move the piece
        // or the piece in the pressed square is the player's.
        if (square == null) {
          Movement? temp = getMovement(x, y);
          if (temp != null) move(temp);
        }
      }
    }
  }

  Movement? getMovement(int x, int y) {
    List moves = _availableMoves
        .where((move) => (move.positionX == x && move.positionY == y))
        .toList();
    return moves.isEmpty ? null : (moves.first.isLegal ? moves.first : null);
  }

  void move(Movement move) {
    board[move.positionX][move.positionY] = Piece(
      pieceModel: board[move.previousX][move.previousY]!.pieceModel.copyWith(
          piecePosition: PiecePosition(move.positionX, move.positionY)),
    );
    // If the condition is true, the en-passant is applied
    if (move.movementType == MovementType.enPassant) {
      int sign = colorToMove == PieceColor.white ? -1 : 1;
      board[move.positionX - sign][move.positionY] = null;
    }
    board[move.previousX][move.previousY] = null;
    assignPrevMove(move);
    _changeColorToMove();
    unSelectSquare();
    emit(PieceMovement());
  }

  void unSelectSquare() {
    _availableMoves.clear();
    _selectedSquare = null;
    emit(OnClickReset());
  }

  void assignPrevMove(Movement movement) {
    if (colorToMove == PieceColor.white) {
      lastWhiteMove = movement;
    } else {
      lastBlackMove = movement;
    }
  }
}

import 'dart:developer';

import '../model/board_model.dart';
import '../components/board/piece.dart';
import '../constants/game_statuses.dart';
import '../constants/movement_types.dart';
import '../constants/piece_colors.dart';
import '../constants/pieces.dart';
import '../model/movement_model.dart';
import '../model/piece_position_model.dart';
import '../utility/calculate_game_statuses.dart';
import '../utility/calculate_movements.dart';

import '../constants/board_defination.dart';
import '../constants/initial_board.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BoardController extends StateNotifier<BoardModel> {
  BoardController() : super(BoardModel(board: kInitialBoard));

  void _changeColorToMove() {
    if (state.colorToMove == PieceColor.white) {
      state = state.copyWith(colorToMove: PieceColor.black);
    } else {
      state = state.copyWith(colorToMove: PieceColor.white);
    }
  }

  void onClickSquare(int x, int y) {
    Piece? square = state.board[x][y];
    log("[onClickSquare] Position<$x , $y> Square value : ${square?.pieceModel.piece}");
    // If selected square is null player doesn't click any pieces
    if (state.selectedSquare == null) {
      // If the pressed square is not empty and If the selected piece is the player's piece
      // selected piece position assign to the _selectedSquare
      if (square != null && square.pieceModel.color == state.colorToMove) {
        // For checking en-passant move
        if (square.pieceModel.piece == Pieces.pawn) {
          state = state.copyWith(
            availableMoves: PieceMovementCalculator.instance.calculateMoves(
              square.pieceModel,
              state.board,
              previousBlackMove: state.lastBlackMove,
              previousWhiteMove: state.lastWhiteMove,
              blackKingPos: state.blackKingPosition,
              whiteKingPos: state.whiteKingPosition,
            ),
            selectedSquare: square.pieceModel.piecePosition,
          );
        } else {
          state = state.copyWith(
            availableMoves: PieceMovementCalculator.instance.calculateMoves(
              square.pieceModel,
              state.board,
              blackKingPos: state.blackKingPosition,
              whiteKingPos: state.whiteKingPosition,
            ),
            selectedSquare: square.pieceModel.piecePosition,
          );
        }
      } else {
        log("else unSelectSquare state : $state");
        unSelectSquare();
      }
    } else {
      log("state : $state");

      if (square != null &&
          square.pieceModel.piecePosition == state.selectedSquare) {
        unSelectSquare();
      } else if (square != null) {
        if (square.pieceModel.color == state.colorToMove) {
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
    List moves = state.availableMoves
        .where((move) => (move.positionX == x && move.positionY == y))
        .toList();
    return moves.isEmpty ? null : (moves.first.isLegal ? moves.first : null);
  }

  void move(Movement move) {
    if (!move.isLegal) return;
    if (state.board[move.previousX][move.previousY]!.pieceModel.piece ==
        Pieces.king) {
      if (state.board[move.previousX][move.previousY]!.pieceModel.color ==
          PieceColor.white) {
        state = state.copyWith(
            whiteKingPosition: PiecePosition(move.positionX, move.positionY));
      } else {
        state = state.copyWith(
            blackKingPosition: PiecePosition(move.positionX, move.positionY));
      }
    }
    state.board[move.positionX][move.positionY] = Piece(
      pieceModel: state.board[move.previousX][move.previousY]!.pieceModel
          .copyWith(
              piecePosition: PiecePosition(move.positionX, move.positionY),
              moved: true),
    );
    // If the condition is true, the en-passant is applied
    if (move.movementType == MovementType.enPassant) {
      int sign = state.colorToMove == PieceColor.white ? -1 : 1;
      state.board[move.positionX - sign][move.positionY] = null;
    } else if (move.movementType == MovementType.shortCastle) {
      state.board[move.positionX][move.positionY - 1] = Piece(
        pieceModel: state.board[move.positionX][move.positionY + 1]!.pieceModel
            .copyWith(
                piecePosition:
                    PiecePosition(move.positionX, move.positionY - 1),
                moved: true),
      );
      state.board[move.positionX][move.positionY + 1] = null;
    } else if (move.movementType == MovementType.longCastle) {
      state.board[move.positionX][move.positionY + 1] = Piece(
        pieceModel: state.board[move.positionX][move.positionY - 2]!.pieceModel
            .copyWith(
                piecePosition:
                    PiecePosition(move.positionX, move.positionY + 1),
                moved: true),
      );
      state.board[move.positionX][move.positionY - 2] = null;
    }
    state.board[move.previousX][move.previousY] = null;
    assignPrevMove(move);
    _changeColorToMove();
    CalculateGameStatuses.instance
        .updatePlayedMoves(state.board.boardStateToString());
    GameStatus gameStatus = CalculateGameStatuses.instance.calculateGameStatus(
        board: state.board,
        whiteKingPos: state.whiteKingPosition,
        blackKingPos: state.blackKingPosition);
    log("Game status : $gameStatus");
    unSelectSquare();
  }

  void unSelectSquare() {
    state =
        state.copyWith(availableMoves: [], selectedSquare: NullPiecePosition());
  }

  void assignPrevMove(Movement movement) {
    if (state.colorToMove == PieceColor.white) {
      state = state.copyWith(lastWhiteMove: movement);
    } else {
      state = state.copyWith(lastBlackMove: movement);
    }
  }
}
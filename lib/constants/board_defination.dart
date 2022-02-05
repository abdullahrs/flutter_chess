import 'board_consts.dart';

import 'piece_colors.dart';

import '../model/piece_position_model.dart';
import '../components/board/piece.dart';
import 'pieces.dart';

typedef Board = List<List<Piece?>>;

const PiecePosition kInitialWhiteKingPosition = PiecePosition(7, 4);
const PiecePosition kInitialBlackKingPosition = PiecePosition(0, 4);

extension BoardExtension on Board {
  /*
  bRa8 bNb8 bBc8 bQd8 bKe8 ...
  bPa7 bPb7 bPc7 bPd7 bPe8
  */
  String boardStateToString() {
    String boardString = "";
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        Piece? square = this[i][j];
        if (square != null) {
          String color =
              square.pieceModel.color == PieceColor.white ? 'w' : 'b';
          boardString += color +
              square.pieceModel.piece.iccfNotation +
              kColumnNames[j] +
              "${8 - i} ";
        } else {
          boardString += "    ";
        }
      }
      boardString += '\n';
    }
    return boardString;
  }
}

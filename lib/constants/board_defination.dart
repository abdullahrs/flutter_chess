import '../model/piece_position_model.dart';
import '../components/board/piece.dart';
import 'pieces.dart';

typedef Board = List<List<Piece?>>;

const PiecePosition kInitialWhiteKingPosition = PiecePosition(7, 4);
const PiecePosition kInitialBlackKingPosition = PiecePosition(0, 4);

extension BoardExtension on Board {
  /*
  Ra8 Nb8 Bc8 Qd8 Ke8 ...
  Pa7 Pb7 Pc7 Pd7 Pe8
  */
  String boardStateToString() {
    String boardString = "";
    List<String> columnNames = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        Piece? square = this[i][j];
        if (this[i][j] != null) {
          boardString += square!.pieceModel.piece.iccfNotation +
              columnNames[j] +
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

import 'package:flutter_chess/model/piece_position_model.dart';

import '../components/board/piece.dart';

typedef Board = List<List<Piece?>>;

const PiecePosition kInitialWhiteKingPosition = PiecePosition(7, 4);
const PiecePosition kInitialBlackKingPosition = PiecePosition(0, 4);

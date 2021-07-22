import 'package:flutter/material.dart';
import 'package:flutter_chess/config/colors.dart';
import 'package:flutter_chess/config/pieces.dart';

class PromotionDialog extends StatelessWidget {
  final PieceColor color;
  const PromotionDialog({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String lead = color == PieceColor.White ? 'white' : 'black';
    return AlertDialog(
      backgroundColor: Colors.transparent,
      content: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    ChessStyle.boardColors[lead]!),
              ),
              onPressed: () {
                Navigator.of(context).pop(Pieces.Knight);
              },
              icon: Image.asset('assets/$lead' + '_knight.png',
                  width: MediaQuery.of(context).size.width * 0.2),
              label: Container(),
            ),
            ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    ChessStyle.boardColors[lead]!),
              ),
              onPressed: () {
                Navigator.of(context).pop(Pieces.Bishop);
              },
              icon: Image.asset('assets/$lead' + '_bishop.png',
                  width: MediaQuery.of(context).size.width * 0.2),
              label: Container(),
            ),
            ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    ChessStyle.boardColors[lead]!),
              ),
              onPressed: () {
                Navigator.of(context).pop(Pieces.Castle);
              },
              icon: Image.asset('assets/$lead' + '_castle.png',
                  width: MediaQuery.of(context).size.width * 0.2),
              label: Container(),
            ),
            ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    ChessStyle.boardColors[lead]!),
              ),
              onPressed: () {
                Navigator.of(context).pop(Pieces.Queen);
              },
              icon: Image.asset('assets/$lead' + '_queen.png',
                  width: MediaQuery.of(context).size.width * 0.2),
              label: Container(),
            ),
          ],
        ),
      ),
    );
  }
}

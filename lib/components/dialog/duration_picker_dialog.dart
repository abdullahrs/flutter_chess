import 'package:flutter/material.dart';
import '../../style/chess_style.dart';

class DurationPickerDialog extends StatelessWidget {
  /// Returns match duration
  ///
  /// If return is empty list there is no time limit otherwise
  /// returns <int>[initialTime,increment]
  const DurationPickerDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ChessStyle.dialogBackgroundColor,
      content: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        color: ChessStyle.dialogBackgroundColor,
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: durationButtons(context),
        ),
      ),
    );
  }

  List<Widget> durationButtons(BuildContext context) {
    const int totalHorizontalDialogPadding = 48;
    List<Widget> buttons = [];
    List<List<int>> durations = [
      [1, 0],
      [2, 1],
      [3, 0],
      [3, 2],
      [5, 0],
      [5, 3],
      [10, 0],
      [10, 5],
      [15, 10],
      [],
    ];
    for (List<int> d in durations) {
      buttons.add(
        GestureDetector(
          onTap: () {
            onClickDuration(context, d);
          },
          child: Container(
            width: MediaQuery.of(context).size.width / 3 -
                totalHorizontalDialogPadding,
            height: MediaQuery.of(context).size.width / 4 -
                totalHorizontalDialogPadding,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: ChessStyle.dialogButtonBackgroundColor,
                border:
                    Border.all(width: 4, color: ChessStyle.pickerBorderColor)),
            child: Text(
              d.isNotEmpty ? "${d[0]}+${d[1]}" : "∞",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: ChessStyle.dialogTextColor, fontSize: 20),
            ),
          ),
        ),
      );
    }
    return buttons;
  }

  void onClickDuration(BuildContext context, List<int> d) {
    Navigator.of(context).pop(d);
  }
}

import 'package:flutter/material.dart';

class ResultDialog extends StatelessWidget {
  final String dialogText;
  final VoidCallback onClick;

  const ResultDialog(
      {Key? key, required this.dialogText, required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(dialogText, textAlign: TextAlign.center),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                onClick();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

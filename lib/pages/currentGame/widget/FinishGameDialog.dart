import 'package:flutter/material.dart';
import 'package:sample_sport_stats/AppFontStyle.dart';

import '../../../AppColors.dart';

class FinishGameDialog extends StatelessWidget {
  final Function callback;

  const FinishGameDialog({super.key, required this.callback});

  @override
  Widget build(BuildContext context) {
    Widget okButton = DialogBtn(
        callback: () {
          callback();
          Navigator.of(context).pop();
        },
        displayValue: "Oui");
    Widget cancelButton = DialogBtn(
      callback: () {
        Navigator.of(context).pop();
      },
      displayValue: "Annuler",
      color: Colors.red,
      splashColor: Colors.redAccent,
    );

    return AlertDialog(
      title: Text("Fin du match", style: AppFontStyle.anton),
      content: Text("Êtes-vous sûr de mettre fin au match ?",
          style: AppFontStyle.anton),
      actions: [
        cancelButton,
        okButton,
      ],
    );
  }
}

class DialogBtn extends StatelessWidget {
  final Function callback;
  final String displayValue;
  final Color color;
  final Color splashColor;
  final double fontSize = 11;

  const DialogBtn(
      {super.key,
      required this.callback,
      required this.displayValue,
      this.color = AppColors.orange,
      this.splashColor = Colors.orangeAccent});

  @override
  Widget build(BuildContext context) {
    return Material(
        color: color,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          splashColor: splashColor,
          onTap: () => callback(),
          child: SizedBox(
            width: 105,
            height: 45,
            child: Center(
              child: Text(displayValue,
                  textAlign: TextAlign.center,
                  style: AppFontStyle.anton
                      .copyWith(color: Colors.white, fontSize: fontSize)),
            ),
          ),
        ));
  }
}

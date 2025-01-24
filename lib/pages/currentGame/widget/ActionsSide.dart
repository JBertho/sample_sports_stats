import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sample_sport_stats/AppColors.dart';
import 'package:sample_sport_stats/AppFontStyle.dart';

import '../../../models/ActionGame.dart';
import '../../../widgets/ActionButton.dart';
import 'package:provider/provider.dart';

import '../logic/CurrentGameCubit.dart';
import '../model/ChronometerModel.dart';

class ActionsSide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Tir réussi"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.only(right: 6), child: ActionBtn(callback: () => log("+1"), displayValue: '+1', fontSize: 40,  color: AppColors.greenBtn)),
            Padding(padding: EdgeInsets.only(right: 6, left: 6), child: ActionBtn(callback: () => log("+2"), displayValue: '+2', fontSize: 40,  color: AppColors.greenBtn)),
            Padding(padding: EdgeInsets.only(left: 6), child: ActionBtn(callback: () => log("+3"), displayValue: '+3', fontSize: 40,  color: AppColors.greenBtn)),
          ],
        ),
        SizedBox(height: 15),
        Text("Tir raté"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.only(right: 6), child: ActionBtn(callback: () => log("+1"), displayValue: '1',fontSize: 40, color: Colors.red, splashColor: Colors.redAccent,)),
            Padding(padding: EdgeInsets.only(right: 6, left: 6), child: ActionBtn(callback: () => log("+2"), displayValue: '2', fontSize: 40, color: Colors.red, splashColor: Colors.redAccent)),
            Padding(padding: EdgeInsets.only(left: 6), child: ActionBtn(callback: () => log("+3"), displayValue: '3', fontSize: 40, color: Colors.red, splashColor: Colors.redAccent)),
          ],
        ),
        SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.only(right: 6), child: ActionBtn(callback: () => log("Rebond off"), displayValue: 'Rebond off',  color: AppColors.greenBtn)),
            Padding(padding: EdgeInsets.only(right: 6, left: 6), child: ActionBtn(callback: () => log("contre"), displayValue: 'contre',  color: AppColors.greenBtn)),
            Padding(padding: EdgeInsets.only(left: 6), child: ActionBtn(callback: () => log("Faute"), displayValue: 'Faute', color: Colors.red, splashColor: Colors.redAccent)),
          ],
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.only(right: 6), child: ActionBtn(callback: () => log("Rebond def"), displayValue: 'Rebond def',  color: AppColors.greenBtn)),
            Padding(padding: EdgeInsets.only(right: 6, left: 6), child: ActionBtn(callback: () => log("Interception"), displayValue: 'Interception',  color: AppColors.greenBtn)),
            Padding(padding: EdgeInsets.only(left: 6), child: ActionBtn(callback: () => log("Perte de balle"), displayValue: 'Perte de balle', color: Colors.red, splashColor: Colors.redAccent)),
          ],
        ),


      ],
    );
  }


  List<Widget> _buildActionRows(List<ActionGame> actions, BuildContext context,
      ActionGame? selectedActionGame) {
    List<Widget> rows = [];

    var firstColumn = actions.sublist(0, actions.length ~/ 2);
    var lastColumn = actions.sublist(actions.length ~/ 2, actions.length);
    rows.add(
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: firstColumn.map((action) {
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Actionbutton(
                text: action.name,
                color: selectedActionGame != action ? Colors.lime : Colors.pink,
                callback: () {
                  var  elapsedTime = Provider.of<ChronometerModel>(context, listen: false).elapsedTime;

                  context.read<CurrentGameCubit>().selectActionGame(action, elapsedTime);
                },
              ));
        }).toList(),
      ),
    );

    rows.add(
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: lastColumn.map((action) {
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Actionbutton(
                text: action.name,
                color: selectedActionGame != action ? Colors.lime : Colors.pink,
                callback: () {
                  var  elapsedTime = Provider.of<ChronometerModel>(context, listen: false).elapsedTime;

                  context.read<CurrentGameCubit>().selectActionGame(action, elapsedTime);
                },
              ));
        }).toList(),
      ),
    );

    return rows;
  }

}

class ActionBtn extends StatelessWidget {
  final Function callback;
  final String displayValue;
  final Color color;
  final Color splashColor;
  final double fontSize;

  const ActionBtn({super.key, required this.callback, required this.displayValue, this.color = Colors.green, this.splashColor = Colors.greenAccent, this.fontSize = 11});


  @override
  Widget build(BuildContext context) {
    return Material(
        color: color,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          splashColor: splashColor,
          onTap: () => callback,
          child: SizedBox(
            width: 70,
            height: 70,
            child: Center(
              child: Text(displayValue, textAlign: TextAlign.center, style: AppFontStyle.anton.copyWith(color: Colors.white, fontSize: fontSize)),
            ),
          ),
        ));
  }

}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample_sport_stats/AppColors.dart';
import 'package:sample_sport_stats/AppFontStyle.dart';

import '../../../models/ActionGame.dart';
import '../logic/CurrentGameCubit.dart';
import '../model/ChronometerModel.dart';

class ActionsSide extends StatelessWidget {
  final ActionGame? selectedActionGame;

  const ActionsSide({super.key, this.selectedActionGame});

  void selectAction(BuildContext context, ActionGame actionGame) {
    var elapsedTime =
        Provider.of<ChronometerModel>(context, listen: false).elapsedTime;

    context.read<CurrentGameCubit>().selectActionGame(actionGame, elapsedTime);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Tir réussi", style: AppFontStyle.anton),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ActionBtn(
                    callback: () => selectAction(context, ActionGame.freeThrow),
                    displayValue: '+1',
                    fontSize: 40,
                    color: selectedActionGame == ActionGame.freeThrow
                        ? AppColors.greenBtnSelected
                        : AppColors.greenBtn)),
            Padding(
                padding: const EdgeInsets.only(right: 6, left: 6),
                child: ActionBtn(
                    callback: () => selectAction(context, ActionGame.twoPoint),
                    displayValue: '+2',
                    fontSize: 40,
                    color: selectedActionGame == ActionGame.twoPoint
                        ? AppColors.greenBtnSelected
                        : AppColors.greenBtn)),
            Padding(
                padding: const EdgeInsets.only(left: 6),
                child: ActionBtn(
                    callback: () =>
                        selectAction(context, ActionGame.threePoint),
                    displayValue: '+3',
                    fontSize: 40,
                    color: selectedActionGame == ActionGame.threePoint
                        ? AppColors.greenBtnSelected
                        : AppColors.greenBtn)),
          ],
        ),
        const SizedBox(height: 15),
        Text("Tir raté", style: AppFontStyle.anton),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ActionBtn(
                  callback: () =>
                      selectAction(context, ActionGame.failedFreeThrow),
                  displayValue: '1',
                  fontSize: 40,
                  color: selectedActionGame == ActionGame.failedFreeThrow
                      ? AppColors.redBtnSelected
                      : AppColors.redBtn,
                  splashColor: Colors.redAccent,
                )),
            Padding(
                padding: const EdgeInsets.only(right: 6, left: 6),
                child: ActionBtn(
                    callback: () =>
                        selectAction(context, ActionGame.failedTwoPoint),
                    displayValue: '2',
                    fontSize: 40,
                    color: selectedActionGame == ActionGame.failedTwoPoint
                        ? AppColors.redBtnSelected
                        : AppColors.redBtn,
                    splashColor: Colors.redAccent)),
            Padding(
                padding: const EdgeInsets.only(left: 6),
                child: ActionBtn(
                    callback: () =>
                        selectAction(context, ActionGame.failedThreePoint),
                    displayValue: '3',
                    fontSize: 40,
                    color: selectedActionGame == ActionGame.failedThreePoint
                        ? AppColors.redBtnSelected
                        : AppColors.redBtn,
                    splashColor: Colors.redAccent)),
          ],
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ActionBtn(
                  callback: () => selectAction(context, ActionGame.reboundOff),
                  displayValue: 'Rebond off',
                  color: selectedActionGame == ActionGame.reboundOff
                      ? AppColors.greenBtnSelected
                      : AppColors.greenBtn,
                )),
            Padding(
                padding: const EdgeInsets.only(right: 6, left: 6),
                child: ActionBtn(
                    callback: () => selectAction(context, ActionGame.counter),
                    displayValue: 'contre',
                    color: selectedActionGame == ActionGame.counter
                        ? AppColors.greenBtnSelected
                        : AppColors.greenBtn)),
            Padding(
                padding: const EdgeInsets.only(left: 6),
                child: ActionBtn(
                    callback: () => selectAction(context, ActionGame.fault),
                    displayValue: 'Faute',
                    color: selectedActionGame == ActionGame.fault
                        ? AppColors.redBtnSelected
                        : AppColors.redBtn,
                    splashColor: Colors.redAccent)),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ActionBtn(
                    callback: () =>
                        selectAction(context, ActionGame.reboundDef),
                    displayValue: 'Rebond def',
                    color: selectedActionGame == ActionGame.reboundDef
                        ? AppColors.greenBtnSelected
                        : AppColors.greenBtn)),
            Padding(
                padding: const EdgeInsets.only(right: 6, left: 6),
                child: ActionBtn(
                    callback: () =>
                        selectAction(context, ActionGame.interception),
                    displayValue: 'Interception',
                    color: selectedActionGame == ActionGame.interception
                        ? AppColors.greenBtnSelected
                        : AppColors.greenBtn)),
            Padding(
                padding: const EdgeInsets.only(left: 6),
                child: ActionBtn(
                    callback: () => selectAction(context, ActionGame.turnover),
                    displayValue: 'Perte de balle',
                    color: selectedActionGame == ActionGame.turnover
                        ? AppColors.redBtnSelected
                        : AppColors.redBtn,
                    splashColor: Colors.redAccent)),
          ],
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ParameterBtn(callback: () {}, displayValue: "Stats"),
            const SizedBox(width: 15,),
            ParameterBtn(callback: () {
              context.read<CurrentGameCubit>().finishGameBtnPressed();
            }, displayValue: "Fin du match"),
          ],
        ),
        const SizedBox(height: 30)
      ],
    );
  }
}

class ActionBtn extends StatelessWidget {
  final Function callback;
  final String displayValue;
  final Color color;
  final Color splashColor;
  final double fontSize;

  const ActionBtn(
      {super.key,
      required this.callback,
      required this.displayValue,
      this.color = Colors.green,
      this.splashColor = Colors.greenAccent,
      this.fontSize = 11});

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
            width: 70,
            height: 70,
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

class ParameterBtn extends StatelessWidget {
  final Function callback;
  final String displayValue;
  final Color color = AppColors.orange;
  final Color splashColor = Colors.orangeAccent;
  final double fontSize  = 11;

  const ParameterBtn(
      {super.key,
        required this.callback,
        required this.displayValue});

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

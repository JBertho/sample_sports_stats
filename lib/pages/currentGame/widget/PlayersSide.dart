import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample_sport_stats/AppColors.dart';

import '../../../AppFontStyle.dart';
import '../../../models/MatchPlayer.dart';
import '../../../widgets/PlayerButton.dart';
import '../logic/CurrentGameCubit.dart';
import '../logic/CurrentGameState.dart';
import '../model/ChronometerModel.dart';

class PlayerSide extends StatelessWidget {
  final CurrentGameInProgress state;
  final List<MatchPlayer> teamPlayers;
  final MatchPlayer opponentPlayer;

  const PlayerSide(
      {super.key,
      required this.state,
      required this.teamPlayers,
      required this.opponentPlayer});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(flex: 60,child:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  "Votre équipe",
                  style: AppFontStyle.anton,
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: teamPlayers
                          .map((player) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: PlayerButton(
                                color: state.selectedPlayer != player
                                    ? AppColors.yellow
                                    : AppColors.yellowBtnSelected,
                                splashColor: Colors.yellowAccent,
                                playerName: player.name,
                                playerNumber: player.number,
                                callback: () {
                                  var elapsedTime =
                                      Provider.of<ChronometerModel>(context,
                                              listen: false)
                                          .elapsedTime;
                                  context
                                      .read<CurrentGameCubit>()
                                      .selectPlayer(player, elapsedTime);
                                },
                                faultNumber: player.fault,
                              )))
                          .toList()),
                )
              ],
            ),
            Column(
              children: [
                Text(
                  "Adversaire",
                  style: AppFontStyle.anton,
                ),
                const SizedBox(height: 10),
                OpponentBtn(
                    callback: () {
                      var elapsedTime =
                          Provider.of<ChronometerModel>(context, listen: false)
                              .elapsedTime;
                      context
                          .read<CurrentGameCubit>()
                          .selectPlayer(opponentPlayer, elapsedTime);
                    },
                    displayValue: opponentPlayer.name,
                    color: state.selectedPlayer != opponentPlayer
                        ? AppColors.darkBlueBtn
                        : AppColors.darkBlueBtnSelected,
                    splashColor: Colors.blueAccent),
              ],
            )
          ],
        ),),
        const Divider(indent: 40, endIndent: 40,),
        Flexible(flex: 30,child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Remplaçants",
              style: AppFontStyle.anton,
            ),
            Expanded(child:  GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 3,
              childAspectRatio: 160/45,
              children: state.substitutes.map((sub) {
                return PlayerButton(
                  color: state.selectedSubPlayer != sub
                      ? AppColors.yellow
                      : AppColors.yellowBtnSelected,
                  splashColor: Colors.yellowAccent,
                  playerName: sub.name,
                  playerNumber: sub.number,
                  callback: () {
                    var elapsedTime =
                        Provider.of<ChronometerModel>(context,
                            listen: false)
                            .elapsedTime;
                    context
                        .read<CurrentGameCubit>()
                        .selectSub(sub, elapsedTime);
                  },
                  faultNumber: sub.fault,
                  fontSize: 10,
                  height: 35,
                );
              }).toList(),
            ))
          ],
        ),)
      ],
    );
  }
}

class OpponentBtn extends StatelessWidget {
  final Function callback;
  final String displayValue;
  final Color color;
  final Color splashColor;
  final double fontSize;

  const OpponentBtn(
      {super.key,
      required this.callback,
      required this.displayValue,
      required this.color,
      required this.splashColor,
      this.fontSize = 14});

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
            width: 110,
            height: 90,
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

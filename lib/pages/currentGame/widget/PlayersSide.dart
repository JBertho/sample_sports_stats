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

  const PlayerSide({super.key, required this.state, required this.teamPlayers, required this.opponentPlayer});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text("Votre équipe", style: AppFontStyle.anton,),
            SizedBox(height: 10),
            Expanded(child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: teamPlayers
                    .map((player) =>
                    Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: PlayerButton(
                          color: state.selectedPlayer != player
                              ? AppColors.yellowBtn
                              : AppColors.yellowBtnSelected,
                          splashColor: Colors.yellowAccent,
                          playerName: player.name,
                          playerNumber: player.number,
                          callback: ()
                          {
                            var elapsedTime = Provider.of<ChronometerModel>(context, listen: false).elapsedTime;
                            context
                                .read<CurrentGameCubit>()
                                .selectPlayer(player, elapsedTime);
                          },

                        )))
                    .toList()),)

          ],
        ),
        Column(
          children: [
            Text("Adversaire", style: AppFontStyle.anton,),
            const SizedBox(height: 10),
            OpponentBtn(
                callback: () {
                  var  elapsedTime = Provider.of<ChronometerModel>(context, listen: false).elapsedTime;
                  context
                      .read<CurrentGameCubit>()
                      .selectOpponentPlayer(opponentPlayer, elapsedTime);
                },
                displayValue: opponentPlayer.name,
                color: state.selectedOpponentPlayer != opponentPlayer ? AppColors.darkBlueBtn : AppColors.darkBlueBtnSelected,
                splashColor: Colors.blueAccent),
          ],
        )
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

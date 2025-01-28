import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_sport_stats/AppColors.dart';
import 'package:sample_sport_stats/models/MatchPlayer.dart';
import 'package:sample_sport_stats/pages/currentGame/logic/CurrentGameCubit.dart';
import 'package:sample_sport_stats/pages/currentGame/logic/CurrentGameState.dart';
import 'package:sample_sport_stats/pages/currentGame/widget/ActionsSide.dart';
import 'package:sample_sport_stats/pages/currentGame/widget/GameHeader.dart';
import 'package:sample_sport_stats/pages/currentGame/widget/TimerAndHistory.dart';
import 'package:sample_sport_stats/widgets/PlayerButton.dart';
import 'package:provider/provider.dart';

import '../../models/Game.dart';
import 'model/ChronometerModel.dart';

class CurrentMatchPage extends StatelessWidget {
  final Game game;

  const CurrentMatchPage({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CurrentGameCubit>(
      create: (_) =>
      CurrentGameCubit()
        ..initGame(),
      child: _CurrentMatchPage(game: game),
    );
  }
}

class _CurrentMatchPage extends StatelessWidget {
  final Game game;

  const _CurrentMatchPage({required this.game});

  @override
  Widget build(BuildContext context) {
    var name = "NOM D'EQUIPE";
    var opponentName = game.opponentName;
    var teamPlayers = game.teamPlayers;
    var opponentsPlayers = game.opponentPlayers;

    return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(
          title: const Text("Match en cours"),
          backgroundColor: Colors.white,
        ),
        body: ChangeNotifierProvider(
            create: (_) => ChronometerModel(),
            // Fournir le modèle ChronometerModel
            child:
                  SafeArea(
                      child: BlocBuilder<CurrentGameCubit, CurrentGameState>(
                          builder: (context, state) {
                            var atHomeValue = game.atHome
                                ? 'à domicile'
                                : 'à l\'exterieur';
                            if (state is CurrentGameInProgress) {
                              return Column(children: [

                                Padding(padding: const EdgeInsets.only(top: 30),
                                    child: GameHeader(
                                        opponentName: opponentName,
                                        atHomeValue: atHomeValue,
                                        teamName: name,
                                        teamScore: game.teamScore,
                                        opponentScore: game.opponentScore)),

                                Expanded(
                                    child: CurrentGame(
                                        state: state,
                                        teamPlayers: teamPlayers,
                                        opponentPlayers: opponentsPlayers,
                                    ))
                              ]);
                            }
                            //TODO
                            return Container();
                          }))
                ));
  }
}

class CurrentGame extends StatelessWidget {
  final CurrentGameInProgress state;
  final List<MatchPlayer> teamPlayers;
  final List<MatchPlayer> opponentPlayers;

  const CurrentGame({super.key,
    required this.state,
    required this.teamPlayers,
    required this.opponentPlayers});

  @override
  Widget build(BuildContext context) {

    return Row(children: [
      Expanded(
          flex: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: teamPlayers
                      .map((player) =>
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: PlayerButton(
                            color: state.selectedPlayer != player
                                ? Colors.blue
                                : Colors.pink,
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
                      .toList()),
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: opponentPlayers
                      .map((player) =>
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: PlayerButton(
                            color: state.selectedPlayer != player
                                ? Colors.red
                                : Colors.pink,
                            playerName: player.name,
                            playerNumber: player.number,
                            callback: () {
                              var  elapsedTime = Provider.of<ChronometerModel>(context, listen: false).elapsedTime;

                              context
                                    .read<CurrentGameCubit>()
                                    .selectPlayer(player, elapsedTime);
                            }
                          )))
                      .toList()),
            ],
          )),
      Expanded(
        flex: 30,
        child: Padding(padding: const EdgeInsets.only(bottom: 20), child: TimerAndHistory(
            state: state)),
      ),
      Expanded(
          flex: 35,
          child: ActionsSide(selectedActionGame: state.selectedAction,))
    ]);
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sample_sport_stats/AppColors.dart';
import 'package:sample_sport_stats/models/MatchPlayer.dart';
import 'package:sample_sport_stats/pages/currentGame/logic/CurrentGameCubit.dart';
import 'package:sample_sport_stats/pages/currentGame/logic/CurrentGameState.dart';
import 'package:sample_sport_stats/pages/currentGame/widget/ActionsSide.dart';
import 'package:sample_sport_stats/pages/currentGame/widget/FinishGameDialog.dart';
import 'package:sample_sport_stats/pages/currentGame/widget/GameHeader.dart';
import 'package:sample_sport_stats/pages/currentGame/widget/PlayersSide.dart';
import 'package:sample_sport_stats/pages/currentGame/widget/TimerAndHistory.dart';

import '../../models/Game.dart';
import 'model/ChronometerModel.dart';

class CurrentMatchPage extends StatelessWidget {
  final Game game;

  const CurrentMatchPage({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CurrentGameCubit>(
      create: (_) => CurrentGameCubit()..initGame(game),
      child: const _CurrentMatchPage(),
    );
  }
}

class _CurrentMatchPage extends StatelessWidget {

  const _CurrentMatchPage();


  showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext _) {
        return FinishGameDialog(callback: () {
          context.read<CurrentGameCubit>().finishGame();
        },);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var name = "NOM D'EQUIPE";

    return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(
          title: const Text("Match en cours"),
          backgroundColor: Colors.white,
        ),
        body: ChangeNotifierProvider(
            create: (_) => ChronometerModel(),

            child: SafeArea(child:

                BlocListener<CurrentGameCubit, CurrentGameState>(listener: (listenerContext, state) {
                  if(state is CurrentGameAskToFinish) {
                    showAlertDialog(listenerContext);
                  }

                }, child: BlocBuilder<CurrentGameCubit, CurrentGameState>(
                    builder: (context, state) {
              var atHomeValue = state.atHome ? 'à domicile' : 'à l\'exterieur';
              if (state is CurrentGameInProgress) {
                return Column(children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: GameHeader(
                          opponentName: state.opponent.name,
                          atHomeValue: atHomeValue,
                          teamName: name,
                          teamScore: state.teamScore,
                          opponentScore: state.opponentScore)),
                  Expanded(
                      child: CurrentGame(
                          state: state,
                          teamPlayers: state.teamPlayers,
                          opponentPlayer: state.opponent))
                ]);
              }
              return Container();
            })))));
  }
}

class CurrentGame extends StatelessWidget {
  final CurrentGameInProgress state;
  final List<MatchPlayer> teamPlayers;
  final MatchPlayer opponentPlayer;

  const CurrentGame(
      {super.key,
      required this.state,
      required this.teamPlayers,
      required this.opponentPlayer});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          flex: 35,
          child: PlayerSide(
              state: state,
              teamPlayers: teamPlayers,
              opponentPlayer: opponentPlayer)),
      Expanded(
        flex: 30,
        child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: TimerAndHistory(state: state)),
      ),
      Expanded(
          flex: 35,
          child: ActionsSide(
            selectedActionGame: state.selectedAction,
          ))
    ]);
  }
}

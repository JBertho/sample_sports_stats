import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_sport_stats/AppColors.dart';
import 'package:sample_sport_stats/AppFontStyle.dart';
import 'package:sample_sport_stats/models/Game.dart';
import 'package:sample_sport_stats/pages/history/logic/HistoryCubit.dart';

import '../../router/routes.dart';
import 'logic/HistoriesCubit.dart';
import 'logic/HistoriesState.dart';

class HistoriesPage extends StatelessWidget {
  const HistoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _HistoriesPage();
  }
}

class _HistoriesPage extends StatelessWidget {

  void _historyTapped(BuildContext context, Game game) {
    context.read<HistoryCubit>().initHistory(game);
    context.push(Routes.nestedHistoryPage, extra: game);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.grey,
        body: SafeArea(
            child: BlocListener<HistoriesCubit, HistoriesState>(
                listener: (context, state) {
                  if(state is HistoryPressedState) {
                    _historyTapped(context, state.game);
                  }
                },
                child: BlocBuilder<HistoriesCubit, HistoriesState>(
                  builder: (context, state) {
                    if (state is HistoriesTeamState) {
                      return Hystories(state: state);
                    }

                    return Text("Liste vide");
                  },
                ))));
  }
}

class Hystories extends StatelessWidget {
  final HistoriesTeamState state;

  const Hystories({
    super.key,
    required this.state,
  });

  void _onHistoryTap(BuildContext context, Game history) {
    context.read<HistoriesCubit>().historyPressed(history);
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(bottom: 15, top: 15),
            child: Center(
                child: Text("Matchs joués", style: AppFontStyle.header))),
        const Divider(),
        Expanded(
            child: Center(
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    width: MediaQuery.of(context).size.width *
                        0.7, // 70% de la largeur de l'écran
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          var game = state.games[index];
                          return HistoryWidget(
                              game: game,
                              onTap: () => _onHistoryTap(context, game));
                        },
                        separatorBuilder: (_, idx) => Container(),
                        itemCount: state.games.length))))
      ],
    );
  }
}

class HistoryWidget extends StatelessWidget {
  final Game game;
  final VoidCallback onTap;

  const HistoryWidget({
    super.key,
    required this.game,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: Material(
            color: AppColors.white85,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
                borderRadius: BorderRadius.circular(10),
                splashColor: AppColors.orange,
                onTap: () {
                  onTap();
                },
                child: Container(
                    height: 40,
                    width: 400,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Row(
                          children: [
                            Container(
                              width: 150,
                              padding: EdgeInsets.only(left: 20),
                              child: Text("18 Oct. 2024",
                                  style: AppFontStyle.inter),
                            ),
                            Spacer(),
                            Padding(
                                padding: EdgeInsets.only(right: 30),
                                child: Text(
                                  game.team.name,
                                  style: AppFontStyle.inter,
                                )),
                          ],
                        )),
                        ScoreWidget(
                            teamScore: game.teamScore,
                            opponentScore: game.opponentScore),
                        Expanded(
                            child: Row(
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child: Text(game.opponentName,
                                    style: AppFontStyle.inter)),
                            Spacer(),
                            Padding(
                                padding: EdgeInsets.only(right: 30),
                                child: Icon(Icons.arrow_forward_sharp))
                          ],
                        ))
                      ],
                    )))));
  }
}

class ScoreWidget extends StatelessWidget {
  final int teamScore;
  final int opponentScore;

  const ScoreWidget(
      {super.key, required this.teamScore, required this.opponentScore});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: AppColors.yellow)),
          child: Row(
            children: [
              Container(
                width: 30,
                color: teamScore > opponentScore ? AppColors.yellow : null,
                child: Center(
                    child: Text("$teamScore", style: AppFontStyle.inter)),
              ),
              Container(
                color: opponentScore > teamScore ? AppColors.yellow : null,
                width: 30,
                child: Center(
                    child: Text("$opponentScore", style: AppFontStyle.inter)),
              ),
            ],
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_sport_stats/AppColors.dart';
import 'package:sample_sport_stats/AppFontStyle.dart';
import 'package:sample_sport_stats/models/Game.dart';
import 'package:sample_sport_stats/pages/history/logic/HistoryCubit.dart';
import 'package:sample_sport_stats/pages/history/logic/HistoryState.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _HistoryPage();
  }
}

class _HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(child: BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        if (state is HistoryTeamState) {
          return Hystories(state: state);
        }

        return Text("Liste vide");
      },
    )));
  }
}

class Hystories extends StatelessWidget {
  final HistoryTeamState state;

  const Hystories({
    super.key,
    required this.state,
  });

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
            child: ListView.separated(
                itemBuilder: (context, index) {
                  var game = state.games[index];
                  return HistoryWidget(game: game);
                },
                separatorBuilder: (_, idx) => const Divider(),
                itemCount: state.games.length))
      ],
    );
  }
}

class HistoryWidget extends StatelessWidget {
  const HistoryWidget({
    super.key,
    required this.game,
  });

  final Game game;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: Row(
          children: [
            const SizedBox(
              width: 150,
              child: Text("18 Oct. 2024"),
            ),
            const Spacer(),
            Text(game.team.name),
          ],
        )),
        ScoreWidget(
            teamScore: game.teamScore, opponentScore: game.opponentScore),
        Expanded(
            child: Row(
          children: [
            Text(game.opponentName),
            const Spacer(),
            const SizedBox(
              width: 150,
              child: Icon(Icons.arrow_forward_sharp),
            )
          ],
        ))
      ],
    );
  }
}

class ScoreWidget extends StatelessWidget {
  final int teamScore;
  final int opponentScore;

  const ScoreWidget(
      {super.key, required this.teamScore, required this.opponentScore});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: AppColors.yellow)),
      child: Row(
        children: [
          Container(
            width: 30,
            color: teamScore > opponentScore ? AppColors.yellow : null,
            child: Center(child: Text("$teamScore")),
          ),
          Container(
            child: Center(child: Text("$opponentScore")),
            color: opponentScore > teamScore ? AppColors.yellow : null,
            width: 30,
          ),
        ],
      ),
    );
  }
}

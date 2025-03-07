import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          return ListView.separated(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(state.games[index].opponentName),
                  subtitle: Text(
                      "${state.games[index].teamScore} - ${state.games[index].opponentScore}"),
                );
              },
              separatorBuilder: (_, idx) => const Divider(),
              itemCount: state.games.length);
        }

        return Text("Liste vide");
      },
    )));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_sport_stats/AppFontStyle.dart';
import 'package:sample_sport_stats/pages/history/widgets/DetailHistoryPage.dart';
import 'package:sample_sport_stats/pages/history/widgets/ShootsHistoryPage.dart';
import 'package:sample_sport_stats/pages/history/widgets/StatsHistoryPage.dart';

import '../../AppColors.dart';
import '../../models/Game.dart';
import 'logic/HistoryCubit.dart';
import 'logic/HistoryState.dart';

class HistoryPage extends StatelessWidget {
  final Game game;

  const HistoryPage({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        if (state is DisplayHistoryState) {
          return _HistoryPage(state: state);
        }

        return const Text("Historique non chargé");
      },
    );
  }
}

class _HistoryPage extends StatelessWidget {
  final DisplayHistoryState state;

  const _HistoryPage({required this.state});

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [
      DetailHistoryPage(state: state),
      StatsHistoryPage(state: state),
      ShootsHistoryPage(state: state)
    ];
    return DefaultTabController(
        length: tabs.length,
        child: Scaffold(
            backgroundColor: AppColors.grey,
            appBar: AppBar(
              title: Center(
                  child: Text(
                "Statistiques du match",
                style: AppFontStyle.header,
              )),
              bottom: TabBar(
                tabs: const [
                  Tab(text: "Résumé"),
                  Tab(text: "Stats"),
                  Tab(text: "Tirs")
                ],
                isScrollable: true,
                labelStyle: AppFontStyle.inter.copyWith(fontSize: 20),
                labelColor: AppColors.blue,
                indicatorColor: AppColors.orange,
              ),
            ),
            body: SafeArea(child: TabBarView(children: tabs))));
  }
}

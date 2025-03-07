import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_sport_stats/pages/TeamsSelection/logic/TeamsSelectionCubit.dart';
import 'package:sample_sport_stats/pages/history/logic/HistoryCubit.dart';

import 'models/Destination.dart';

class LayoutScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const LayoutScaffold({Key? key, required this.navigationShell})
      : super(key: key ?? const ValueKey("LayoutScaffold"));

  static const match = Destination(label: 'Match', icon: Icons.sports_basketball);
  static const historique = Destination(label: 'Historique', icon: Icons.format_list_bulleted_outlined);
  static const stats = Destination(label: 'Stats', icon: Icons.stacked_line_chart);
  static const destinations = [
    match,
    historique,
    stats,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (idx) {
          if(idx == LayoutScaffold.destinations.indexOf(historique)){
            var team = context.read<TeamSelectionCubit>().getTeam();
            context.read<HistoryCubit>().initHistory(team);
          }
          return navigationShell.goBranch(idx);
          },
        backgroundColor: Colors.white,
        destinations: destinations.map((destination) => NavigationDestination(
              icon: Icon(destination.icon),
              label: destination.label,
              selectedIcon: Icon(
                destination.icon,
                color: Colors.deepOrange,
              ),
            )).toList(),
      ),
    );
  }
}

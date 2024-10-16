import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'models/Destination.dart';

class LayoutScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const LayoutScaffold({Key? key, required this.navigationShell})
      : super(key: key ?? const ValueKey("LayoutScaffold"));

  static const destinations = [
    Destination(label: 'Match', icon: Icons.sports_basketball),
    Destination(label: 'Historique', icon: Icons.format_list_bulleted_outlined),
    Destination(label: 'Stats', icon: Icons.stacked_line_chart),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: navigationShell.goBranch,
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

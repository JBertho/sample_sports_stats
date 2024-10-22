import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_sport_stats/LayoutScaffold.dart';
import 'package:sample_sport_stats/models/Game.dart';
import 'package:sample_sport_stats/pages/CurrentMatchPage.dart';
import 'package:sample_sport_stats/pages/HistoryPage.dart';
import 'package:sample_sport_stats/pages/MatchPage.dart';
import 'package:sample_sport_stats/pages/StatsPage.dart';
import 'package:sample_sport_stats/router/routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.matchPage,
    routes: [
  StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => LayoutScaffold(
            navigationShell: navigationShell,
          ),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
              path: Routes.matchPage, builder: (context, state) => MatchPage(),
            routes: [
              GoRoute(path: Routes.currentMatchPage, builder: (context, state) => CurrentMatchpage(
                game: state.extra as Game,
              ))
            ])
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: Routes.historyPage,
              builder: (context, state) => Historypage())
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: Routes.statsPage, builder: (context, state) => StatsPage()
          ),
        ])
      ]),
]);

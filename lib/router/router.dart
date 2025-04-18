import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_sport_stats/LayoutScaffold.dart';
import 'package:sample_sport_stats/models/Game.dart';
import 'package:sample_sport_stats/pages/StatsPage.dart';
import 'package:sample_sport_stats/pages/TeamsSelection/TeamsSelectionPage.dart';
import 'package:sample_sport_stats/pages/currentGame/CurrentMatchPage.dart';
import 'package:sample_sport_stats/pages/histories/HistoriesPage.dart';
import 'package:sample_sport_stats/pages/history/History.dart';
import 'package:sample_sport_stats/pages/matchMenu/MatchPage.dart';
import 'package:sample_sport_stats/router/routes.dart';

import '../models/Team.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.teamsPage,
    routes: [
      GoRoute(
          path: Routes.teamsPage,
          builder: (context, state) => const TeamsSelectionPage()),
      StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) => LayoutScaffold(
                navigationShell: navigationShell,
              ),
          branches: [
            StatefulShellBranch(routes: [
              GoRoute(
                  path: Routes.matchPage,
                  builder: (context, state) => MatchPage(
                        team: state.extra as Team,
                      ),
                  routes: [
                    GoRoute(
                        path: Routes.currentMatchPage,
                        builder: (context, state) => CurrentMatchPage(
                              game: state.extra as Game,
                            ))
                  ])
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  path: Routes.historiesPage,
                  builder: (context, state) => const HistoriesPage(),
                  routes: [
                    GoRoute(
                        path: Routes.historyPage,
                        builder: (context, state) => HistoryPage(
                              game: state.extra as Game,
                            ))
                  ])
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  path: Routes.statsPage,
                  builder: (context, state) => StatsPage()),
            ])
          ]),
    ]);

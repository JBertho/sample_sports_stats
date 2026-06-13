import 'package:flutter/material.dart';
import 'package:sample_sport_stats/AppColors.dart';
import 'package:sample_sport_stats/AppFontStyle.dart';
import 'package:sample_sport_stats/infrastructure/DAO/player_dao.dart';
import 'package:sample_sport_stats/infrastructure/DAO/player_stats_dao.dart';
import 'package:sample_sport_stats/infrastructure/Entities/player_entity.dart';
import 'package:sample_sport_stats/infrastructure/Entities/player_stats_entity.dart';
import 'package:sample_sport_stats/pages/history/widgets/PlayerStatsCard.dart';

import '../logic/HistoryState.dart';

class StatsHistoryPage extends StatefulWidget {
  final DisplayHistoryState state;

  const StatsHistoryPage({super.key, required this.state});

  @override
  State<StatsHistoryPage> createState() => _StatsHistoryPageState();
}

class _StatsHistoryPageState extends State<StatsHistoryPage> {
  late final Future<List<dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = Future.wait([
      PlayerStatsDAO().getPlayerStatsByGameId(widget.state.game.id!),
      PlayerDAO().getPlayersByTeamId(widget.state.game.team.id!),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.blue),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: AppColors.redBtn, size: 48),
                const SizedBox(height: 16),
                Text('Erreur lors du chargement', style: AppFontStyle.teamHeader),
                const SizedBox(height: 8),
                Text(
                  snapshot.error.toString(),
                  style: const TextStyle(color: AppColors.fontGrey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final playerStats = snapshot.data![0] as List<PlayerStatsEntity>;
        final players = snapshot.data![1] as List<PlayerEntity>;

        if (playerStats.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.info_outline, color: AppColors.fontGrey, size: 48),
                const SizedBox(height: 16),
                Text('Aucune statistique disponible', style: AppFontStyle.teamHeader),
              ],
            ),
          );
        }

        playerStats.sort((a, b) => a.playerId.compareTo(b.playerId));

        final playerNames = <int, String>{
          for (final p in players) p.number: p.name,
        };

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                for (var i = 0; i < playerStats.length; i += 2)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildCard(playerStats[i], playerNames),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: i + 1 < playerStats.length
                              ? _buildCard(playerStats[i + 1], playerNames)
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard(PlayerStatsEntity stats, Map<int, String> playerNames) {
    final name = playerNames[stats.playerId] ?? 'Joueur #${stats.playerId}';
    return PlayerStatsCard(playerStats: stats, playerName: name);
  }
}

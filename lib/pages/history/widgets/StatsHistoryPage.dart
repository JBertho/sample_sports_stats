import 'package:flutter/material.dart';
import 'package:sample_sport_stats/AppColors.dart';
import 'package:sample_sport_stats/AppFontStyle.dart';
import 'package:sample_sport_stats/infrastructure/DAO/player_stats_dao.dart';
import 'package:sample_sport_stats/infrastructure/Entities/player_stats_entity.dart';
import 'package:sample_sport_stats/pages/history/widgets/PlayerStatsCard.dart';

import '../logic/HistoryState.dart';

class StatsHistoryPage extends StatelessWidget {
  final DisplayHistoryState state;

  const StatsHistoryPage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PlayerStatsDAO().getPlayerStatsByGameId(state.game.id!),
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
                Text(
                  'Erreur lors du chargement',
                  style: AppFontStyle.teamHeader,
                ),
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

        final playerStats = snapshot.data ?? [];

        if (playerStats.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.info_outline, color: AppColors.fontGrey, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Aucune statistique disponible',
                  style: AppFontStyle.teamHeader,
                ),
              ],
            ),
          );
        }

        // Trier les joueurs par numéro
        playerStats.sort((a, b) => a.playerId.compareTo(b.playerId));

        // Construire une map des joueurs pour récupérer les noms
        // Note: teamPlayers peut être vide pour les matchs historiques,
        // dans ce cas on affiche juste le numéro du joueur
        final playersMap = <int, String>{};
        for (var player in state.game.teamPlayers) {
          playersMap[player.number] = player.name;
        }

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
                          child: _buildCard(playerStats[i], playersMap),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: i + 1 < playerStats.length
                              ? _buildCard(playerStats[i + 1], playersMap)
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

  Widget _buildCard(PlayerStatsEntity stats, Map<int, String> playersMap) {
    final playerName = playersMap.containsKey(stats.playerId)
        ? playersMap[stats.playerId]!
        : 'Joueur #${stats.playerId}';
    return PlayerStatsCard(
      playerStats: stats,
      playerName: playerName,
    );
  }
}
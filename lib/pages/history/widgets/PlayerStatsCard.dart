import 'package:flutter/material.dart';
import 'package:sample_sport_stats/AppColors.dart';
import 'package:sample_sport_stats/AppFontStyle.dart';
import 'package:sample_sport_stats/infrastructure/Entities/player_stats_entity.dart';

class PlayerStatsCard extends StatelessWidget {
  final PlayerStatsEntity playerStats;
  final String playerName;

  const PlayerStatsCard({
    super.key,
    required this.playerStats,
    required this.playerName,
  });

  // Calcul du pourcentage de tir
  double _calculatePercentage(int successful, int failed) {
    int total = successful + failed;
    if (total == 0) return 0.0;
    return (successful / total) * 100;
  }

  // Formatage du pourcentage
  String _formatPercentage(double percentage) {
    return '${percentage.toStringAsFixed(0)}%';
  }

  // Couleur pour les stats (vert si bon, couleur thème sinon)
  Color _getStatColor(int value, int threshold) {
    return value >= threshold ? AppColors.greenBtn : AppColors.blue;
  }

  TextStyle get _sectionTitleStyle => const TextStyle(
        fontSize: 14,
        color: AppColors.blue,
        fontWeight: FontWeight.bold,
      );

  @override
  Widget build(BuildContext context) {
    final int totalRebounds = playerStats.reboundOff + playerStats.reboundDef;
    final double twoPointPercentage = _calculatePercentage(
      playerStats.successTwoPoint,
      playerStats.failedTwoPoint,
    );
    final double threePointPercentage = _calculatePercentage(
      playerStats.successThreePoint,
      playerStats.failedThreePoint,
    );
    final double freeThrowPercentage = _calculatePercentage(
      playerStats.successFreeThrow,
      playerStats.failedFreeThrow,
    );

    return Card(
      margin: EdgeInsets.zero,
      color: AppColors.white85,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header : Nom + Numéro + Score
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      playerName,
                      style: AppFontStyle.teamHeader,
                    ),
                    Text(
                      '#${playerStats.playerId}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.blue,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${playerStats.score} pts',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Grille 2x3 pour les différentes sections
            Row(
              children: [
                // Section Tirs
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tirs',
                        style: _sectionTitleStyle,
                      ),
                      const SizedBox(height: 6),
                      _buildStatRow('2PT', playerStats.successTwoPoint,
                          playerStats.failedTwoPoint, twoPointPercentage),
                      _buildStatRow('3PT', playerStats.successThreePoint,
                          playerStats.failedThreePoint, threePointPercentage),
                      _buildStatRow('LF', playerStats.successFreeThrow,
                          playerStats.failedFreeThrow, freeThrowPercentage),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Section Rebonds
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rebonds',
                        style: _sectionTitleStyle,
                      ),
                      const SizedBox(height: 6),
                      _buildSimpleStatRow('OFF', playerStats.reboundOff),
                      _buildSimpleStatRow('DEF', playerStats.reboundDef),
                      _buildSimpleStatRow('TOT', totalRebounds),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Section Défense & Fautes
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Défense',
                        style: _sectionTitleStyle,
                      ),
                      const SizedBox(height: 6),
                      _buildSimpleStatRow('CTR', playerStats.block),
                      _buildSimpleStatRow('INT', playerStats.interception),
                      _buildSimpleStatRow('FT', playerStats.counter),
                      const SizedBox(height: 6),
                      Text(
                        'Fautes',
                        style: _sectionTitleStyle,
                      ),
                      const SizedBox(height: 6),
                      _buildSimpleStatRow('FLT', playerStats.fault),
                      _buildSimpleStatRow('TO', playerStats.turnover),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(
    String label,
    int successful,
    int failed,
    double percentage,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w600),
          ),
          Text(
            '$successful/${successful + failed} ${_formatPercentage(percentage)}',
            style: TextStyle(
              fontSize: 12,
              color: _getStatColor(successful, 2),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleStatRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.blue, fontWeight: FontWeight.w600),
          ),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 12,
              color: _getStatColor(value, 0),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
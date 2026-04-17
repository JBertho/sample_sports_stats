import 'package:flutter/material.dart';
import 'package:sample_sport_stats/AppColors.dart';
import 'package:sample_sport_stats/AppFontStyle.dart';
import 'package:sample_sport_stats/infrastructure/DAO/shot_position_dao.dart';
import 'package:sample_sport_stats/infrastructure/Entities/shot_position_entity.dart';
import 'package:sample_sport_stats/models/ActionGame.dart';
import 'package:sample_sport_stats/pages/history/widgets/CourtShotsVisualization.dart';

import '../logic/HistoryState.dart';

class ShootsHistoryPage extends StatelessWidget {
  final DisplayHistoryState state;

  const ShootsHistoryPage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ShotPositionEntity>>(
      future: ShotPositionDAO().getShotPositionsByGameId(state.game.id!),
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
            child: Text(
              'Erreur : ${snapshot.error}',
              style: const TextStyle(color: AppColors.redBtn),
            ),
          );
        }

        final shots = snapshot.data ?? [];

        if (shots.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_off, color: AppColors.blue, size: 48),
                const SizedBox(height: 12),
                Text(
                  'Aucun tir enregistré avec position',
                  style: AppFontStyle.teamHeader,
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: CourtShotsVisualization(shots: shots),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Legend(),
                    const SizedBox(height: 16),
                    _Summary(shots: shots),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Legend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Légende', style: AppFontStyle.teamHeader),
        const SizedBox(height: 6),
        _legendRow(AppColors.greenBtn, '2pts / 3pts réussi'),
        _legendRow(AppColors.redBtn, '2pts / 3pts raté'),
        _legendRow(AppColors.darkBlueBtn, 'Lancer franc réussi'),
        _legendRow(AppColors.orange, 'Lancer franc raté'),
      ],
    );
  }

  Widget _legendRow(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.75),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.blue, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  final List<ShotPositionEntity> shots;

  const _Summary({required this.shots});

  @override
  Widget build(BuildContext context) {
    final twoMade = _count(ActionGame.twoPoint);
    final twoMissed = _count(ActionGame.failedTwoPoint);
    final threeMade = _count(ActionGame.threePoint);
    final threeMissed = _count(ActionGame.failedThreePoint);
    final ftMade = _count(ActionGame.freeThrow);
    final ftMissed = _count(ActionGame.failedFreeThrow);

    final totalMade = twoMade + threeMade + ftMade;
    final totalMissed = twoMissed + threeMissed + ftMissed;
    final total = totalMade + totalMissed;
    final pct = total == 0 ? 0 : (totalMade / total * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Résumé', style: AppFontStyle.teamHeader),
        const SizedBox(height: 6),
        _row('Total', '$totalMade/$total  ($pct%)'),
        _row('2pts', '$twoMade/${twoMade + twoMissed}'),
        _row('3pts', '$threeMade/${threeMade + threeMissed}'),
        _row('LF', '$ftMade/${ftMade + ftMissed}'),
      ],
    );
  }

  int _count(ActionGame action) =>
      shots.where((s) => s.actionType == action.name).length;

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.blue,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.blue,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

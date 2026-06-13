import 'package:flutter/material.dart';
import 'package:sample_sport_stats/AppColors.dart';
import 'package:sample_sport_stats/AppFontStyle.dart';
import 'package:sample_sport_stats/models/ActionGame.dart';
import 'package:sample_sport_stats/widgets/CourtBackground.dart';

class CourtShotSelector extends StatelessWidget {
  final ActionGame shotType;

  const CourtShotSelector({super.key, required this.shotType});

  /// Affiche le sélecteur et retourne un Offset relatif (0..1)
  /// ou null si l'utilisateur annule.
  static Future<Offset?> show(BuildContext context, ActionGame shotType) {
    return showDialog<Offset>(
      context: context,
      barrierDismissible: false,
      builder: (_) => CourtShotSelector(shotType: shotType),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: AppColors.bg,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Position du tir — ${shotType.name}',
              style: AppFontStyle.teamHeader,
            ),
            const SizedBox(height: 4),
            const Text(
              'Touchez le terrain pour indiquer la position du tir',
              style: TextStyle(color: AppColors.blue, fontSize: 12),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: CourtBackground(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final w = constraints.maxWidth;
                    final h = constraints.maxHeight;
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapDown: (details) {
                        final dx =
                            (details.localPosition.dx / w).clamp(0.0, 1.0);
                        final dy =
                            (details.localPosition.dy / h).clamp(0.0, 1.0);
                        Navigator.of(context).pop(Offset(dx, dy));
                      },
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Annuler',
                  style: TextStyle(color: AppColors.redBtn, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

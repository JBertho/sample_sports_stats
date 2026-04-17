import 'package:flutter/material.dart';
import 'package:sample_sport_stats/AppColors.dart';
import 'package:sample_sport_stats/AppFontStyle.dart';
import 'package:sample_sport_stats/models/ActionGame.dart';
import 'package:sample_sport_stats/widgets/CourtBackground.dart';

class CourtShotSelector extends StatefulWidget {
  final ActionGame shotType;

  const CourtShotSelector({super.key, required this.shotType});

  /// Affiche le selecteur et retourne un Offset relatif (0..1)
  /// ou null si l'utilisateur annule.
  static Future<Offset?> show(BuildContext context, ActionGame shotType) {
    return showDialog<Offset>(
      context: context,
      barrierDismissible: false,
      builder: (_) => CourtShotSelector(shotType: shotType),
    );
  }

  @override
  State<CourtShotSelector> createState() => _CourtShotSelectorState();
}

class _CourtShotSelectorState extends State<CourtShotSelector> {
  Offset? _relativePosition;

  bool get _isSuccess =>
      widget.shotType.type == ActionType.point;

  Color get _markerColor =>
      _isSuccess ? AppColors.greenBtn : AppColors.redBtn;

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
              'Position du tir - ${widget.shotType.name}',
              style: AppFontStyle.teamHeader,
            ),
            const SizedBox(height: 4),
            const Text(
              'Touchez le terrain pour indiquer où le tir a été pris',
              style: TextStyle(color: AppColors.blue, fontSize: 12),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return _buildCourt(constraints);
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Annuler',
                    style: TextStyle(color: AppColors.redBtn, fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _relativePosition == null
                      ? null
                      : () => Navigator.of(context).pop(_relativePosition),
                  child: const Text('Valider'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourt(BoxConstraints constraints) {
    return CourtBackground(
      child: LayoutBuilder(
        builder: (context, courtConstraints) {
          final width = courtConstraints.maxWidth;
          final height = courtConstraints.maxHeight;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (details) {
              final dx = details.localPosition.dx / width;
              final dy = details.localPosition.dy / height;
              setState(() {
                _relativePosition = Offset(
                  dx.clamp(0.0, 1.0),
                  dy.clamp(0.0, 1.0),
                );
              });
            },
            child: Stack(
              children: [
                if (_relativePosition != null)
                  Positioned(
                    left: _relativePosition!.dx * width - 14,
                    top: _relativePosition!.dy * height - 14,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: _markerColor.withValues(alpha: 0.7),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sample_sport_stats/AppColors.dart';
import 'package:sample_sport_stats/infrastructure/Entities/shot_position_entity.dart';
import 'package:sample_sport_stats/models/ActionGame.dart';
import 'package:sample_sport_stats/widgets/CourtBackground.dart';

class CourtShotsVisualization extends StatelessWidget {
  final List<ShotPositionEntity> shots;

  const CourtShotsVisualization({super.key, required this.shots});

  @override
  Widget build(BuildContext context) {
    return CourtBackground(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;
          return Stack(
            children: [
              for (final shot in shots) _buildMarker(shot, w, h),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMarker(ShotPositionEntity shot, double width, double height) {
    final action = shot.action;
    final size = _markerSize(action);
    return Positioned(
      left: shot.shotX * width - size / 2,
      top: shot.shotY * height - size / 2,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: _markerColor(action).withValues(alpha: 0.75),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1.5),
        ),
      ),
    );
  }

  static Color _markerColor(ActionGame action) {
    switch (action) {
      case ActionGame.twoPoint:
      case ActionGame.threePoint:
        return AppColors.greenBtn;
      case ActionGame.freeThrow:
        return AppColors.darkBlueBtn;
      case ActionGame.failedTwoPoint:
      case ActionGame.failedThreePoint:
        return AppColors.redBtn;
      case ActionGame.failedFreeThrow:
        return AppColors.orange;
      default:
        return AppColors.fontGrey;
    }
  }

  static double _markerSize(ActionGame action) {
    switch (action) {
      case ActionGame.threePoint:
      case ActionGame.failedThreePoint:
        return 24;
      case ActionGame.twoPoint:
      case ActionGame.failedTwoPoint:
        return 20;
      case ActionGame.freeThrow:
      case ActionGame.failedFreeThrow:
        return 16;
      default:
        return 16;
    }
  }
}

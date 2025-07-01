
// widgets/score_display.dart
import 'package:flutter/material.dart';
import '../utils/utils.dart';

class ScoreDisplay extends StatelessWidget {
  final int score;
  final int timeLeft;
  final String? extraInfo;

  const ScoreDisplay({
    Key? key,
    required this.score,
    required this.timeLeft,
    this.extraInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildScoreItem(
            icon: Icons.star,
            label: AppStrings.score,
            value: Helpers.formatNumber(score),
            color: AppColors.secondary,
          ),
          _buildScoreItem(
            icon: Icons.timer,
            label: AppStrings.timeLeft,
            value: Helpers.formatDuration(Duration(seconds: timeLeft)),
            color: AppColors.primary,
          ),
          if (extraInfo != null)
            _buildScoreItem(
              icon: Icons.info,
              label: 'Ekstra',
              value: extraInfo!,
              color: AppColors.accent,
            ),
        ],
      ),
    );
  }

  Widget _buildScoreItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.caption,
        ),
        Text(
          value,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

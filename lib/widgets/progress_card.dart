
// widgets/progress_card.dart
import 'package:flutter/material.dart';
import '../utils/utils.dart';

class ProgressCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int currentValue;
  final int totalValue;
  final String actionText;
  final VoidCallback? onActionPressed;

  const ProgressCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.currentValue,
    required this.totalValue,
    required this.actionText,
    this.onActionPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = totalValue > 0 ? currentValue / totalValue : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subtitle,
                style: AppTextStyles.bodySmall,
              ),
              TextButton(
                onPressed: onActionPressed,
                child: Text(
                  actionText,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '${currentValue}dk',
                style: AppTextStyles.heading3,
              ),
              Text(
                ' / ${totalValue}dk',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.accent,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),
            minHeight: 6,
          ),
        ],
      ),
    );
  }
}

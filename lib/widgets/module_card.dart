
// widgets/module_card.dart
import 'package:flutter/material.dart';
import '../utils/utils.dart';

class ModuleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isCompleted;
  final bool isLocked;

  const ModuleCard({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isCompleted = false,
    this.isLocked = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: isLocked ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: isLocked
                      ? Colors.grey.withOpacity(0.3)
                      : color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  isLocked ? Icons.lock : icon,
                  color: isLocked ? Colors.grey : color,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.cardTitle.copyWith(
                        color: isLocked ? Colors.grey : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: AppTextStyles.cardSubtitle.copyWith(
                        color: isLocked ? Colors.grey : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (isCompleted)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: AppColors.success,
                    size: 20,
                  ),
                )
              else if (!isLocked)
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textSecondary,
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
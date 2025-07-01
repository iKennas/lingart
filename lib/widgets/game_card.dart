
// widgets/game_card.dart
import 'package:flutter/material.dart';
import '../utils/utils.dart';

class GameCard extends StatelessWidget {
  final String content;
  final bool isFlipped;
  final bool isMatched;
  final VoidCallback onTap;
  final Color? backgroundColor;

  const GameCard({
    Key? key,
    required this.content,
    required this.isFlipped,
    required this.isMatched,
    required this.onTap,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isFlipped || isMatched ? null : onTap,
      child: AnimatedContainer(
        duration: AppConstants.shortAnimation,
        decoration: BoxDecoration(
          color: isMatched
              ? AppColors.success.withOpacity(0.8)
              : isFlipped
              ? backgroundColor ?? AppColors.accent
              : AppColors.primary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: isFlipped || isMatched
              ? Text(
            content,
            style: AppTextStyles.cardTitle.copyWith(
              color: isMatched ? Colors.white : AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          )
              : const Icon(
            Icons.help_outline,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}


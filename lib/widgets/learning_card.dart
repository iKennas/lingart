// widgets/learning_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_theme.dart';
import 'custom_button.dart';

enum CardType {
  standard,
  featured,
  compact,
  progress,
  achievement,
}

enum CardSize {
  small,
  medium,
  large,
  extraLarge,
}

class LearningCard extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String? description;
  final String buttonText;
  final Color? color;
  final Gradient? gradient;
  final IconData? icon;
  final Widget? customIcon;
  final VoidCallback onTap;
  final VoidCallback? onButtonPressed;
  final CardType type;
  final CardSize size;
  final double? progress;
  final bool isLocked;
  final bool isCompleted;
  final String? badge;
  final List<String>? tags;
  final String? timeEstimate;
  final int? difficulty;
  final Widget? trailing;
  final bool showShadow;
  final bool hapticFeedback;

  const LearningCard({
    Key? key,
    required this.title,
    this.subtitle,
    this.description,
    required this.buttonText,
    this.color,
    this.gradient,
    this.icon,
    this.customIcon,
    required this.onTap,
    this.onButtonPressed,
    this.type = CardType.standard,
    this.size = CardSize.medium,
    this.progress,
    this.isLocked = false,
    this.isCompleted = false,
    this.badge,
    this.tags,
    this.timeEstimate,
    this.difficulty,
    this.trailing,
    this.showShadow = true,
    this.hapticFeedback = true,
  }) : super(key: key);

  // Factory constructors for different card types
  factory LearningCard.featured({
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onTap,
    Gradient? gradient,
    IconData? icon,
    double? progress,
    String? timeEstimate,
  }) =>
      LearningCard(
        title: title,
        subtitle: subtitle,
        buttonText: buttonText,
        onTap: onTap,
        type: CardType.featured,
        size: CardSize.large,
        gradient: gradient ?? AppTheme.primaryGradient,
        icon: icon,
        progress: progress,
        timeEstimate: timeEstimate,
      );

  factory LearningCard.compact({
    required String title,
    required String buttonText,
    required VoidCallback onTap,
    Color? color,
    IconData? icon,
    bool isCompleted = false,
  }) =>
      LearningCard(
        title: title,
        buttonText: buttonText,
        onTap: onTap,
        type: CardType.compact,
        size: CardSize.small,
        color: color,
        icon: icon,
        isCompleted: isCompleted,
      );

  factory LearningCard.progress({
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onTap,
    required double progress,
    Color? color,
    IconData? icon,
    String? timeEstimate,
  }) =>
      LearningCard(
        title: title,
        subtitle: subtitle,
        buttonText: buttonText,
        onTap: onTap,
        type: CardType.progress,
        progress: progress,
        color: color,
        icon: icon,
        timeEstimate: timeEstimate,
      );

  factory LearningCard.achievement({
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onTap,
    String? badge,
    Color? color,
    IconData? icon,
  }) =>
      LearningCard(
        title: title,
        description: description,
        buttonText: buttonText,
        onTap: onTap,
        type: CardType.achievement,
        badge: badge,
        color: color,
        icon: icon,
      );

  @override
  State<LearningCard> createState() => _LearningCardState();
}

class _LearningCardState extends State<LearningCard>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _elevationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _elevationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _elevationAnimation = Tween<double>(
      begin: 1.0,
      end: 1.5,
    ).animate(CurvedAnimation(
      parent: _elevationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _elevationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _elevationAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: _buildCardByType(),
        );
      },
    );
  }

  Widget _buildCardByType() {
    switch (widget.type) {
      case CardType.featured:
        return _buildFeaturedCard();
      case CardType.compact:
        return _buildCompactCard();
      case CardType.progress:
        return _buildProgressCard();
      case CardType.achievement:
        return _buildAchievementCard();
      case CardType.standard:
      default:
        return _buildStandardCard();
    }
  }

  Widget _buildFeaturedCard() {
    final effectiveGradient = widget.gradient ?? AppTheme.primaryGradient;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacing20),
        decoration: BoxDecoration(
          gradient: widget.isLocked ? null : effectiveGradient,
          color: widget.isLocked ? AppTheme.lightGrey : null,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          boxShadow: widget.showShadow && !widget.isLocked
              ? AppTheme.primaryShadow.map((shadow) => BoxShadow(
            color: shadow.color,
            blurRadius: shadow.blurRadius * _elevationAnimation.value,
            offset: shadow.offset * _elevationAnimation.value,
          )).toList()
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (widget.icon != null)
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacing8),
                    decoration: BoxDecoration(
                      color: AppTheme.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    ),
                    child: Icon(
                      widget.icon,
                      color: widget.isLocked
                          ? AppTheme.mediumGrey
                          : AppTheme.white,
                      size: 24,
                    ),
                  ),
                const SizedBox(width: AppTheme.spacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: AppTheme.textTheme.headlineSmall?.copyWith(
                          color: widget.isLocked
                              ? AppTheme.mediumGrey
                              : AppTheme.white,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.subtitle != null) ...[
                        const SizedBox(height: AppTheme.spacing4),
                        Text(
                          widget.subtitle!,
                          style: AppTheme.textTheme.bodyMedium?.copyWith(
                            color: widget.isLocked
                                ? AppTheme.mediumGrey
                                : AppTheme.white.withOpacity(0.9),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                if (widget.badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacing8,
                      vertical: AppTheme.spacing4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    ),
                    child: Text(
                      widget.badge!,
                      style: AppTheme.textTheme.bodySmall?.copyWith(
                        color: widget.color ?? AppTheme.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            if (widget.progress != null) ...[
              const SizedBox(height: AppTheme.spacing16),
              _buildProgressIndicator(),
            ],
            if (widget.timeEstimate != null) ...[
              const SizedBox(height: AppTheme.spacing12),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: widget.isLocked
                        ? AppTheme.mediumGrey
                        : AppTheme.white.withOpacity(0.8),
                  ),
                  const SizedBox(width: AppTheme.spacing4),
                  Text(
                    widget.timeEstimate!,
                    style: AppTheme.textTheme.bodySmall?.copyWith(
                      color: widget.isLocked
                          ? AppTheme.mediumGrey
                          : AppTheme.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: AppTheme.spacing20),
            if (!widget.isLocked)
              CustomButton(
                text: widget.buttonText,
                onPressed: widget.onButtonPressed ?? widget.onTap,
                type: ButtonType.secondary,
                size: ButtonSize.medium,
                isFullWidth: true,
                backgroundColor: AppTheme.white,
                foregroundColor: widget.color ?? AppTheme.primaryBlue,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStandardCard() {
    final effectiveColor = widget.color ?? AppTheme.primaryBlue;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.all(_getPadding()),
        decoration: BoxDecoration(
          color: widget.isLocked ? AppTheme.lightGrey : AppTheme.white,
          borderRadius: BorderRadius.circular(_getBorderRadius()),
          boxShadow: widget.showShadow && !widget.isLocked
              ? AppTheme.cardShadow.map((shadow) => BoxShadow(
            color: shadow.color,
            blurRadius: shadow.blurRadius * _elevationAnimation.value,
            offset: shadow.offset * _elevationAnimation.value,
          )).toList()
              : null,
          border: Border.all(
            color: widget.isLocked
                ? AppTheme.borderGrey
                : effectiveColor.withOpacity(0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (widget.isCompleted)
                  Icon(
                    Icons.check_circle,
                    color: AppTheme.accentRed,
                    size: _getIconSize(),
                  )
                else if (widget.customIcon != null)
                  widget.customIcon!
                else if (widget.icon != null)
                    Container(
                      width: _getIconSize(),
                      height: _getIconSize(),
                      decoration: BoxDecoration(
                        color: effectiveColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                      ),
                      child: Icon(
                        widget.icon,
                        color: effectiveColor,
                        size: _getIconSize() * 0.6,
                      ),
                    ),
                const SizedBox(width: AppTheme.spacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: _getTitleStyle().copyWith(
                          color: widget.isLocked ? AppTheme.mediumGrey : AppTheme.darkGrey,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.subtitle != null) ...[
                        const SizedBox(height: AppTheme.spacing4),
                        Text(
                          widget.subtitle!,
                          style: AppTheme.textTheme.bodySmall?.copyWith(
                            color: widget.isLocked ? AppTheme.mediumGrey : AppTheme.mediumGrey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (widget.description != null) ...[
                        const SizedBox(height: AppTheme.spacing8),
                        Text(
                          widget.description!,
                          style: AppTheme.textTheme.bodySmall?.copyWith(
                            color: widget.isLocked ? AppTheme.mediumGrey : AppTheme.mediumGrey,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                if (widget.trailing != null) widget.trailing!,
              ],
            ),
            if (widget.progress != null) ...[
              const SizedBox(height: AppTheme.spacing12),
              _buildProgressIndicator(),
            ],
            if (widget.tags != null && widget.tags!.isNotEmpty) ...[
              const SizedBox(height: AppTheme.spacing12),
              _buildTags(),
            ],
            if (_shouldShowMetadata()) ...[
              const SizedBox(height: AppTheme.spacing12),
              _buildMetadata(),
            ],
            const SizedBox(height: AppTheme.spacing16),
            if (!widget.isLocked)
              CustomButton(
                text: widget.buttonText,
                onPressed: widget.onButtonPressed ?? widget.onTap,
                type: ButtonType.primary,
                size: _getButtonSize(),
                isFullWidth: true,
                backgroundColor: effectiveColor,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactCard() {
    final effectiveColor = widget.color ?? AppTheme.primaryBlue;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        decoration: BoxDecoration(
          color: widget.isLocked ? AppTheme.lightGrey : AppTheme.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          boxShadow: widget.showShadow && !widget.isLocked ? AppTheme.cardShadow : null,
          border: Border.all(
            color: widget.isLocked
                ? AppTheme.borderGrey
                : effectiveColor.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            if (widget.isCompleted)
              Icon(
                Icons.check_circle,
                color: AppTheme.accentRed,
                size: 24,
              )
            else if (widget.icon != null)
              Icon(
                widget.icon,
                color: widget.isLocked ? AppTheme.mediumGrey : effectiveColor,
                size: 24,
              ),
            const SizedBox(width: AppTheme.spacing12),
            Expanded(
              child: Text(
                widget.title,
                style: AppTheme.textTheme.titleMedium?.copyWith(
                  color: widget.isLocked ? AppTheme.mediumGrey : AppTheme.darkGrey,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: widget.isLocked ? AppTheme.mediumGrey : AppTheme.mediumGrey,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    final effectiveColor = widget.color ?? AppTheme.primaryBlue;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacing20),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          boxShadow: widget.showShadow ? AppTheme.cardShadow : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (widget.icon != null)
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacing8),
                    decoration: BoxDecoration(
                      color: effectiveColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    ),
                    child: Icon(
                      widget.icon,
                      color: effectiveColor,
                      size: 24,
                    ),
                  ),
                const SizedBox(width: AppTheme.spacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: AppTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.subtitle != null) ...[
                        const SizedBox(height: AppTheme.spacing4),
                        Text(
                          widget.subtitle!,
                          style: AppTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.mediumGrey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (widget.progress != null) ...[
              const SizedBox(height: AppTheme.spacing16),
              _buildProgressIndicator(),
            ],
            if (widget.timeEstimate != null) ...[
              const SizedBox(height: AppTheme.spacing12),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppTheme.mediumGrey,
                  ),
                  const SizedBox(width: AppTheme.spacing4),
                  Text(
                    widget.timeEstimate!,
                    style: AppTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.mediumGrey,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementCard() {
    final effectiveColor = widget.color ?? AppTheme.accentRed;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacing20),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          boxShadow: widget.showShadow ? AppTheme.accentShadow : null,
          border: Border.all(
            color: effectiveColor.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            if (widget.icon != null)
              Container(
                padding: const EdgeInsets.all(AppTheme.spacing16),
                decoration: BoxDecoration(
                  color: effectiveColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  color: effectiveColor,
                  size: 32,
                ),
              ),
            const SizedBox(height: AppTheme.spacing16),
            Text(
              widget.title,
              style: AppTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: effectiveColor,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (widget.description != null) ...[
              const SizedBox(height: AppTheme.spacing8),
              Text(
                widget.description!,
                style: AppTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.mediumGrey,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: AppTheme.spacing20),
            CustomButton(
              text: widget.buttonText,
              onPressed: widget.onButtonPressed ?? widget.onTap,
              type: ButtonType.accent,
              size: ButtonSize.medium,
              isFullWidth: true,
              backgroundColor: effectiveColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final effectiveColor = widget.color ?? AppTheme.primaryBlue;
    final progress = widget.progress ?? 0.0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'İlerleme',
              style: AppTheme.textTheme.bodySmall,
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: AppTheme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: effectiveColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacing8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppTheme.borderGrey,
          valueColor: AlwaysStoppedAnimation(effectiveColor),
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          minHeight: 6,
        ),
      ],
    );
  }

  Widget _buildTags() {
    return Wrap(
      spacing: AppTheme.spacing8,
      runSpacing: AppTheme.spacing4,
      children: widget.tags!.map((tag) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing8,
          vertical: AppTheme.spacing4,
        ),
        decoration: BoxDecoration(
          color: AppTheme.lightGrey,
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        ),
        child: Text(
          tag,
          style: AppTheme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildMetadata() {
    return Row(
      children: [
        if (widget.timeEstimate != null) ...[
          Icon(
            Icons.access_time,
            size: 16,
            color: AppTheme.mediumGrey,
          ),
          const SizedBox(width: AppTheme.spacing4),
          Text(
            widget.timeEstimate!,
            style: AppTheme.textTheme.bodySmall,
          ),
        ],
        if (widget.difficulty != null && widget.timeEstimate != null)
          const SizedBox(width: AppTheme.spacing16),
        if (widget.difficulty != null) ...[
          Icon(
            Icons.bar_chart,
            size: 16,
            color: AppTheme.mediumGrey,
          ),
          const SizedBox(width: AppTheme.spacing4),
          Row(
            children: List.generate(5, (index) => Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(right: 2),
              decoration: BoxDecoration(
                color: index < (widget.difficulty ?? 0)
                    ? AppTheme.primaryBlue
                    : AppTheme.borderGrey,
                shape: BoxShape.circle,
              ),
            )),
          ),
        ],
      ],
    );
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.hapticFeedback) {
      HapticFeedback.lightImpact();
    }
    _scaleController.forward();
    _elevationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _scaleController.reverse();
    _elevationController.reverse();
  }

  void _handleTapCancel() {
    _scaleController.reverse();
    _elevationController.reverse();
  }

  double _getPadding() {
    switch (widget.size) {
      case CardSize.small:
        return AppTheme.spacing12;
      case CardSize.medium:
        return AppTheme.spacing16;
      case CardSize.large:
        return AppTheme.spacing20;
      case CardSize.extraLarge:
        return AppTheme.spacing24;
    }
  }

  double _getBorderRadius() {
    switch (widget.size) {
      case CardSize.small:
        return AppTheme.radiusSmall;
      case CardSize.medium:
        return AppTheme.radiusMedium;
      case CardSize.large:
        return AppTheme.radiusLarge;
      case CardSize.extraLarge:
        return AppTheme.radiusXLarge;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case CardSize.small:
        return 32;
      case CardSize.medium:
        return 40;
      case CardSize.large:
        return 48;
      case CardSize.extraLarge:
        return 56;
    }
  }

  TextStyle _getTitleStyle() {
    switch (widget.size) {
      case CardSize.small:
        return AppTheme.textTheme.titleMedium ?? const TextStyle();
      case CardSize.medium:
        return AppTheme.textTheme.titleLarge ?? const TextStyle();
      case CardSize.large:
        return AppTheme.textTheme.headlineSmall ?? const TextStyle();
      case CardSize.extraLarge:
        return AppTheme.textTheme.headlineMedium ?? const TextStyle();
    }
  }

  ButtonSize _getButtonSize() {
    switch (widget.size) {
      case CardSize.small:
        return ButtonSize.small;
      case CardSize.medium:
        return ButtonSize.medium;
      case CardSize.large:
        return ButtonSize.large;
      case CardSize.extraLarge:
        return ButtonSize.extraLarge;
    }
  }

  bool _shouldShowMetadata() {
    return widget.timeEstimate != null || widget.difficulty != null;
  }
}
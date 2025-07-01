// widgets/custom_button.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_theme.dart';

enum ButtonType {
  primary,
  secondary,
  accent,
  outline,
  ghost,
  gradient,
}

enum ButtonSize {
  small,
  medium,
  large,
  extraLarge,
}

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonSize size;
  final Widget? icon;
  final Widget? suffixIcon;
  final bool isLoading;
  final bool isFullWidth;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final BorderSide? borderSide;
  final bool hapticFeedback;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.suffixIcon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.width,
    this.height,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.boxShadow,
    this.gradient,
    this.borderSide,
    this.hapticFeedback = true,
  }) : super(key: key);

  // Factory constructors for common button types
  factory CustomButton.primary({
    required String text,
    VoidCallback? onPressed,
    Widget? icon,
    Widget? suffixIcon,
    bool isLoading = false,
    bool isFullWidth = false,
    ButtonSize size = ButtonSize.medium,
  }) =>
      CustomButton(
        text: text,
        onPressed: onPressed,
        type: ButtonType.primary,
        size: size,
        icon: icon,
        suffixIcon: suffixIcon,
        isLoading: isLoading,
        isFullWidth: isFullWidth,
      );

  factory CustomButton.secondary({
    required String text,
    VoidCallback? onPressed,
    Widget? icon,
    Widget? suffixIcon,
    bool isLoading = false,
    bool isFullWidth = false,
    ButtonSize size = ButtonSize.medium,
  }) =>
      CustomButton(
        text: text,
        onPressed: onPressed,
        type: ButtonType.secondary,
        size: size,
        icon: icon,
        suffixIcon: suffixIcon,
        isLoading: isLoading,
        isFullWidth: isFullWidth,
      );

  factory CustomButton.accent({
    required String text,
    VoidCallback? onPressed,
    Widget? icon,
    Widget? suffixIcon,
    bool isLoading = false,
    bool isFullWidth = false,
    ButtonSize size = ButtonSize.medium,
  }) =>
      CustomButton(
        text: text,
        onPressed: onPressed,
        type: ButtonType.accent,
        size: size,
        icon: icon,
        suffixIcon: suffixIcon,
        isLoading: isLoading,
        isFullWidth: isFullWidth,
      );

  factory CustomButton.outline({
    required String text,
    VoidCallback? onPressed,
    Widget? icon,
    Widget? suffixIcon,
    bool isLoading = false,
    bool isFullWidth = false,
    ButtonSize size = ButtonSize.medium,
  }) =>
      CustomButton(
        text: text,
        onPressed: onPressed,
        type: ButtonType.outline,
        size: size,
        icon: icon,
        suffixIcon: suffixIcon,
        isLoading: isLoading,
        isFullWidth: isFullWidth,
      );

  factory CustomButton.ghost({
    required String text,
    VoidCallback? onPressed,
    Widget? icon,
    Widget? suffixIcon,
    bool isLoading = false,
    bool isFullWidth = false,
    ButtonSize size = ButtonSize.medium,
  }) =>
      CustomButton(
        text: text,
        onPressed: onPressed,
        type: ButtonType.ghost,
        size: size,
        icon: icon,
        suffixIcon: suffixIcon,
        isLoading: isLoading,
        isFullWidth: isFullWidth,
      );

  factory CustomButton.gradient({
    required String text,
    VoidCallback? onPressed,
    Widget? icon,
    Widget? suffixIcon,
    bool isLoading = false,
    bool isFullWidth = false,
    ButtonSize size = ButtonSize.medium,
    Gradient? gradient,
  }) =>
      CustomButton(
        text: text,
        onPressed: onPressed,
        type: ButtonType.gradient,
        size: size,
        icon: icon,
        suffixIcon: suffixIcon,
        isLoading: isLoading,
        isFullWidth: isFullWidth,
        gradient: gradient,
      );

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null;
    final buttonStyle = _getButtonStyle();

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: !isDisabled ? (_) => _onTapDown() : null,
            onTapUp: !isDisabled ? (_) => _onTapUp() : null,
            onTapCancel: !isDisabled ? () => _onTapCancel() : null,
            onTap: !isDisabled ? _onTap : null,
            child: AnimatedOpacity(
              opacity: isDisabled ? 0.6 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                width: widget.isFullWidth
                    ? double.infinity
                    : widget.width ?? _getButtonWidth(),
                height: widget.height ?? _getButtonHeight(),
                decoration: BoxDecoration(
                  color: buttonStyle.gradient == null
                      ? buttonStyle.backgroundColor
                      : null,
                  gradient: buttonStyle.gradient,
                  borderRadius:
                  BorderRadius.circular(widget.borderRadius ?? _getBorderRadius()),
                  boxShadow: isDisabled ? null : buttonStyle.boxShadow,
                  border: buttonStyle.border,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: !isDisabled ? _onTap : null,
                    borderRadius:
                    BorderRadius.circular(widget.borderRadius ?? _getBorderRadius()),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: _getHorizontalPadding(),
                        vertical: _getVerticalPadding(),
                      ),
                      child: Row(
                        mainAxisSize: widget.isFullWidth
                            ? MainAxisSize.max
                            : MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.icon != null && !widget.isLoading) ...[
                            widget.icon!,
                            SizedBox(width: _getIconSpacing()),
                          ],
                          if (widget.isLoading) ...[
                            SizedBox(
                              width: _getLoadingSize(),
                              height: _getLoadingSize(),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  isDisabled
                                      ? AppTheme.mediumGrey
                                      : buttonStyle.foregroundColor,
                                ),
                              ),
                            ),
                            SizedBox(width: _getIconSpacing()),
                          ],
                          Flexible(
                            child: Text(
                              widget.text,
                              style: _getTextStyle(buttonStyle, isDisabled),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (widget.suffixIcon != null && !widget.isLoading) ...[
                            SizedBox(width: _getIconSpacing()),
                            widget.suffixIcon!,
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  ButtonStyle _getButtonStyle() {
    switch (widget.type) {
      case ButtonType.primary:
        return ButtonStyle(
          backgroundColor: widget.backgroundColor ?? AppTheme.primaryBlue,
          foregroundColor: widget.foregroundColor ?? AppTheme.white,
          gradient: widget.gradient ?? AppTheme.primaryGradient,
          boxShadow: AppTheme.primaryShadow,
          border: widget.borderSide != null
              ? Border.all(
            color: widget.borderSide!.color,
            width: widget.borderSide!.width,
          )
              : null,
        );

      case ButtonType.secondary:
        return ButtonStyle(
          backgroundColor: widget.backgroundColor ?? AppTheme.lightGrey,
          foregroundColor: widget.foregroundColor ?? AppTheme.darkGrey,
          gradient: widget.gradient,
          boxShadow: AppTheme.cardShadow,
          border: widget.borderSide != null
              ? Border.all(
            color: widget.borderSide!.color,
            width: widget.borderSide!.width,
          )
              : Border.all(color: AppTheme.borderGrey),
        );

      case ButtonType.accent:
        return ButtonStyle(
          backgroundColor: widget.backgroundColor ?? AppTheme.accentRed,
          foregroundColor: widget.foregroundColor ?? AppTheme.white,
          gradient: widget.gradient ?? AppTheme.accentGradient,
          boxShadow: AppTheme.accentShadow,
          border: widget.borderSide != null
              ? Border.all(
            color: widget.borderSide!.color,
            width: widget.borderSide!.width,
          )
              : null,
        );

      case ButtonType.outline:
        return ButtonStyle(
          backgroundColor: widget.backgroundColor ?? Colors.transparent,
          foregroundColor: widget.foregroundColor ?? AppTheme.primaryBlue,
          gradient: widget.gradient,
          boxShadow: null,
          border: widget.borderSide != null
              ? Border.all(
            color: widget.borderSide!.color,
            width: widget.borderSide!.width,
          )
              : Border.all(color: AppTheme.primaryBlue, width: 2),
        );

      case ButtonType.ghost:
        return ButtonStyle(
          backgroundColor: widget.backgroundColor ?? Colors.transparent,
          foregroundColor: widget.foregroundColor ?? AppTheme.primaryBlue,
          gradient: widget.gradient,
          boxShadow: null,
          border: null,
        );

      case ButtonType.gradient:
        return ButtonStyle(
          backgroundColor: Colors.transparent,
          foregroundColor: widget.foregroundColor ?? AppTheme.white,
          gradient: widget.gradient ?? AppTheme.primaryGradient,
          boxShadow: AppTheme.primaryShadow,
          border: widget.borderSide != null
              ? Border.all(
            color: widget.borderSide!.color,
            width: widget.borderSide!.width,
          )
              : null,
        );
    }
  }

  void _onTapDown() {
    if (widget.hapticFeedback) {
      HapticFeedback.lightImpact();
    }
    setState(() {
      _isPressed = true;
    });
    _animationController.forward();
  }

  void _onTapUp() {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  void _onTap() {
    if (widget.onPressed != null) {
      widget.onPressed!();
    }
  }

  double _getButtonWidth() {
    switch (widget.size) {
      case ButtonSize.small:
        return 80;
      case ButtonSize.medium:
        return 120;
      case ButtonSize.large:
        return 160;
      case ButtonSize.extraLarge:
        return 200;
    }
  }

  double _getButtonHeight() {
    switch (widget.size) {
      case ButtonSize.small:
        return 32;
      case ButtonSize.medium:
        return 44;
      case ButtonSize.large:
        return 56;
      case ButtonSize.extraLarge:
        return 64;
    }
  }

  double _getBorderRadius() {
    switch (widget.size) {
      case ButtonSize.small:
        return AppTheme.radiusSmall;
      case ButtonSize.medium:
        return AppTheme.radiusMedium;
      case ButtonSize.large:
        return AppTheme.radiusMedium;
      case ButtonSize.extraLarge:
        return AppTheme.radiusLarge;
    }
  }

  double _getHorizontalPadding() {
    switch (widget.size) {
      case ButtonSize.small:
        return AppTheme.spacing12;
      case ButtonSize.medium:
        return AppTheme.spacing16;
      case ButtonSize.large:
        return AppTheme.spacing20;
      case ButtonSize.extraLarge:
        return AppTheme.spacing24;
    }
  }

  double _getVerticalPadding() {
    switch (widget.size) {
      case ButtonSize.small:
        return AppTheme.spacing8;
      case ButtonSize.medium:
        return AppTheme.spacing12;
      case ButtonSize.large:
        return AppTheme.spacing16;
      case ButtonSize.extraLarge:
        return AppTheme.spacing20;
    }
  }

  double _getIconSpacing() {
    switch (widget.size) {
      case ButtonSize.small:
        return AppTheme.spacing4;
      case ButtonSize.medium:
        return AppTheme.spacing8;
      case ButtonSize.large:
        return AppTheme.spacing8;
      case ButtonSize.extraLarge:
        return AppTheme.spacing12;
    }
  }

  double _getLoadingSize() {
    switch (widget.size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 20;
      case ButtonSize.large:
        return 24;
      case ButtonSize.extraLarge:
        return 28;
    }
  }

  TextStyle _getTextStyle(ButtonStyle buttonStyle, bool isDisabled) {
    final textColor = isDisabled
        ? AppTheme.mediumGrey
        : buttonStyle.foregroundColor;

    switch (widget.size) {
      case ButtonSize.small:
        return AppTheme.textTheme.bodySmall!.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        );
      case ButtonSize.medium:
        return AppTheme.textTheme.bodyMedium!.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        );
      case ButtonSize.large:
        return AppTheme.textTheme.bodyLarge!.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        );
      case ButtonSize.extraLarge:
        return AppTheme.textTheme.titleLarge!.copyWith(
          color: textColor,
          fontWeight: FontWeight.w700,
        );
    }
  }
}

class ButtonStyle {
  final Color backgroundColor;
  final Color foregroundColor;
  final Gradient? gradient;
  final List<BoxShadow>? boxShadow;
  final Border? border;

  ButtonStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    this.gradient,
    this.boxShadow,
    this.border,
  });
}
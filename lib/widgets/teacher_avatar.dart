
// widgets/teacher_avatar.dart
import 'package:flutter/material.dart';
import '../utils/utils.dart';

class TeacherAvatar extends StatefulWidget {
  final double size;
  final bool isAnimated;

  const TeacherAvatar({
    Key? key,
    this.size = 100,
    this.isAnimated = true,
  }) : super(key: key);

  @override
  State<TeacherAvatar> createState() => _TeacherAvatarState();
}

class _TeacherAvatarState extends State<TeacherAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    if (widget.isAnimated) {
      _controller = AnimationController(
        duration: const Duration(seconds: 2),
        vsync: this,
      );
      _animation = Tween<double>(begin: -5, end: 5).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    if (widget.isAnimated) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final avatar = Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: AppColors.accent,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary, width: 3),
      ),
      child: Icon(
        Icons.person,
        size: widget.size * 0.6,
        color: AppColors.primary,
      ),
    );

    if (!widget.isAnimated) return avatar;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: avatar,
        );
      },
    );
  }
}
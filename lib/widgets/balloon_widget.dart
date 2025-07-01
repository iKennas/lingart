
// widgets/balloon_widget.dart
import 'package:flutter/material.dart';
import '../utils/utils.dart';

class BalloonWidget extends StatefulWidget {
  final double x;
  final double y;
  final Color color;
  final bool isPopped;
  final VoidCallback onPop;
  final int points;

  const BalloonWidget({
    Key? key,
    required this.x,
    required this.y,
    required this.color,
    required this.isPopped,
    required this.onPop,
    required this.points,
  }) : super(key: key);

  @override
  State<BalloonWidget> createState() => _BalloonWidgetState();
}

class _BalloonWidgetState extends State<BalloonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: -50).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isPopped) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          left: widget.x,
          top: widget.y + _animation.value,
          child: GestureDetector(
            onTap: widget.onPop,
            child: Container(
              width: 50,
              height: 70,
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Text(
                  widget.points.toString(),
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}



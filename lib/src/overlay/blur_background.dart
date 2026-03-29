import 'dart:ui';
import 'package:flutter/material.dart';

/// Blurred, dimmed background shown behind the preview popup.
class BlurBackground extends StatelessWidget {
  final Animation<double> animation;
  final Color barrierColor;
  final VoidCallback onTap;

  const BlurBackground({
    super.key,
    required this.animation,
    required this.barrierColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return GestureDetector(
          onTap: onTap,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 8 * animation.value,
              sigmaY: 8 * animation.value,
            ),
            child: Container(
              color: barrierColor.withValues(
                alpha: barrierColor.a * animation.value,
              ),
            ),
          ),
        );
      },
    );
  }
}

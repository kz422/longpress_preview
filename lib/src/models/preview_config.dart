import 'package:flutter/material.dart';

/// A single action shown in the context menu below the preview popup.
class PreviewAction {
  /// Label displayed on the button.
  final String label;

  /// Optional leading icon.
  final IconData? icon;

  /// Whether this action should be styled as destructive (red text).
  final bool isDestructive;

  /// Called when the user taps this action.
  final VoidCallback onTap;

  const PreviewAction({
    required this.label,
    this.icon,
    this.isDestructive = false,
    required this.onTap,
  });
}

/// Controls the animation style of the preview popup.
enum PreviewAnimation {
  /// Scale up from the child widget's position (Safari-style).
  scaleFromChild,

  /// Slide up from the bottom of the screen (Instagram-style).
  slideFromBottom,

  /// Simple fade in.
  fadeIn,
}

/// Configuration for the preview popup appearance and behavior.
class PreviewConfig {
  /// Height of the preview popup.
  /// Defaults to 60% of screen height.
  final double? previewHeight;

  /// Width of the preview popup.
  /// Defaults to 90% of screen width.
  final double? previewWidth;

  /// Border radius of the preview popup.
  final double borderRadius;

  /// Background color of the preview popup.
  final Color backgroundColor;

  /// Color of the barrier behind the popup.
  final Color barrierColor;

  /// Duration of open/close animations.
  final Duration animationDuration;

  /// Animation style.
  final PreviewAnimation animation;

  /// Where to position the preview popup on screen.
  ///
  /// Defaults to [Alignment.center] (vertically and horizontally centred).
  /// Both the x and y components are respected, so values like
  /// [Alignment.topCenter] or [Alignment.bottomRight] work as expected.
  final Alignment alignment;

  /// Actions shown as a context menu below the preview popup.
  ///
  /// When non-empty the popup stays visible after the user releases the long
  /// press — it only closes when the user taps an action or the background
  /// barrier.
  final List<PreviewAction> actions;

  /// Whether to trigger haptic feedback on long press.
  final bool enableHaptics;

  /// Duration of long press before preview opens.
  final Duration longPressDuration;

  const PreviewConfig({
    this.previewHeight,
    this.previewWidth,
    this.borderRadius = 16.0,
    this.backgroundColor = Colors.white,
    this.barrierColor = const Color(0x88000000),
    this.animationDuration = const Duration(milliseconds: 220),
    this.animation = PreviewAnimation.scaleFromChild,
    this.alignment = Alignment.center,
    this.actions = const [],
    this.enableHaptics = true,
    this.longPressDuration = const Duration(milliseconds: 300),
  });
}

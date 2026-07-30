import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final double borderRadius;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final BoxBorder? border;
  final double? width;
  final double? height;

  const GlassCard({
    super.key,
    required this.child,
    this.blur = 12.0,
    this.opacity = 0.05,
    this.borderRadius = 20.0,
    this.color,
    this.padding,
    this.border,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: (color ?? Colors.white).withAlpha((255 * opacity).toInt()),
            borderRadius: BorderRadius.circular(borderRadius),
            border:
                border ??
                Border.all(
                  color: Colors.white.withAlpha((255 * 0.1).toInt()),
                  width: 1.5,
                ),
          ),
          child: child,
        ),
      ),
    );
  }
}

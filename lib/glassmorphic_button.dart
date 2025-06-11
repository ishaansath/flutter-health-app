import 'dart:ui';
import 'package:flutter/material.dart';

class GlassmorphicButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final double width;
  final double height;
  final double blur;
  final double borderRadius;
  final VoidCallback onPressed;
  final Color darkColor;
  final Color lightColor;

  const GlassmorphicButton({
    super.key,
    required this.text,
    this.icon,
    required this.onPressed,
    this.width = 160,
    this.height = 60,
    this.blur = 10,
    this.borderRadius = 20,
    required this.darkColor,
    required this.lightColor,

  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.15)
                  : Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.0001)
                    : Colors.white.withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? darkColor
                      : lightColor,
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null)
                    Icon(
                      icon,
                      color: colorScheme.onSecondary,
                      size: 20,
                    ),
                  if (icon != null) const SizedBox(width: 8),
                  Text(
                    text,
                    style: TextStyle(
                      color: colorScheme.onSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';

class FrostedGlassButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final double width;
  final double height;
  final double blur;
  final double borderRadius;
  final VoidCallback onPressed;

  const FrostedGlassButton({
    super.key,
    required this.text,
    this.icon,
    required this.onPressed,
    this.width = 170,
    this.height = 60,
    this.blur = 10,
    this.borderRadius = 20,

  });


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return LayoutBuilder(
        builder: (context, constraints) {
      final showIcon = constraints.maxWidth > 1 && icon != null;

    return GestureDetector(
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
          child: Container(
            width: width,
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.08)
                  : Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.12)
                    : Colors.black.withOpacity(0.15),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.4)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  spreadRadius: 1,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Center(
            child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: colorScheme.onSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (showIcon) const SizedBox(width: 6),
                if (showIcon)
                  Icon(
                    icon,
                    color: colorScheme.onSecondary,
                    size: 19,
                  ),
              ],
            ),
          ),
          ),
        )
      ),
    );
  });
  }}

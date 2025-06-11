import 'dart:ui';
import 'package:flutter/material.dart';

class FrostedGlassContainer extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final double blur; // Not directly used in the current filter, but kept as a property
  final double borderRadius; // Not directly used in ClipRRect, but kept as a property
  final EdgeInsets padding; // Not directly used in inner Container, but kept as a property

  const FrostedGlassContainer({
    super.key,
    required this.child,
    this.width = double.infinity,
    this.height = double.infinity,
    this.blur = 20, // This value is actually hardcoded in ImageFilter.blur
    this.borderRadius = 20, // This value is actually hardcoded in ClipRRect
    this.padding = const EdgeInsets.all(16), // This is hardcoded to 24, 14
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius), // Use the property here
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur), // Use the blur property here
        child: Container(
          width: width,
          height: height,
          padding: padding, // Use the padding property here
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(borderRadius), // Use the property here
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
          child: child, // The child is here
        ), // Missing closing parenthesis for Container
      ), // Missing closing parenthesis for BackdropFilter
    ); // Missing closing bracket for ClipRRect
  }
}
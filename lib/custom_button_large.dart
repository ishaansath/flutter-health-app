import 'package:flutter/material.dart';

class CustomButtonLarge extends StatelessWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final String text;
  final double? elevation;

  const CustomButtonLarge({
    super.key,
    required this.onPressed,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white, required this.text, this.elevation,
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 500,
      height: 80,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: elevation ?? 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        child: Text(
            text,
            style: theme.textTheme.titleLarge!
        ),
      ),
    );
  }
}

// lib/home_page.dart

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Import Lottie package
import 'package:ishaan/main.dart'; // To access themeModeNotifier

class HomePage extends StatefulWidget {
  final String mode; // Normal or Fun mode
  final ValueNotifier<ThemeMode> themeModeNotifier;

  const HomePage({
    super.key,
    required this.mode,
    required this.themeModeNotifier,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine Lottie animation based on theme (similar to SettingsPage)
    String welcomeLottiePath;
    if (widget.themeModeNotifier.value == ThemeMode.dark) {
      welcomeLottiePath = 'assets/animations/dark/welcome.json'; // Ensure you have this file
    } else {
      welcomeLottiePath = 'assets/animations/light/welcome.json'; // Ensure you have this file
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Welcome Lottie Animation
            Lottie.asset(
              welcomeLottiePath,
              height: 200,
              repeat: true, // Loop the animation
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            Text(
              'Welcome to Kokoro!',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onBackground,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              widget.mode == 'normal'
                  ? 'Explore the human body, learn about nutrition, and interact with your digital hero!'
                  : 'Hey there, awesome human! Get ready for some fun with your body, food, and your super cool hero!',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onBackground.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            // Example of additional content
            Card(
              color: colorScheme.surface,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Facts',
                      style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onSecondary),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Did you know the human brain weighs about 3 pounds but uses 20% of the body\'s oxygen and calories?',
                      style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSecondary.withOpacity(0.8)),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              color: colorScheme.surface,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Daily Goal',
                      style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onSecondary),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Remember to stay hydrated! Aim for 8 glasses of water today.',
                      style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSecondary.withOpacity(0.8)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

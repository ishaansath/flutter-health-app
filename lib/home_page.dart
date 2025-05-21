// home_page.dart
import 'package:flutter/material.dart';
import 'body_screen.dart'; // Ensure correct import

class HomePage extends StatelessWidget {
  // HomePage now receives the themeModeNotifier
  // It's crucial because BodyScreen, which it pushes, needs it.
  final ValueNotifier<ThemeMode> themeModeNotifier;

  const HomePage({super.key, required this.themeModeNotifier, required void Function(String mode) setMode});

  void showModeDialog(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: colorScheme.surface, // Use theme colorScheme.surface
        title: Text(
          "Select Interaction Mode",
          style: theme.textTheme.titleSmall,
          textAlign: TextAlign.center,
        ),
        content: Text(
          "", // Added some content
          style: theme.textTheme.bodySmall,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BodyScreen(
                    mode: 'normal',
                    themeModeNotifier: themeModeNotifier, // Pass the notifier here
                    setMode: (String mode) {}, // Placeholder for setMode, BodyScreen will handle its own state.
                  ),
                ),
              );
            },
            child: Text(
              "Normal Mode",
              style: TextStyle(color: colorScheme.tertiary, fontSize: 12), // Use theme colorScheme.primary
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BodyScreen(
                    mode: 'fun',
                    themeModeNotifier: themeModeNotifier, // Pass the notifier here
                    setMode: (String mode) {}, // Placeholder for setMode, BodyScreen will handle its own state.
                  ),
                ),
              );
            },
            child: Text(
              "Fun Mode",
              style: TextStyle(color: colorScheme.secondary, fontSize: 12), // Use theme colorScheme.secondary for fun mode button
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary, // Use theme colorScheme.background for Scaffold
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('assets/body_outline.png', height: 500, fit: BoxFit.fitHeight),
            Positioned(
              top: 200,
              child: ElevatedButton(
                // ElevatedButton's styleFrom should mostly align with ElevatedButtonThemeData in main.dart
                // If you want to override for this specific button, do so here.
                // Otherwise, you can remove styleFrom and it will use the theme default.
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.secondary, // Use theme colorScheme.primary
                  foregroundColor: colorScheme.onPrimary, // Use theme colorScheme.onPrimary for text
                ),
                onPressed: () => showModeDialog(context),
                child: Text(
                  "Let's Health",
                  style: theme.textTheme.labelLarge, // Use theme's labelLarge for button text
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
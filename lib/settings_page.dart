// lib/settings_page.dart
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary, // Or any color you prefer
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Settings',
          style: theme.textTheme.titleLarge,
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: colorScheme.onSecondary), // Back button color
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'This is your Settings Page!',
              style: theme.textTheme.headlineMedium?.copyWith(color: colorScheme.onPrimary),
            ),
            const SizedBox(height: 20),
            // You can add your actual settings options here
            // e.g., Theme toggle, About app, Privacy policy, etc.
          ],
        ),
      ),
    );
  }
}
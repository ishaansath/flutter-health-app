import 'package:flutter/material.dart';
import 'home_page.dart'; // This is now your Welcome/Initial screen
import 'body_screen.dart'; // Still need this import

void main() {
  runApp(const HealthApp());
}

class HealthApp extends StatefulWidget {
  const HealthApp({super.key});

  @override
  State<HealthApp> createState() => _HealthAppState();
}

class _HealthAppState extends State<HealthApp> {
  final ValueNotifier<ThemeMode> _themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);

  @override
  void dispose() {
    _themeModeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeModeNotifier,
      builder: (context, currentThemeMode, child) {
        return MaterialApp(
          title: 'Health App',
          debugShowCheckedModeBanner: false,

          // --- LIGHT THEME DEFINITION ---
          theme: ThemeData(
            brightness: Brightness.light,
            fontFamily: 'NotoSerif',
            colorScheme: ColorScheme.light(
              primary: Colors.white,
              onPrimary: Colors.blue.shade700,
              secondary: Colors.amber.shade700,
              onSecondary: Colors.black,
              surface: Colors.grey[200]!,
              onSurface: Colors.grey[100]!,
              error: Colors.red.shade700,
              onError: Colors.black,
              tertiary: Colors.cyan.shade400
            ),
            scaffoldBackgroundColor: Colors.white,
            dialogTheme: DialogTheme( // Preferred way to set dialog background
              backgroundColor: Colors.white,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black),
              titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.black, fontSize: 14),
              bodyMedium: TextStyle(color: Colors.black54, fontSize: 12),
              titleLarge: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
              titleMedium: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w500),
              labelLarge: TextStyle(color: Colors.black),
              titleSmall: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w300),
              bodySmall: TextStyle(color: Colors.black54, fontSize: 9, fontWeight: FontWeight.w200)
            ),
            cardTheme: CardTheme(
              color: Colors.grey[100],
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue.shade700,
              ),
            ),
            dividerTheme: const DividerThemeData(
              color: Colors.grey,
              thickness: 1,
            ),
          ),

          // --- DARK THEME DEFINITION ---
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            fontFamily: 'NotoSerif',
            colorScheme: ColorScheme.dark(
              primary: Colors.grey[900]!,
              onPrimary: Colors.white,
              secondary: Colors.cyanAccent.shade400,
              onSecondary: Colors.white,
              surface: Colors.grey[850]!,
              onSurface: Colors.grey[700]!,
              error: Colors.red.shade400,
              onError: Colors.orange,
              tertiary: Colors.amber.shade700,
            ),
            scaffoldBackgroundColor: Colors.grey.shade900,
            dialogTheme: DialogTheme( // Preferred way to set dialog background
              backgroundColor: Colors.grey[900],
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.white, fontSize: 14),
              bodyMedium: TextStyle(color: Colors.white70, fontSize: 12),
              titleLarge: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              titleMedium: TextStyle(color: Colors.white70, fontSize: 20, fontWeight: FontWeight.w500),
              labelLarge: TextStyle(color: Colors.white),
              bodySmall: TextStyle(color: Colors.white54, fontSize: 9, fontWeight: FontWeight.w200),
              titleSmall: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w300)
            ),
            cardTheme: CardTheme(
              color: Colors.grey[850],
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo.shade400,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.cyanAccent.shade400,
              ),
            ),
            dividerTheme: const DividerThemeData(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
          themeMode: currentThemeMode,
          // Now, main.dart's home is just HomePage (the welcome screen)
          home: HomePage(themeModeNotifier: _themeModeNotifier),
        );
      },
    );
  }
}
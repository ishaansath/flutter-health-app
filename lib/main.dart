import 'package:flutter/material.dart';
import 'home_page.dart'; // This is now your Welcome/Initial screen
import 'body_screen.dart'; // Still need this import

void main() {
  runApp(const HealthApp());
}

// --- FIX START: Define the extension for ColorScheme ---
// This extension adds your custom button colors as getters to ColorScheme.
extension CustomButtonColors on ColorScheme {
  // Define your custom button colors as getters.
  // These getters will return the specific color based on the current brightness (light/dark mode).
  // DO NOT define these inside the lightColorScheme/darkColorScheme constants.
  Color get buttonColor1 {
    // You might want to define separate hex codes for light and dark modes explicitly
    // or infer from the current brightness if you put the actual colors in a map.
    // For now, I'm using placeholder colors. Replace with your desired button colors.
    return brightness == Brightness.light ? const Color(0xFFFFE5B4) : const Color(0xFFADD8E6); // Light Blue / Cyan
  }
  Color get buttonColor2 {
    return brightness == Brightness.light ? const Color(0xFFFAC898) : const Color(0xFF89CFF0); // Deep Orange / Light Blue
  }
  Color get buttonColor3 {
    return brightness == Brightness.light ? const Color(0xFFFFBF00) : const Color(0xFF0096FF); // Green / Azure
  }
  Color get buttonColor4 {
    return brightness == Brightness.light ? const Color(0xFFCC5500) : const Color(0xFF0000FF); // Purple / Blue
  }
}
// --- FIX END ---


class HealthApp extends StatefulWidget {
  const HealthApp({super.key});

  @override
  State<HealthApp> createState() => _HealthAppState();
}

class _HealthAppState extends State<HealthApp> {
  final ValueNotifier<ThemeMode> _themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);
  String _currentMode = 'normal'; // Added to pass to HomePage if needed by its setMode

  // --- FIX START: Define a setMode function to pass to HomePage ---
  void _setMode(String mode) {
    setState(() {
      _currentMode = mode; // Update the mode state if HomePage needs to change it
    });
    // In a real app, if setMode from HomePage is meant to change themeMode,
    // you might update _themeModeNotifier here based on the mode.
    // For now, it just updates _currentMode.
  }
  // --- FIX END ---


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
            dialogTheme: const DialogTheme( // Preferred way to set dialog background
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
              // --- FIX START: REMOVE these buttonColor properties from here ---
              // buttonColor1: Color(0xFF00FFFF), // REMOVE
              // buttonColor2: Color(0xFF89CFF0), // REMOVE
              // buttonColor3: Color(0xFF0096FF), // REMOVE
              // buttonColor4: Color(0xFF0000FF)  // REMOVE
              // --- FIX END ---
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
          home: HomePage(
            themeModeNotifier: _themeModeNotifier,
            setMode: _setMode, // --- FIX: Pass the setMode function here ---
          ),
        );
      },
    );
  }
}
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:ishaan/body_screen.dart'; // Correctly import BodyScreen
import 'package:ishaan/app_data.dart'; // Ensure app_data.dart is imported

void main() {
  // Ensure Flutter services are initialized before calling runApp
  WidgetsFlutterBinding.ensureInitialized();
  // Call initializeAppData to populate your data structures
  initializeAppData();
  runApp(const HealthApp());
}

// This extension adds your custom button colors as getters to ColorScheme.
extension CustomButtonColors on ColorScheme {
  Color get buttonColor1 {
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


class HealthApp extends StatefulWidget {
  const HealthApp({super.key});

  @override
  State<HealthApp> createState() => _HealthAppState();
}

class _HealthAppState extends State<HealthApp> {
  // This ValueNotifier controls the overall app theme (light/dark)
  final ValueNotifier<ThemeMode> _themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);

  // --- REMOVED: _currentMode and _setMode from here ---
  // These were associated with HomePage, which is now deleted.
  // BodyScreen will manage its own 'normal'/'fun' mode internally.

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
          themeMode: currentThemeMode, // This controls the active theme

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
            dialogTheme: const DialogTheme(
              backgroundColor: Colors.white,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black, // Explicitly set foreground color for icons/text
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
                backgroundColor: Colors.amber.shade700,
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
            tabBarTheme: TabBarTheme(
              labelColor: Colors.black, // Color of the selected tab's text/icon
              unselectedLabelColor: Colors.black, // Color of unselected tab's text/icon
              indicatorSize: TabBarIndicatorSize.tab, // Makes indicator span the tab width
              indicator: UnderlineTabIndicator( // Customize the underline indicator
                borderSide: BorderSide(
                  color: Colors.amber.shade700, // Color of the underline indicator
                  width: 3.0, // Thickness of the underline
                ),
                insets: EdgeInsets.symmetric(horizontal: 16.0), // Padding for the underline
              ),
              labelStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
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
            dialogTheme: DialogTheme(
              backgroundColor: Colors.grey[900],
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white, // Explicitly set foreground color for icons/text
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
                backgroundColor: Colors.cyanAccent.shade400,
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
            tabBarTheme: TabBarTheme(
              labelColor: Colors.deepPurple, // Color of the selected tab's text/icon
              unselectedLabelColor: Colors.grey[600], // Color of unselected tab's text/icon
              indicatorSize: TabBarIndicatorSize.tab, // Makes indicator span the tab width
              indicator: UnderlineTabIndicator( // Customize the underline indicator
                borderSide: BorderSide(
                  color: Colors.cyanAccent.shade400, // Color of the underline indicator
                  width: 3.0, // Thickness of the underline
                ),
                insets: EdgeInsets.symmetric(horizontal: 16.0), // Padding for the underline
              ),
              labelStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          // --- FIX: Directly set home to BodyScreen and pass required parameters ---
          home: BodyScreen(
            mode: 'normal', // Set initial mode (e.g., 'normal' or 'fun')
            themeModeNotifier: _themeModeNotifier, // Pass the theme notifier
          ),
        );
      },
    );
  }
}
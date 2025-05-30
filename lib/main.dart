// lib/main.dart (MODIFIED FOR AUTHENTICATION FLOW)

import 'package:flutter/material.dart';
import 'package:ishaan/body_screen.dart'; // Correctly import BodyScreen
import 'package:ishaan/app_data.dart'; // Ensure app_data.dart is imported
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ishaan/firebase_options.dart'; // Assuming firebase_options.dart is directly in lib/
import 'package:ishaan/login_screen.dart'; // <--- NEW: Import your LoginScreen
import 'help_page.dart';

// NEW: Import provider package and your MascotProvider
import 'package:provider/provider.dart';
import 'package:ishaan/mascot_provider.dart'; // Make sure this path is correct

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // --- NEW: Initialize Firebase FIRST ---
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Ensure app_data is initialized after Firebase, if it depends on Firebase
  initializeAppData(); // Keep this if it's not Firebase-dependent, otherwise adjust order
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
  final ValueNotifier<ThemeMode> _themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);
  static const String _themeModeKey = 'appThemeMode'; // Key for SharedPreferences

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final String? themeModeString = prefs.getString(_themeModeKey);
    // final bool hasCompletedTour = prefs.getBool('hasCompletedTour') ?? false; // This line is not used here

    ThemeMode loadedMode;
    if (themeModeString == 'light') {
      loadedMode = ThemeMode.light;
    } else if (themeModeString == 'dark') {
      loadedMode = ThemeMode.dark;
    } else {
      loadedMode = ThemeMode.system; // Default to system if not found or invalid
    }

    _themeModeNotifier.value = loadedMode;
  }

  Future<void> _saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    String themeModeString;
    switch (mode) {
      case ThemeMode.light:
        themeModeString = 'light';
        break;
      case ThemeMode.dark:
        themeModeString = 'dark';
        break;
      case ThemeMode.system:
        themeModeString = 'system';
        break;
    }
    await prefs.setString(_themeModeKey, themeModeString);
  }

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
        // --- RE-ADD THE MULTIPROVIDER HERE ---
        return MultiProvider(
          providers: [
            // Add your MascotProvider
            ChangeNotifierProvider(create: (_) => MascotProvider()),
            // Add any other providers you might have or add in the future here
          ],
          child: MaterialApp(
            title: 'Health App',
            debugShowCheckedModeBanner: false,
            themeMode: currentThemeMode, // This controls the active theme

            // --- LIGHT THEME DEFINITION (NO CHANGES) ---
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
                  tertiary: Colors.cyan.shade400,
              ),
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.black,
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.black),
                titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Colors.black, fontSize: 14),
                headlineMedium: TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w400),
                bodyMedium: TextStyle(color: Colors.black54, fontSize: 12),
                titleLarge: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
                titleMedium: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
                labelLarge: TextStyle(color: Colors.black),
                titleSmall: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w300),
                bodySmall: TextStyle(color: Colors.black54, fontSize: 9, fontWeight: FontWeight.w200),
                displaySmall: TextStyle(color: Colors.black38, fontSize: 12, fontWeight: FontWeight.w300, fontStyle: FontStyle.italic),
                displayMedium: TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w400),
                displayLarge: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                headlineSmall: TextStyle(color: Colors.black38, fontSize: 10, fontWeight: FontWeight.w500),
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
            ),

            // --- DARK THEME DEFINITION (NO CHANGES) ---
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              fontFamily: 'NotoSerif',
              colorScheme: ColorScheme.dark(
                primary: Colors.grey[900]!,
                onPrimary: Colors.blue.shade300,
                secondary: Colors.cyanAccent.shade400,
                onSecondary: Colors.white,
                surface: Colors.grey[850]!,
                onSurface: Colors.grey[700]!,
                error: Colors.red.shade400,
                onError: Colors.orange,
                tertiary: Colors.amber.shade700,
              ),
              scaffoldBackgroundColor: Colors.grey.shade900,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.white),
                titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Colors.white, fontSize: 14),
                bodyMedium: TextStyle(color: Colors.white70, fontSize: 12),
                titleLarge: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                titleMedium: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                labelLarge: TextStyle(color: Colors.white),
                bodySmall: TextStyle(color: Colors.white54, fontSize: 9, fontWeight: FontWeight.w200),
                titleSmall: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w300),
                displaySmall: TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.w300, fontStyle: FontStyle.italic),
                displayMedium: TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.w400),
                displayLarge: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                headlineSmall: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w500),
                headlineMedium: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w400),
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
            ),
            // --- HOME WIDGET BASED ON AUTH STATE ---
            home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(), // Listen to authentication state changes
              builder: (context, snapshot) {
                // Show a loading indicator while checking authentication state
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(body: Center(child: CircularProgressIndicator()));
                }
                // If there's a user logged in, show BodyScreen
                if (snapshot.hasData && snapshot.data != null) {
                  print('User is logged in: ${snapshot.data!.email}');
                  return BodyScreen(
                    mode: 'normal', // Pass the mode you need
                    themeModeNotifier: _themeModeNotifier, // Pass the theme notifier
                  );
                }
                // If no user is logged in, show LoginScreen
                print('No user logged in. Redirecting to LoginScreen.');
                return LoginScreen(
                  themeModeNotifier: _themeModeNotifier, // You might need to pass this to your LoginScreen too
                );
              },
            ),
          ),
        );
      },
    );
  }
}
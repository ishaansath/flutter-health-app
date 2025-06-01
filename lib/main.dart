// lib/main.dart (MODIFIED FOR AUTHENTICATION FLOW AND FULL APP REFRESH)

import 'package:flutter/material.dart';
import 'package:ishaan/body_screen.dart'; // Correctly import BodyScreen
import 'package:ishaan/app_data.dart'; // Ensure app_data.dart is imported
import 'package:ishaan/shared_preferences_helper.dart'; // Keep if you use this elsewhere
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ishaan/firebase_options.dart'; // Assuming firebase_options.dart is directly in lib/
import 'package:ishaan/login_screen.dart'; // <--- NEW: Import your LoginScreen
import 'help_page.dart';

// NEW: Import provider package and your MascotProvider
import 'package:provider/provider.dart';
import 'package:ishaan/mascot_provider.dart'; // Make sure this path is correct

// NEW: ValueNotifier for theme mode
ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(ThemeMode.system);
// NEW: ValueNotifier for body model preference
ValueNotifier<String> bodyModelNotifier = ValueNotifier('human_body'); // 'male_body', 'female_body', 'human_body'
// NEW: ValueNotifier to trigger a full app refresh
ValueNotifier<int> appRefreshTriggerNotifier = ValueNotifier(0); // Increment this to trigger refresh

// NEW: Global ValueNotifiers for last visited items
ValueNotifier<Map<String, String>?> lastVisitedOrganNotifier = ValueNotifier(null);
ValueNotifier<Map<String, String>?> lastVisitedNutritionNotifier = ValueNotifier(null);


void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  // --- NEW: Initialize Firebase FIRST ---
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Ensure app_data is initialized after Firebase, if it depends on Firebase
  initializeAppData(); // Keep this if it's not Firebase-dependent, otherwise adjust order

  // Load saved theme preference
  final prefs = await SharedPreferences.getInstance();
  final String? savedThemeMode = prefs.getString('appThemeMode');
  if (savedThemeMode != null) {
    if (savedThemeMode == 'light') themeModeNotifier.value = ThemeMode.light;
    if (savedThemeMode == 'dark') themeModeNotifier.value = ThemeMode.dark;
    if (savedThemeMode == 'system') themeModeNotifier.value = ThemeMode.system;
  }

  // NEW: Load saved body model preference
  final String? savedBodyModel = prefs.getString('selectedBodyModel');
  if (savedBodyModel != null) {
    bodyModelNotifier.value = savedBodyModel;
  }

  // Load last visited organ and nutrition items on app start
  _loadLastVisitedOrganOnStart();
  _loadLastVisitedNutritionOnStart();


  runApp(const HealthApp());
}

// Function to save the last visited organ
Future<void> saveLastVisitedOrgan(String name, String imagePath) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('lastVisitedOrganName', name);
  await prefs.setString('lastVisitedOrganImagePath', imagePath);
  lastVisitedOrganNotifier.value = {'name': name, 'imagePath': imagePath};
  print('Saved last visited organ: $name');
}

// Function to save the last visited nutrition item (now handles two)
Future<void> saveLastVisitedNutrition(String name, String imagePath) async {
  final prefs = await SharedPreferences.getInstance();

  // Get current last two items
  String? name1 = prefs.getString('lastVisitedNutritionItemName1');
  String? path1 = prefs.getString('lastVisitedNutritionItemPath1');

  // Shift current item1 to item2, and new item becomes item1
  if (name1 != null && path1 != null) {
    await prefs.setString('lastVisitedNutritionItemName2', name1);
    await prefs.setString('lastVisitedNutritionItemPath2', path1);
  }

  // Set the new item as item1
  await prefs.setString('lastVisitedNutritionItemName1', name);
  await prefs.setString('lastVisitedNutritionItemPath1', imagePath);

  // Manually trigger the notifier to update HomePage
  _loadLastVisitedNutritionOnStart(); // Re-load to update the list in HomePage
  print('Saved last visited nutrition: $name');
}


// Helper to load last visited organ on app start
Future<void> _loadLastVisitedOrganOnStart() async {
  final prefs = await SharedPreferences.getInstance();
  final String? name = prefs.getString('lastVisitedOrganName');
  final String? path = prefs.getString('lastVisitedOrganImagePath');
  if (name != null && path != null) {
    lastVisitedOrganNotifier.value = {'name': name, 'imagePath': path};
  }
}

// Helper to load last visited nutrition items on app start
Future<void> _loadLastVisitedNutritionOnStart() async {
  final prefs = await SharedPreferences.getInstance();
  List<Map<String, String>> loadedItems = [];

  String? name1 = prefs.getString('lastVisitedNutritionItemName1');
  String? path1 = prefs.getString('lastVisitedNutritionItemPath1');
  if (name1 != null && path1 != null) {
    loadedItems.add({'name': name1, 'imagePath': path1});
  }

  String? name2 = prefs.getString('lastVisitedNutritionItemName2');
  String? path2 = prefs.getString('lastVisitedNutritionItemPath2');
  if (name2 != null && path2 != null) {
    loadedItems.add({'name': name2, 'imagePath': path2});
  }
  // This notifier now contains the list, but HomePage will read them individually.
  // We'll update the HomePage's listener to re-read from SharedPreferences when this notifier changes.
  // For simplicity, we just trigger the notifier if anything changes.
  // A better approach would be to pass the list directly, but to keep the current HomePage logic,
  // we just update the single `lastVisitedNutritionNotifier` with the latest item,
  // and the HomePage's `_updateLastVisitedNutritionItem` reloads both.
  if (loadedItems.isNotEmpty) {
    lastVisitedNutritionNotifier.value = loadedItems.first; // Trigger HomePage to reload both
  } else {
    lastVisitedNutritionNotifier.value = null;
  }
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
  // themeModeNotifier and bodyModelNotifier are now global, so no need to redeclare here
  static const String _themeModeKey = 'appThemeMode'; // Key for SharedPreferences

  // NEW: Key to force MaterialApp rebuild
  Key _appKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _loadThemeMode(); // This will update the global themeModeNotifier

    // Listen to bodyModelNotifier changes to force app rebuild
    bodyModelNotifier.addListener(_onBodyModelNotifierChanged);
    // NEW: Listen to appRefreshTriggerNotifier changes to force app rebuild
    appRefreshTriggerNotifier.addListener(_onAppRefreshTriggered);
  }

  @override
  void dispose() {
    // Remove listeners
    bodyModelNotifier.removeListener(_onBodyModelNotifierChanged);
    appRefreshTriggerNotifier.removeListener(_onAppRefreshTriggered); // NEW: Dispose listener
    super.dispose();
  }

  // Listener for bodyModelNotifier changes
  void _onBodyModelNotifierChanged() {
    print('main.dart: bodyModelNotifier changed to ${bodyModelNotifier.value}. Forcing app rebuild.');
    setState(() {
      _appKey = UniqueKey(); // Change the key to force MaterialApp rebuild
    });
  }

  // NEW: Listener for appRefreshTriggerNotifier changes
  void _onAppRefreshTriggered() {
    print('main.dart: appRefreshTriggerNotifier triggered. Forcing app rebuild.');
    setState(() {
      _appKey = UniqueKey(); // Change the key to force MaterialApp rebuild
    });
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final String? themeModeString = prefs.getString(_themeModeKey);

    ThemeMode loadedMode;
    if (themeModeString == 'light') {
      loadedMode = ThemeMode.light;
    } else if (themeModeString == 'dark') {
      loadedMode = ThemeMode.dark;
    } else {
      loadedMode = ThemeMode.system; // Default to system if not found or invalid
    }

    themeModeNotifier.value = loadedMode; // Update the global notifier
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
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier, // Use the global notifier
      builder: (context, currentThemeMode, child) {
        // --- RE-ADD THE MULTIPROVIDER HERE ---
        return MultiProvider(
          providers: [
            // Add your MascotProvider
            ChangeNotifierProvider(create: (_) => MascotProvider()),
            // Add any other providers you might have or in the future here
          ],
          child: MaterialApp(
            key: _appKey, // NEW: Assign the dynamic key here to force rebuild
            title: 'Kokoro',
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
                onError: Color(0xFFFFE5B4),
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
                displayMedium: TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.w400),
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
                onError:Color(0xFFFFE5B4),
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
                    themeModeNotifier: themeModeNotifier, // Pass the theme notifier
                    bodyModelNotifier: bodyModelNotifier,
                    lastVisitedOrganNotifier: lastVisitedOrganNotifier, // PASSED: lastVisitedOrganNotifier
                    lastVisitedNutritionNotifier: lastVisitedNutritionNotifier, // PASSED: lastVisitedNutritionNotifier
                  );
                }
                // If no user is logged in, show LoginScreen
                print('No user logged in. Redirecting to LoginScreen.');
                return LoginScreen(
                  themeModeNotifier: themeModeNotifier, // You might need to pass this to your LoginScreen too
                );
              },
            ),
          ),
        );
      },
    );
  }
}
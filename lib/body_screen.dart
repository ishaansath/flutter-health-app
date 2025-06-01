// lib/body_screen.dart (MODIFIED - Last Visited Organ Save)

import 'package:flutter/material.dart';
import 'package:ishaan/organ_detail_page.dart';
import 'package:ishaan/mascot_page.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ishaan/nutrition_tab_content.dart';
import 'package:ishaan/settings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:ionicons/ionicons.dart'; // Import Ion Icons
import 'package:ishaan/home_page.dart'; // NEW: Import HomePage

import 'app_data.dart' as AppData;
import 'package:ishaan/main.dart' hide saveLastVisitedOrgan; // Import main.dart to access global notifiers
import 'package:ishaan/shared_preferences_helper.dart' hide lastVisitedNutritionNotifier; // NEW: Import the helper


class BodyScreen extends StatefulWidget {
  final String mode;
  final ValueNotifier<ThemeMode> themeModeNotifier;
  final ValueNotifier<String> bodyModelNotifier;

  // NEW: Receive notifiers for recently visited items
  final ValueNotifier<Map<String, String>?> lastVisitedOrganNotifier;
  final ValueNotifier<Map<String, String>?> lastVisitedNutritionNotifier;


  const BodyScreen({
    super.key,
    required this.mode,
    required this.themeModeNotifier,
    required this.bodyModelNotifier,
    // NEW: Add to constructor
    required this.lastVisitedOrganNotifier,
    required this.lastVisitedNutritionNotifier,
  });

  @override
  State<BodyScreen> createState() => _BodyScreenState();
}

class _BodyScreenState extends State<BodyScreen> with SingleTickerProviderStateMixin {
  late String _currentMode;
  late TabController _tabController;
  late FlutterTts flutterTts;

  // NEW: Reordered tabs - 'Body' is now last
  final List<String> _topTabs = ['Home', 'Nutrition', 'Mascot', 'Body'];

  int _selectedIndex = 0;

  // IMPORTANT: You MUST have these files:
  // 'assets/models/male_body.glb'
  // 'assets/models/female_body.glb'
  // in your project's assets folder, and ensure they are declared in pubspec.yaml.
  // If these files are missing, the app will crash or the model won't load.

  @override
  void initState() {
    super.initState();
    _currentMode = widget.mode;
    // Adjusted TabController length for the new 'Home' tab
    _tabController = TabController(length: _topTabs.length, vsync: this);
    flutterTts = FlutterTts();
    _initializeTtsGeneral();

    _tabController.addListener(() {
      if (_selectedIndex != _tabController.index) {
        setState(() {
          _selectedIndex = _tabController.index;
        });
        flutterTts.stop();
      }
    });

    _selectedIndex = _tabController.index;
  }

  @override
  void dispose() {
    _tabController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  // Helper to get the model path based on the key
  String _getBodyModelPath(String modelKey) {
    String path;
    switch (modelKey) {
      case 'female_body':
        path = 'assets/models/female_body.glb';
        break;
      case 'male_body': // Explicitly handle male_body
      default: // Default to male_body if not female or unrecognized
        path = 'assets/models/male_body.glb';
        break;
    }
    print('BodyScreen: _getBodyModelPath called with "$modelKey", returning path: "$path"');
    return path;
  }

  // Helper to get the camera orbit string based on the model key
  String _getCameraOrbit(String modelKey) {
    return '0deg 90deg auto'; // Keeping a standard orbit
  }

  // Helper: To get the camera target based on the model key
  String _getCameraTarget(String modelKey) {
    switch (modelKey) {
      case 'male_body':
        return '0.1m auto auto'; // Shift 0.1 meters to the right
      case 'female_body':
        return 'auto auto auto'; // Shift 0.1 meters down
      default:
        return '0m 0m 0m'; // Default target (center)
    }
  }


  void _navigateToSettingsPage() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SettingsPage(
          themeModeNotifier: widget.themeModeNotifier,
          bodyModelNotifier: widget.bodyModelNotifier, // Pass bodyModelNotifier
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition( // Changed to FadeTransition for smoother transition
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  Future<void> _initializeTtsGeneral() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    print("BodyScreen TTS initialized.");
  }

  void _toggleMode() {
    setState(() {
      _currentMode = _currentMode == 'normal' ? 'fun' : 'normal';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: kToolbarHeight,
        title: const Text(''),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: _toggleMode,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: _currentMode == 'normal' ? colorScheme.tertiary : colorScheme.secondary,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _currentMode == 'normal' ? Icons.school : Icons.mood_rounded,
                      color: _currentMode == 'normal' ? colorScheme.onSecondary : colorScheme.onSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _currentMode == 'normal' ? 'Normal' : 'Fun',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: _currentMode == 'normal' ? colorScheme.onSecondary : colorScheme.onSecondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: _navigateToSettingsPage,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.secondary,
                    width: 2.0,
                  ),
                ),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: colorScheme.surface,
                  backgroundImage: currentUser?.photoURL != null
                      ? NetworkImage(currentUser!.photoURL!)
                      : null,
                  child: currentUser?.photoURL == null
                      ? Icon(
                    Icons.person,
                    color: colorScheme.primary,
                    size: 25,
                  )
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // NEW: Home Tab Content
          HomePage(
            mode: _currentMode,
            themeModeNotifier: widget.themeModeNotifier,
            lastVisitedOrganNotifier: widget.lastVisitedOrganNotifier, // Pass notifier
            lastVisitedNutritionNotifier: widget.lastVisitedNutritionNotifier, // Pass notifier
          ),
          // Nutrition Tab Content
          NutritionTabContent(currentMode: _currentMode, themeModeNotifier: widget.themeModeNotifier, lastVisitedNutritionNotifier: lastVisitedNutritionNotifier),
          // Mascot Tab Content
          MascotPage(mode: _currentMode),
          // Body Tab Content (Model Viewer and Organ Overlays) - NOW LAST
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.7,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // ValueListenableBuilder to dynamically update ModelViewer's src AND cameraOrbit
                  ValueListenableBuilder<String>(
                    valueListenable: widget.bodyModelNotifier,
                    builder: (context, currentModelKey, child) {
                      print('BodyScreen: ValueListenableBuilder rebuilding. Current model key: "$currentModelKey"');
                      return ModelViewer(
                        src: _getBodyModelPath(currentModelKey), // Get path from notifier's value
                        alt: "A 3D model of a human body",
                        ar: false,
                        disableZoom: true,
                        disableTap: true,
                        disablePan: true,
                        autoRotate: true,
                        cameraControls: true,
                        cameraOrbit: _getCameraOrbit(currentModelKey), // Dynamically set camera orbit
                        cameraTarget: _getCameraTarget(currentModelKey), // Dynamically set camera target
                        minCameraOrbit: 'auto 90deg auto',
                        maxCameraOrbit: 'auto 90deg auto',
                        backgroundColor: Colors.transparent,
                      );
                    },
                  ),

                  // Organ overlays with rounded box backgrounds
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.001,
                    right: MediaQuery.of(context).size.height * 0.0565,
                    child: GestureDetector(
                      onTap: () => showOrganDialog(context, "Brain"),
                      child: Container( // NEW: Container for background
                        padding: const EdgeInsets.all(8), // Add some padding around the image
                        decoration: BoxDecoration(
                          color: colorScheme.onSurface, // Background color for the box
                          borderRadius: BorderRadius.circular(12), // Rounded corners
                        ),
                        child: Image.asset(
                          'assets/brain.png',
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.07,
                    right: MediaQuery.of(context).size.height * 0.0565,
                    child: GestureDetector(
                      onTap: () => showOrganDialog(context, "Eyes"),
                      child: Container( // NEW: Container for background
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: colorScheme.onSurface,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: colorScheme.surface, width: 2)
                        ),
                        child: Image.asset(
                          'assets/eyes.png',
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.15,
                    right: 40,
                    child: GestureDetector(
                      onTap: () => showOrganDialog(context, "Heart"),
                      child: Container( // NEW: Container for background
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: colorScheme.surface.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: colorScheme.onSurface, width: 2)
                        ),
                        child: Image.asset(
                          'assets/heart.png',
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.30,
                    left: 40,
                    child: GestureDetector(
                      onTap: () => showOrganDialog(context, "Lungs"),
                      child: Container( // NEW: Container for background
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.surface.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.asset(
                          'assets/lungs.png',
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.5,
                    left: 40,
                    child: GestureDetector(
                      onTap: () => showOrganDialog(context, "Muscles"),
                      child: Container( // NEW: Container for background
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.surface.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.asset(
                          'assets/muscle.png',
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 40,
                    child: GestureDetector(
                      onTap: () => showOrganDialog(context, "Legs"),
                      child: Container( // NEW: Container for background
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.surface.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.asset(
                          'assets/legs.png',
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _tabController.animateTo(
            index,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        },
        items: _topTabs.map((tabName) {
          IconData outlineIcon;
          IconData filledIcon;
          double iconSize = 24.0; // Default size
          double selectedIconSize = 28.0; // Slightly larger when selected

          switch (tabName) {
            case 'Home':
              outlineIcon = Ionicons.home_outline;
              filledIcon = Ionicons.home;
              break;
            case 'Body':
              outlineIcon = Ionicons.body_outline;
              filledIcon = Ionicons.body;
              break;
            case 'Nutrition':
              outlineIcon = Ionicons.fast_food_outline;
              filledIcon = Ionicons.fast_food;
              break;
            case 'Mascot':
              outlineIcon = Ionicons.paw_outline;
              filledIcon = Ionicons.paw;
              break;
            default:
              outlineIcon = Ionicons.help_circle_outline;
              filledIcon = Ionicons.help_circle;
          }

          final bool isSelected = _selectedIndex == _topTabs.indexOf(tabName);

          return BottomNavigationBarItem(
            icon: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: isSelected ? selectedIconSize : iconSize,
              width: isSelected ? selectedIconSize : iconSize,
              alignment: Alignment.center,
              child: Icon(
                isSelected ? filledIcon : outlineIcon,
                size: isSelected ? selectedIconSize : iconSize,
                color: isSelected ? colorScheme.secondary : colorScheme.onSecondary.withOpacity(0.6),
              ),
            ),
            label: tabName,
          );
        }).toList(),
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.secondary,
        unselectedItemColor: colorScheme.onSecondary.withOpacity(0.6),
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
        unselectedLabelStyle: theme.textTheme.labelSmall,
      ),
    );
  }

  void showOrganDialog(BuildContext context, String organName) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    String dialogContent;
    final Map<String, dynamic>? organInfo = AppData.organData[organName]?.cast<String, dynamic>();
    final String imagePath = organInfo?['image'] as String? ?? 'assets/placeholder.png'; // Get image path

    if (organInfo != null) {
      if (_currentMode == 'fun') {
        dialogContent =  "Wanna learn more about $organName?";
      } else {
        dialogContent =  "Would you like to learn more about the $organName?";
      }
    } else {
      dialogContent = "No information available for $organName yet.";
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: colorScheme.surface,
        title: Text(
          organName,
          style: theme.textTheme.titleLarge,
        ),
        content: Text(
          dialogContent,
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "No",
              style: TextStyle(color: colorScheme.error),
            ),
          ),
          TextButton(
            onPressed: () async { // MODIFIED: Added async
              Navigator.pop(context);
              // NEW: Save last visited organ
              await saveLastVisitedOrgan(organName, imagePath); // Call the new function
              // Update the notifier in HomePage
              widget.lastVisitedOrganNotifier.value = await loadLastVisitedOrgan(); // Update notifier

              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => OrganDetailPage(
                    organName: organName,
                    mode: _currentMode,
                    organData: AppData.organData[organName]!,
                    organ: organName,
                  ),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 400),
                ),
              );
            },
            child: Text(
              "Yes",
              style: TextStyle(color: colorScheme.secondary),
            ),
          ),
        ],
      ),
    );
  }
}
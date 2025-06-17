// lib/body_screen.dart (MODIFIED - Curved Navigation Bar with outlined/filled icons)

import 'package:flutter/material.dart';
import 'package:ishaan/organ_detail_page.dart';
import 'package:ishaan/mascot_page.dart' hide HomePage;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ishaan/nutrition_tab_content.dart';
import 'package:ishaan/settings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ionicons/ionicons.dart'; // Import Ion Icons
import 'package:ishaan/home_page.dart'; // Import HomePage

import 'app_data.dart' as AppData;
import 'package:ishaan/main.dart'; // Import main.dart to access global notifiers
import 'package:ishaan/shared_preferences_helper.dart' hide lastVisitedNutritionNotifier, saveLastVisitedOrgan; // Import the helper

// Import the curved_navigation_bar package
import 'package:curved_navigation_bar/curved_navigation_bar.dart';


class BodyScreen extends StatefulWidget {
  final String mode;
  final ValueNotifier<ThemeMode> themeModeNotifier;
  final ValueNotifier<String> bodyModelNotifier;

  final ValueNotifier<Map<String, String>?> lastVisitedOrganNotifier;
  final ValueNotifier<Map<String, String>?> lastVisitedNutritionNotifier;


  const BodyScreen({
    super.key,
    required this.mode,
    required this.themeModeNotifier,
    required this.bodyModelNotifier,
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

  final List<String> _topTabs = ['Home', 'Nutrition', 'Mascot', 'Body'];

  int _selectedIndex = 0;

  // GlobalKey for CurvedNavigationBar, to allow programmatic control
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();


  @override
  void initState() {
    super.initState();
    _currentMode = widget.mode;
    _tabController = TabController(length: _topTabs.length, vsync: this);
    flutterTts = FlutterTts();
    _initializeTtsGeneral();

    _tabController.addListener(() {
      if (_selectedIndex != _tabController.index) {
        setState(() {
          _selectedIndex = _tabController.index;
        });
        flutterTts.stop();
        // Use setPage on the CurvedNavigationBar to sync when TabController changes
        _bottomNavigationKey.currentState?.setPage(_selectedIndex);
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

  String _getBodyImagePath(String modelKey) {
    String path;
    switch (modelKey) {
      case 'female_body':
        path = 'assets/female_body.png';
        break;
      case 'male_body':
      default:
        path = 'assets/male_body.png';
        break;
    }
    print('BodyScreen: _getBodyImagePath called with "$modelKey", returning path: "$path"');
    return path;
  }

  void _navigateToSettingsPage() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SettingsPage(
          themeModeNotifier: widget.themeModeNotifier,
          bodyModelNotifier: widget.bodyModelNotifier,
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

    String welcomeLottiePath;
    if (widget.themeModeNotifier.value == ThemeMode.dark) {
      welcomeLottiePath = 'assets/animations/dark/welcome.json';
    } else {
      welcomeLottiePath = 'assets/animations/light/welcome.json';
    }

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
          HomePage(
            mode: _currentMode,
            themeModeNotifier: widget.themeModeNotifier,
            lastVisitedOrganNotifier: widget.lastVisitedOrganNotifier,
            lastVisitedNutritionNotifier: widget.lastVisitedNutritionNotifier,
          ),
          NutritionTabContent(currentMode: _currentMode, themeModeNotifier: widget.themeModeNotifier, lastVisitedNutritionNotifier: widget.lastVisitedNutritionNotifier),
          MascotPage(mode: _currentMode),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.7,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ValueListenableBuilder<String>(
                    valueListenable: widget.bodyModelNotifier,
                    builder: (context, currentModelKey, child) {
                      print('BodyScreen: ValueListenableBuilder rebuilding for 2D image. Current model key: "$currentModelKey"');
                      return Image.asset(
                        _getBodyImagePath(currentModelKey),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          print('Error loading body image: $error');
                          return const Center(
                            child: Icon(Icons.broken_image, size: 100, color: Colors.red),
                          );
                        },
                      );
                    },
                  ),

                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.01,
                    right: MediaQuery.of(context).size.height * 0.04,
                    child: GestureDetector(
                      onTap: () => showOrganDialog(context, "Brain"),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.onSurface,
                          borderRadius: BorderRadius.circular(8),
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
                    top: MediaQuery.of(context).size.height * 0.09,
                    right: MediaQuery.of(context).size.height * 0.04,
                    child: GestureDetector(
                      onTap: () => showOrganDialog(context, "Eyes"),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.onSurface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset(
                          'assets/eyes.png',
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.17,
                    right: MediaQuery.of(context).size.height * 0.04,
                    child: GestureDetector(
                      onTap: () => showOrganDialog(context, "Heart"),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.onSurface,
                          borderRadius: BorderRadius.circular(8),

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
                    top: MediaQuery.of(context).size.height * 0.15,
                    left: MediaQuery.of(context).size.height * 0.04,
                    child: GestureDetector(
                      onTap: () => showOrganDialog(context, "Lungs"),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.onSurface,
                          borderRadius: BorderRadius.circular(8),
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
                    left:  MediaQuery.of(context).size.height * 0.04,
                    child: GestureDetector(
                      onTap: () => showOrganDialog(context, "Muscles"),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.onSurface,
                          borderRadius: BorderRadius.circular(8),
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
                    top: MediaQuery.of(context).size.height * 0.227,
                    left:  MediaQuery.of(context).size.height * 0.04,
                    child: GestureDetector(
                      onTap: () => showOrganDialog(context, "Liver"),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.onSurface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset(
                          'assets/liver.png',
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.33,
                    right:  MediaQuery.of(context).size.height * 0.04,
                    child: GestureDetector(
                      onTap: () => showOrganDialog(context, "Stomach"),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.onSurface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset(
                          'assets/stomach.png',
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.49,
                    right:  MediaQuery.of(context).size.height * 0.04,
                    child: GestureDetector(
                      onTap: () => showOrganDialog(context, "Legs"),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.onSurface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset(
                          'assets/legs.png',
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.25,
                    right:  MediaQuery.of(context).size.height * 0.04,
                    child: GestureDetector(
                      onTap: () => showOrganDialog(context, "Kidneys"),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.onSurface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset(
                          'assets/kidneys.png',
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.41,
                    right:  MediaQuery.of(context).size.height * 0.04,
                    child: GestureDetector(
                      onTap: () => showOrganDialog(context, "Bladder"),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.onSurface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset(
                          'assets/bladder.png',
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.41,
                    left:  MediaQuery.of(context).size.height * 0.04,
                    child: GestureDetector(
                      onTap: () => showOrganDialog(context, "Large Intestine"),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.onSurface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset(
                          'assets/largeintestine.png',
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
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey, // Assign the GlobalKey
        index: _selectedIndex, // Current selected index
        height: 90.0, // Height of the navigation bar

        // Define the items (icons) dynamically based on _topTabs
        items: _topTabs.asMap().entries.map((entry) { // Use asMap().entries to get both index and value
          final int index = entry.key;
          final String tabName = entry.value;

          IconData outlineIcon;
          IconData filledIcon;

          // Determine icon based on tabName
          switch (tabName) {
            case 'Home':
              outlineIcon = Ionicons.home_outline;
              filledIcon = Ionicons.home;
              break;
            case 'Nutrition':
              outlineIcon = Ionicons.fast_food_outline;
              filledIcon = Ionicons.fast_food;
              break;
            case 'Mascot':
              outlineIcon = Ionicons.paw_outline;
              filledIcon = Ionicons.paw;
              break;
            case 'Body':
              outlineIcon = Ionicons.body_outline;
              filledIcon = Ionicons.body;
              break;
            default:
              outlineIcon = Icons.help_outline; // Fallback icon
              filledIcon = Icons.help;
          }

          final bool isSelected = _selectedIndex == index; // Check if the current tab is selected

          return Icon(
            isSelected ? filledIcon : outlineIcon, // Use filled or outlined icon
            size: 33, // Keep a consistent size for icons within CurvedNavigationBar
            color: colorScheme.onSecondary, // Icons should be visible against the buttonBackgroundColor (secondary)
          );
        }).toList(),

        color: colorScheme.surface, // Background color of the entire bar
        buttonBackgroundColor: colorScheme.secondary, // Color of the selected tab's circular button
        backgroundColor: Colors.transparent, // Color of the Scaffold's background that shows through the curve.

        // Animation properties
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 450),

        // Callback when a tab is tapped
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Update the current page index
          });
          _tabController.animateTo(
            index,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        },
        letIndexChange: (index) => true, // Allows the index to change on tap
      ),
    );
  }

  void showOrganDialog(BuildContext context, String organName) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    String dialogContent;
    final Map<String, dynamic>? organInfo = AppData.organData[organName]?.cast<String, dynamic>();
    final String imagePath = organInfo?['image'] as String? ?? 'assets/placeholder.png';

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
            onPressed: () async {
              Navigator.pop(context);
              await saveLastVisitedOrgan(organName, imagePath);
              widget.lastVisitedOrganNotifier.value = await loadLastVisitedOrgan();

              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => OrganDetailPage(
                    organ: organName,
                    mode: _currentMode, organName: '', organData: {},
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
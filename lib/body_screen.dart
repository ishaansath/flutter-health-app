// lib/body_screen.dart

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ishaan/organ_detail_page.dart';
import 'package:ishaan/mascot_page.dart';
import 'package:ishaan/app_data.dart';
import 'package:ishaan/item_detail_page.dart';
import 'package:ishaan/nutrition_item_model.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:ishaan/nutrition_tab_content.dart';
import 'package:ishaan/settings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'app_data.dart' as AppData;


class BodyScreen extends StatefulWidget {
  final String mode;
  final ValueNotifier<ThemeMode> themeModeNotifier;

  const BodyScreen({
    super.key,
    required this.mode,
    required this.themeModeNotifier,
  });

  @override
  State<BodyScreen> createState() => _BodyScreenState();
}

class _BodyScreenState extends State<BodyScreen> with SingleTickerProviderStateMixin {
  late String _currentMode;
  late TabController _tabController;
  late FlutterTts flutterTts;

  final List<String> _topTabs = ['Body', 'Nutrition', 'Mascot'];

  // This variable correctly holds the currently selected index for the BottomNavigationBar
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentMode = widget.mode;
    _tabController = TabController(length: _topTabs.length, vsync: this);
    flutterTts = FlutterTts();
    _initializeTtsGeneral();

    // The key fix is here: listen directly to `_tabController.index` changes
    _tabController.addListener(() {
      // Only update if the index has actually changed to avoid unnecessary setState calls
      if (_selectedIndex != _tabController.index) {
        setState(() {
          _selectedIndex = _tabController.index;
        });
        // Stop TTS when the tab changes, regardless of whether it was a tap or swipe
        flutterTts.stop();
      }
    });

    // Initialize _selectedIndex with the initial tab controller index
    _selectedIndex = _tabController.index;
  }

  void _navigateToSettingsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsPage(
          themeModeNotifier: widget.themeModeNotifier,
        ),
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

  @override
  void dispose() {
    _tabController.dispose();
    flutterTts.stop();
    super.dispose();
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

    const TextStyle emojiStyle = TextStyle(fontSize: 20);

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
              // --- MODIFIED: Added Container for the border ---
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.secondary, // Choose your border color
                    width: 2.0, // Choose your border width
                  ),
                ),
                child: CircleAvatar(
                  radius: 20, // Keep the radius for the avatar content
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
          Stack(
            children: [
              Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.8,
                    maxWidth: MediaQuery.of(context).size.width * 0.8,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final height = constraints.maxHeight;
                      final width = height * 0.55;

                      return Center(
                        child: SizedBox(
                          height: height,
                          width: width,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset('assets/body_outline.png', fit: BoxFit.contain),
                              // Brain
                              Positioned(
                                top: height * 0.19,
                                left: width * 0.3655,
                                child: GestureDetector(
                                  onTap: () => showOrganDialog(context, "Brain"),
                                  child: const Text("🧠", style: emojiStyle),
                                ),
                              ),
                              // Eyes
                              Positioned(
                                top: height * 0.22,
                                left: width * 0.3655,
                                child: GestureDetector(
                                  onTap: () => showOrganDialog(context, "Eyes"),
                                  child: const Text("👁️", style: emojiStyle),
                                ),
                              ),
                              // Heart
                              Positioned(
                                top: height * 0.32,
                                left: width * 0.42,
                                child: GestureDetector(
                                  onTap: () => showOrganDialog(context, "Heart"),
                                  child: const Text("❤️", style: emojiStyle),
                                ),
                              ),
                              // Lungs
                              Positioned(
                                top: height * 0.35,
                                left: width * 0.3655,
                                child: GestureDetector(
                                  onTap: () => showOrganDialog(context, "Lungs"),
                                  child: const Text("🫁", style: emojiStyle),
                                ),
                              ),
                              // Muscles - Assuming Muscles are a category in your organData
                              Positioned(
                                top: height * 0.39,
                                left: width * 0.23,
                                child: GestureDetector(
                                  onTap: () => showOrganDialog(context, "Muscles"),
                                  child: const Text("💪", style: emojiStyle),
                                ),
                              ),
                              // Stomach
                              Positioned(
                                top: height * 0.43,
                                left: width * 0.3655,
                                child: GestureDetector(
                                  onTap: () => showOrganDialog(context, "Stomach"),
                                  child: const Text("🍽️", style: emojiStyle),
                                ),
                              ),
                              // Legs - Assuming Legs are a category in your organData
                              Positioned(
                                top: height * 0.62,
                                left: width * 0.30,
                                child: GestureDetector(
                                  onTap: () => showOrganDialog(context, "Legs"),
                                  child: const Text("🦵", style: emojiStyle),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),

          NutritionTabContent(currentMode: _currentMode),

          MascotPage(mode: _currentMode),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        // The currentIndex must be updated to match the TabController's index
        currentIndex: _selectedIndex, // Now correctly uses _selectedIndex
        onTap: (index) {
          // Update both _selectedIndex and TabController's index
          setState(() {
            _selectedIndex = index;
          });
          _tabController.animateTo(index); // This will animate the TabBarView
        },
        items: _topTabs.map((tabName) {
          IconData icon;
          switch (tabName) {
            case 'Body':
              icon = Icons.accessibility_new;
              break;
            case 'Nutrition':
              icon = Icons.fastfood;
              break;
            case 'Mascot':
              icon = Icons.pets;
              break;
            default:
              icon = Icons.help_outline;
          }
          return BottomNavigationBarItem(
            icon: Icon(icon),
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
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OrganDetailPage(
                    organName: organName,
                    mode: _currentMode,
                    organData: AppData.organData[organName]!,
                    organ: organName,
                  ),
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
// lib/body_screen.dart (FIXED - line 261)

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ishaan/organ_detail_page.dart';
import 'package:ishaan/mascot_page.dart';
import 'package:ishaan/app_data.dart';
import 'package:ishaan/item_detail_page.dart';
import 'package:ishaan/nutrition_item_model.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'settings_page.dart';

// NEW: Import the NutritionTabContent from its correct path
import 'package:ishaan/nutrition_tab_content.dart';

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

  @override
  void initState() {
    super.initState();
    _currentMode = widget.mode;
    widget.themeModeNotifier.addListener(_updateThemeIcon);

    _tabController = TabController(length: _topTabs.length, vsync: this);
    flutterTts = FlutterTts();
    _initializeTtsGeneral();

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        flutterTts.stop();
      }
    });
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
    widget.themeModeNotifier.removeListener(_updateThemeIcon);
    _tabController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  void _updateThemeIcon() {
    if (mounted) {
      setState(() {
        // Force a rebuild for the theme icon when theme changes.
      });
    }
  }

  void _toggleTheme() {
    widget.themeModeNotifier.value =
    widget.themeModeNotifier.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
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

    const TextStyle emojiStyle = TextStyle(fontSize: 20);

    return Scaffold(
      backgroundColor: colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: kToolbarHeight * 0.65,
        bottom: TabBar(
          controller: _tabController,
          labelColor: colorScheme.onPrimary,
          unselectedLabelColor: colorScheme.onPrimary.withOpacity(0.7),
          indicatorColor: colorScheme.secondary,
          tabs: _topTabs.map((tabName) => Tab(text: tabName)).toList(),
        ),
          actions: [
      Padding(
      padding: const EdgeInsets.only(right: 16.0), // Adjust padding as needed
      child: IconButton( // Using IconButton for better tap feedback
        icon: Icon(Icons.settings, color: colorScheme.onSecondary),
        onPressed: () {Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SettingsPage(), // <--- NAVIGATE HERE
          ),
        );
        }
         ),
      )],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // --- Tab 1: Body Outline Content (Original Stack) ---
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

              Positioned(
                bottom: 20,
                left: 20,
                child: FloatingActionButton(
                  heroTag: 'theme_toggle',
                  onPressed: _toggleTheme,
                  backgroundColor: colorScheme.secondary,
                  foregroundColor: colorScheme.onSecondary,
                  child: Icon(widget.themeModeNotifier.value == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
                ),
              ),

              Positioned(
                bottom: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow( // Corrected from BoxBoxShadow
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: _toggleMode,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _currentMode == 'normal' ? 'Normal' : 'Fun',
                          style: theme.textTheme.labelLarge,
                        ),
                        const SizedBox(width: 8),
                        Switch(
                          value: _currentMode == 'fun',
                          onChanged: (newValue) => _toggleMode(),
                          activeColor: colorScheme.secondary,
                          inactiveThumbColor: colorScheme.secondary,
                          inactiveTrackColor: colorScheme.onSurface.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // --- Tab 2: Nutrition Content (Now using NutritionTabContent) ---
          // FIX: Add 'const' keyword and pass currentMode
          NutritionTabContent(currentMode: _currentMode), // Line 261

          // --- Tab 3: Mascot Content ---
          const MascotPage(),
        ],
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
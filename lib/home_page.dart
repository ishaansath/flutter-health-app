// lib/home_page.dart

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
// import 'package:ishaan/main.dart'; // This import is likely unnecessary and can cause issues, remove if unused
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ishaan/organ_detail_page.dart';
import 'package:ishaan/item_detail_page.dart';
import 'package:provider/provider.dart';
import 'package:ishaan/mascot_provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ishaan/auth_firebase_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ishaan/shared_preferences_helper.dart'; // Ensure this import is present for save/load functions

import 'app_data.dart' as AppData;

class HomePage extends StatefulWidget {
  final String mode;
  final ValueNotifier<ThemeMode> themeModeNotifier;
  final ValueNotifier<Map<String, String>?> lastVisitedNutritionNotifier;
  final ValueNotifier<Map<String, String>?> lastVisitedOrganNotifier;

  const HomePage({
    super.key,
    required this.mode,
    required this.themeModeNotifier,
    required this.lastVisitedNutritionNotifier,
    required this.lastVisitedOrganNotifier,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _lastVisitedOrganName;
  String? _lastVisitedOrganImagePath;
  // Change to a list for multiple nutrition items
  List<Map<String, String>> _lastVisitedNutritionItems = [];
  FlutterTts _flutterTts = FlutterTts();
  String _greetingMessage = '';
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadLastVisited();
    _fetchUserName();

    widget.lastVisitedOrganNotifier.addListener(_updateLastVisitedOrgan);
    widget.lastVisitedNutritionNotifier.addListener(_updateLastVisitedNutritionItem);
  }

  @override
  void dispose() {
    widget.lastVisitedOrganNotifier.removeListener(_updateLastVisitedOrgan);
    widget.lastVisitedNutritionNotifier.removeListener(_updateLastVisitedNutritionItem);
    super.dispose();
  }

  void _updateLastVisitedOrgan() {
    setState(() {
      _lastVisitedOrganName = widget.lastVisitedOrganNotifier.value?['name'];
      _lastVisitedOrganImagePath = widget.lastVisitedOrganNotifier.value?['imagePath'];
    });
  }

  void _updateLastVisitedNutritionItem() {
    // This notifier will trigger when *any* new nutrition item is visited.
    // We need to re-load the two most recent items from SharedPreferences.
    _loadLastVisitedNutritionItems();
  }

  Future<void> _loadLastVisited() async {
    // Use the helper functions for loading
    final Map<String, String>? organData = await loadLastVisitedOrgan();
    setState(() {
      _lastVisitedOrganName = organData?['name'];
      _lastVisitedOrganImagePath = organData?['imagePath'];
    });
    _loadLastVisitedNutritionItems(); // Load nutrition items separately
  }

  Future<void> _loadLastVisitedNutritionItems() async {
    // This part of loading nutrition items should ideally also use a helper
    // function that returns a List<Map<String, String>> for the two most recent.
    // For now, keeping your existing logic here.
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

    setState(() {
      _lastVisitedNutritionItems = loadedItems;
    });
  }

  Future<void> _fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final authService = FirebaseAuthService();
      final userProfile = await authService.getUserProfile(user.uid);
      if (userProfile != null && userProfile.firstName.isNotEmpty) {
        setState(() {
          _userName = userProfile.firstName;
        });
      } else {
        setState(() {
          _userName = user.displayName?.split(' ').first;
        });
      }
    }
  }

  Future<void> _speak(String text) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mascotProvider = Provider.of<MascotProvider>(context);

    String welcomeLottiePath;
    if (widget.themeModeNotifier.value == ThemeMode.dark) {
      welcomeLottiePath = 'assets/animations/dark/welcome.json';
    } else {
      welcomeLottiePath = 'assets/animations/light/welcome.json';
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              welcomeLottiePath,
              repeat: true,
              height: 200,
              width: 300,
              fit: BoxFit.contain,
            ),

            // Last Visited Organ Card
            if (_lastVisitedOrganName != null && _lastVisitedOrganImagePath != null)
              Card(
                color: colorScheme.surface,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                elevation: 2,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrganDetailPage(
                          organName: _lastVisitedOrganName!,
                          mode: widget.mode,
                          organData: AppData.organData[_lastVisitedOrganName]!,
                          organ: _lastVisitedOrganName!,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // --- START OF IMAGE DISPLAY FIX & SIZE ADJUSTMENT ---
                        ClipRRect( // Use ClipRRect for rounded corners on the image directly
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            _lastVisitedOrganImagePath!,
                            width: 40,  // HALF SIZE
                            height: 40, // HALF SIZE
                            fit: BoxFit.cover, // Use cover to fill the box without distortion
                            errorBuilder: (context, error, stackTrace) {
                              // This will print to your debug console if the image fails to load
                              print('Error loading last visited organ image: $error');
                              // Display a broken image icon as a fallback
                              return Container(
                                width: 40, // Match desired half size
                                height: 40, // Match desired half size
                                color: Colors.grey[300], // Placeholder background
                                child: Icon(
                                  Icons.broken_image,
                                  size: 24, // Smaller icon for smaller container
                                  color: Colors.red,
                                ),
                              );
                            },
                          ),
                        ),
                        // --- END OF IMAGE DISPLAY FIX & SIZE ADJUSTMENT ---
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Recently Visited',
                                style: theme.textTheme.titleSmall,
                              ),
                              Text(
                                _lastVisitedOrganName!,
                                style: theme.textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              // Note: This AppData.organData[_lastVisitedOrganName]?[''] is likely incorrect.
                              // You might want AppData.organData[_lastVisitedOrganName]?['briefInfo']
                              Text(
                                AppData.organData[_lastVisitedOrganName]?['briefInfo'] ?? 'No brief info available.',
                                style: theme.textTheme.bodyMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.volume_up, color: colorScheme.onSecondary),
                          onPressed: () {
                            _speak(AppData.organData[_lastVisitedOrganName]?['briefInfo'] ?? 'No information available.');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Last Visited Nutrition Items (Side-by-Side)
            if (_lastVisitedNutritionItems.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recently Visited Nutrition',
                  style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onBackground),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 180, // Adjust height as needed for the cards
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _lastVisitedNutritionItems.length,
                  itemBuilder: (context, index) {
                    final item = _lastVisitedNutritionItems[index];
                    final itemName = item['name']!;
                    final itemImagePath = item['imagePath']!;
                    // Assuming 'All' category exists and contains all items for lookup
                    // This lookup might be inefficient for large datasets.
                    final itemData = AppData.generalNutritionData['All']!
                        .firstWhere((data) => data['name'] == itemName, orElse: () => {});

                    return Card(
                      color: colorScheme.surface,
                      margin: const EdgeInsets.only(right: 12.0), // Spacing between cards
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      elevation: 2,
                      child: InkWell(
                        onTap: () {
                          if (itemData.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ItemDetailPage(
                                  name: itemData['name']!,
                                  modelPath: itemData['modelPath'] ?? '',
                                  description: widget.mode == 'fun' ? itemData['funModeDescription']! : itemData['normalModeDescription']!,
                                  additionalInfo: itemData['additionalInfo'] ?? '',
                                  additionalInfoExtra: itemData['additionalInfoExtra'] ?? '',
                                  image: itemData['image']!,
                                  mode: widget.mode,
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          width: 160, // Fixed width for each card
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: colorScheme.tertiaryContainer,
                                  borderRadius: BorderRadius.circular(8.0),
                                  image: DecorationImage(
                                    image: AssetImage(itemImagePath),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                itemName,
                                style: theme.textTheme.titleSmall,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                itemData['shortDescription'] ?? '',
                                style: theme.textTheme.bodySmall,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Random Fact Card
            Card(
              color: colorScheme.surface,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Did You Know?',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'The human brain weighs about 3 pounds but uses 20% of the body\'s oxygen and calories?',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            Card(
              color: colorScheme.surface,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Daily Goal',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Remember to stay hydrated! Aim for 8 glasses of water today.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Ensure you have these helper extensions/classes if they are not already defined elsewhere
// This looks like it was generated by the IDE, but ensure it's correct.
extension on Map<String, dynamic> {
  firstWhere(bool Function(dynamic data) param0, {required Map Function() orElse}) {}
  // This extension method seems problematic as 'All' is a List<Map<String, dynamic>>
  // and firstWhere should be on the List, not the Map itself.
  // Consider if AppData.generalNutritionData['All']! is actually a List or Map.
  // If 'All' is a List, this extension should be removed.
  // For now, I'm assuming it might be a typo, and the lookup
  // `AppData.generalNutritionData['All']!.firstWhere` is intended to work.
  // firstWhere(bool Function(dynamic data) param0, {required Map Function() orElse}) {}
}

// Assuming FirebaseAuthService is a class defined elsewhere in your project
// If not, you'll need to define it.
FirebaseAuthService() {
}
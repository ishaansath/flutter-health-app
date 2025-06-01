// lib/home_page.dart

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ishaan/main.dart'; // Make sure main.dart has saveLastVisitedNutrition
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ishaan/organ_detail_page.dart';
import 'package:ishaan/item_detail_page.dart';
import 'package:provider/provider.dart';
import 'package:ishaan/mascot_provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ishaan/auth_firebase_data.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lastVisitedOrganName = prefs.getString('lastVisitedOrganName');
      _lastVisitedOrganImagePath = prefs.getString('lastVisitedOrganImagePath');
    });
    _loadLastVisitedNutritionItems(); // Load nutrition items separately
  }

  Future<void> _loadLastVisitedNutritionItems() async {
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
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8.0),
                            image: DecorationImage(
                              image: AssetImage(_lastVisitedOrganImagePath!),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Last Visited Organ',
                                style: theme.textTheme.titleSmall,
                              ),
                              Text(
                                _lastVisitedOrganName!,
                                style: theme.textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                AppData.organData[_lastVisitedOrganName]?[''] ?? '',
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

extension on Map<String, dynamic> {
  firstWhere(bool Function(dynamic data) param0, {required Map Function() orElse}) {}
}

FirebaseAuthService() {
}